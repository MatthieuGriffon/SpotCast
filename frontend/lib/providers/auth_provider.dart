import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Classe représentant l'état d'authentification
class AuthState {
  final bool isLoggedIn;
  final String? token;

  AuthState({required this.isLoggedIn, this.token});
}

/// StateNotifier pour gérer l'état d'authentification
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(AuthState(isLoggedIn: false));

  /// Connecte l'utilisateur en mettant à jour l'état avec un token
  void login(String token) {
    state = AuthState(isLoggedIn: true, token: token);
  }

  /// Déconnecte l'utilisateur en réinitialisant l'état
  void logout() {
    state = AuthState(isLoggedIn: false, token: null);
  }
}

/// Provider global pour l'état d'authentification
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
