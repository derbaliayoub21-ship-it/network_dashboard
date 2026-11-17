class AuthState {
  final bool isLoggedIn;
  final bool isPinVerified;

  const AuthState({this.isLoggedIn = false, this.isPinVerified = false});

  AuthState copyWith({bool? isLoggedIn, bool? isPinVerified}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isPinVerified: isPinVerified ?? this.isPinVerified,
    );
  }
}

class AuthController {
  AuthState _state = const AuthState();

  AuthState get state => _state;

  bool login(String email, String password) {
    final validEmail = email.trim().isNotEmpty;
    final validPassword = password.trim().isNotEmpty;

    if (!validEmail || !validPassword) {
      _state = const AuthState();
      return false;
    }

    _state = _state.copyWith(isLoggedIn: true, isPinVerified: false);
    return true;
  }

  bool verifyPin(String pin) {
    final isValidPin = RegExp(r'^\d{6}$').hasMatch(pin) && pin == '123456';

    if (!isValidPin) {
      return false;
    }

    _state = _state.copyWith(isPinVerified: true);
    return true;
  }

  void logout() {
    _state = const AuthState();
  }
}

final authController = AuthController();
