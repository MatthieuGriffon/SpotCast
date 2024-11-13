import 'package:flutter/material.dart';
import '../modals/login_modal.dart';
import '../modals/sign_up_modal.dart';

class CustomHeader extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onSignUp;
  final bool isLoggedIn;

  const CustomHeader({
    super.key,
    required this.onLogin,
    required this.onSignUp,
    this.isLoggedIn = true,
  });

  // Fonction pour afficher la modal de connexion
  void _showLoginModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const LoginModal(),
    );
  }

  // Fonction pour afficher la modal d'inscription
  void _showSignUpModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const SignUpModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF1B3A57).withOpacity(0.9),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25),
          bottomRight: Radius.circular(25),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Section pour afficher l'état de connexion
          Row(
            children: [
              Icon(
                isLoggedIn ? Icons.login_rounded : Icons.logout_rounded,
                color: isLoggedIn ? Colors.green : Colors.red,
                size: 24,
              ),
            ],
          ),

          // Section pour les boutons à droite
          Row(
            children: [
              // Bouton pour ouvrir la modal d'inscription
              ElevatedButton(
                onPressed: () =>
                    _showSignUpModal(context), // Ouvre la modal d'inscription
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Colors.white),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                ),
                child: const Text(
                  'Inscription',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),
              // Bouton pour ouvrir la modal de connexion
              SizedBox(
                width: screenWidth > 350 ? 100 : 80,
                child: ElevatedButton(
                  onPressed: () =>
                      _showLoginModal(context), // Ouvre la modal de connexion
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Connexion',
                    style: TextStyle(
                      color: Color(0xFF1B3A57),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
