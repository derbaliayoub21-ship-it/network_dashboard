import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// ---------- Couleurs ----------
const Color fond = Color(0xFF050B14);
const Color carte = Color(0xFF0B1624);
const Color bordure = Color(0xFF16304A);
const Color cyan = Color(0xFF00E5FF);
const Color vert = Color(0xFF00FF9C);
const Color rouge = Color(0xFFFF3B5C);
const Color orange = Color(0xFFFFB020);
const Color gris = Color(0xFF7B93AB);

// ---------- Données (modifie-les comme tu veux) ----------
// status peut être : 'online', 'warning' ou 'offline'
// cpu et ram vont de 0.0 à 1.0
final List<Map<String, dynamic>> serveurs = [
  {
    'nom': 'srv-web-01',
    'ip': '10.0.0.11',
    'status': 'online',
    'cpu': 0.42,
    'ram': 0.58,
  },
  {
    'nom': 'srv-db-01',
    'ip': '10.0.0.21',
    'status': 'warning',
    'cpu': 0.81,
    'ram': 0.74,
  },
  {
    'nom': 'srv-auth-01',
    'ip': '10.0.0.31',
    'status': 'online',
    'cpu': 0.27,
    'ram': 0.39,
  },
  {
    'nom': 'srv-backup',
    'ip': '10.0.0.41',
    'status': 'offline',
    'cpu': 0.0,
    'ram': 0.0,
  },
];

final List<Map<String, dynamic>> alertes = [
  {
    'message': 'CPU > 80 % sur srv-db-01',
    'temps': 'il y a 2 min',
    'critique': true,
  },
  {
    'message': 'srv-backup injoignable',
    'temps': 'il y a 14 min',
    'critique': true,
  },
  {
    'message': 'Latence élevée sur srv-web-01',
    'temps': 'il y a 1 h',
    'critique': false,
  },
];

// Valeurs du graphe (en pourcentage, de 0 à 100)
final List<double> valeursCpu = [
  30,
  45,
  50,
  40,
  65,
  70,
  55,
  60,
  80,
  75,
  50,
  45,
];
final List<double> valeursRam = [
  50,
  52,
  55,
  54,
  58,
  60,
  62,
  61,
  65,
  63,
  60,
  58,
];

// ---------- Application ----------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Network Dashboard',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: fond),
      home: const HomePage(),
    );
  }
}

// ---------- Page principale ----------
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // On récupère la largeur de l'écran
    final largeur = MediaQuery.of(context).size.width;
    final grandEcran = largeur > 800; // true = PC / tablette

    // ----- Statistiques -----
    Widget stats;
    if (grandEcran) {
      // 4 cases sur une seule ligne
      stats = Row(
        children: const [
          Expanded(
            child: StatCard(titre: 'En ligne', valeur: '2 / 4'),
          ),
          SizedBox(width: 12),
          Expanded(
            child: StatCard(titre: 'Alertes', valeur: '3'),
          ),
          SizedBox(width: 12),
          Expanded(
            child: StatCard(titre: 'CPU moy.', valeur: '50 %'),
          ),
          SizedBox(width: 12),
          Expanded(
            child: StatCard(titre: 'RAM moy.', valeur: '57 %'),
          ),
        ],
      );
    } else {
      // 2 lignes de 2 cases
      stats = Column(
        children: const [
          Row(
            children: [
              Expanded(
                child: StatCard(titre: 'En ligne', valeur: '2 / 4'),
              ),
              SizedBox(width: 12),
              Expanded(
                child: StatCard(titre: 'Alertes', valeur: '3'),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatCard(titre: 'CPU moy.', valeur: '50 %'),
              ),
              SizedBox(width: 12),
              Expanded(
                child: StatCard(titre: 'RAM moy.', valeur: '57 %'),
              ),
            ],
          ),
        ],
      );
    }

    // ----- Colonne de gauche : serveurs -----
    final colonneGauche = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Titre(texte: 'SERVEURS'),
        for (var s in serveurs)
          ServerCard(
            nom: s['nom'],
            ip: s['ip'],
            status: s['status'],
            cpu: s['cpu'],
            ram: s['ram'],
          ),
      ],
    );

    // ----- Colonne de droite : alertes et graphes -----
    final colonneDroite = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Titre(texte: 'ALERTES'),
        for (var a in alertes)
          AlertCard(
            message: a['message'],
            temps: a['temps'],
            critique: a['critique'],
          ),
        const SizedBox(height: 12),
        const Titre(texte: 'GRAPHES'),
        GraphCard(titre: 'CPU', valeurs: valeursCpu),
        GraphCard(titre: 'RAM', valeurs: valeursRam),
      ],
    );

    // ----- Disposition selon la taille de l'écran -----
    Widget contenu;
    if (grandEcran) {
      // PC / tablette : deux colonnes côte à côte
      contenu = Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: colonneGauche),
          const SizedBox(width: 24),
          Expanded(child: colonneDroite),
        ],
      );
    } else {
      // Téléphone : tout en une colonne
      contenu = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [colonneGauche, const SizedBox(height: 12), colonneDroite],
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: fond,
        title: const Text('Network'),
        actions: const [Icon(Icons.notifications_none), SizedBox(width: 16)],
      ),
      // Center + ConstrainedBox : le contenu ne dépasse pas 1000 pixels de large
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [stats, const SizedBox(height: 24), contenu],
          ),
        ),
      ),
    );
  }
}

// ---------- Petit titre de section ----------
class Titre extends StatelessWidget {
  final String texte;
  const Titre({super.key, required this.texte});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        texte,
        style: const TextStyle(color: cyan, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ---------- Case de statistique ----------
class StatCard extends StatelessWidget {
  final String titre;
  final String valeur;
  const StatCard({super.key, required this.titre, required this.valeur});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: carte,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bordure),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titre, style: const TextStyle(color: gris)),
          const SizedBox(height: 6),
          Text(
            valeur,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// ---------- Carte d'un serveur ----------
class ServerCard extends StatelessWidget {
  final String nom;
  final String ip;
  final String status;
  final double cpu;
  final double ram;

  const ServerCard({
    super.key,
    required this.nom,
    required this.ip,
    required this.status,
    required this.cpu,
    required this.ram,
  });

  @override
  Widget build(BuildContext context) {
    // On choisit la couleur et le texte selon le status
    Color couleur = vert;
    String texteStatus = 'En ligne';
    if (status == 'warning') {
      couleur = orange;
      texteStatus = 'Alerte';
    } else if (status == 'offline') {
      couleur = rouge;
      texteStatus = 'Hors ligne';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: carte,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bordure),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.dns_outlined, color: gris),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nom,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(ip, style: const TextStyle(color: gris, fontSize: 12)),
                  ],
                ),
              ),
              Text(
                texteStatus,
                style: TextStyle(color: couleur, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(
                'CPU ${(cpu * 100).round()} %',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LinearProgressIndicator(
                  value: cpu,
                  color: couleur,
                  backgroundColor: bordure,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'RAM ${(ram * 100).round()} %',
                style: const TextStyle(fontSize: 12),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LinearProgressIndicator(
                  value: ram,
                  color: couleur,
                  backgroundColor: bordure,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------- Carte d'une alerte ----------
class AlertCard extends StatelessWidget {
  final String message;
  final String temps;
  final bool critique;

  const AlertCard({
    super.key,
    required this.message,
    required this.temps,
    required this.critique,
  });

  @override
  Widget build(BuildContext context) {
    Color couleur = orange;
    if (critique) {
      couleur = rouge;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: carte,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: couleur),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: couleur),
          const SizedBox(width: 12),
          Expanded(child: Text(message)),
          Text(temps, style: const TextStyle(color: gris, fontSize: 11)),
        ],
      ),
    );
  }
}

// ---------- Graphe simple avec des barres ----------
class GraphCard extends StatelessWidget {
  final String titre;
  final List<double> valeurs;
  const GraphCard({super.key, required this.titre, required this.valeurs});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: carte,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: bordure),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titre,
            style: const TextStyle(color: cyan, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Une barre par valeur (100 % = 100 pixels de haut)
                for (var v in valeurs)
                  Container(
                    width: 14,
                    height: v,
                    decoration: BoxDecoration(
                      color: cyan,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
