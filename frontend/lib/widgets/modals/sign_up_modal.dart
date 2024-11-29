import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../providers//auth_provider.dart';
import '../../utils/token_storage.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

class SignUpModal extends ConsumerStatefulWidget {
  const SignUpModal({super.key});

  @override
  ConsumerState<SignUpModal> createState() => _SignUpModalState();
}

class _SignUpModalState extends ConsumerState<SignUpModal> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _isLoading = false;

  // Nouveau gestionnaire temporaire pour Google Sign-Up
  void _handleGoogleSignUp() async {
    try {
      final url = "https://spotcast-dev.loca.lt/auth/google";
      final result = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: "com.example.spotcast",
      );
      final token = Uri.parse(result).queryParameters['token'];
      if (token != null) {
        print("Authentification réussie, token : $token");
      } else {
        print("Échec de l'authentification");
      }
    } catch (e) {
      print("Erreur lors de l'authentification : $e");
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _registerUser(BuildContext context) async {
    final String apiUrl =
        '${dotenv.get('API_BASE_URL', fallback: 'http://localhost:3000')}/users/register';

    bool isValidEmail(String email) {
      final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
      return emailRegex.hasMatch(email);
    }

    bool isValidPassword(String password) {
      return password.length >= 6;
    }

    if (!isValidEmail(_emailController.text)) {
      _showMessage('Veuillez entrer un email valide.');
      return;
    }
    if (!isValidPassword(_passwordController.text)) {
      _showMessage('Le mot de passe doit contenir au moins 6 caractères.');
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showMessage('Les mots de passe ne correspondent pas.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _usernameController.text.trim(),
          'email': _emailController.text.trim(),
          'password': _passwordController.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Stocker le token de manière sécurisée
        await storeAccessToken(responseData['token']);

        // Mettre à jour l'état d'authentification avec Riverpod
        ref.read(authProvider.notifier).login(responseData['token']);

        if (mounted) {
          // Rediriger vers la page principale
          Navigator.of(context).pushReplacementNamed('/profile');
        }
      } else {
        if (mounted) {
          _showMessage(
              responseData['message'] ?? 'Erreur lors de l\'inscription.');
        }
      }
    } catch (e) {
      if (mounted) {
        _showMessage('Erreur réseau : ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Inscription',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                ),
              ),
              const SizedBox(height: 8),
              // Bouton "Continuer avec Google"
              ElevatedButton.icon(
                onPressed: _handleGoogleSignUp,
                icon: Image.asset(
                  'assets/icon/google_logo.png', // Remplacez par le chemin réel de votre logo Google
                  height: 24,
                  width: 24,
                ),
                label: const Text(
                  'Continuer avec Google',
                  style: TextStyle(fontSize: 10, fontFamily: 'Nunito'),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                ),
              ),
              const SizedBox(height: 12),
              // Champ du nom d'utilisateur
              TextField(
                controller: _usernameController,
                style: const TextStyle(fontSize: 10, fontFamily: 'Nunito'),
                decoration: InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 8),
              // Champ d'email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 10, fontFamily: 'Nunito'),
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 8),
              // Champ de mot de passe
              TextField(
                controller: _passwordController,
                obscureText: true,
                style: const TextStyle(fontSize: 10, fontFamily: 'Nunito'),
                decoration: InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 8),
              // Champ de confirmation de mot de passe
              TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                style: const TextStyle(fontSize: 10, fontFamily: 'Nunito'),
                decoration: InputDecoration(
                  labelText: 'Confirmer le mot de passe',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 8),
              // Bouton d'inscription
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .center, // Centre les boutons horizontalement
                  children: [
                    // Bouton S'inscrire
                    ElevatedButton(
                      onPressed:
                          _isLoading ? null : () => _registerUser(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B3A57),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'S\'inscrire',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                    ),
                    const SizedBox(width: 16), // Espace entre les deux boutons

                    // Bouton Annuler
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red, // Couleur rouge pour le bouton Annuler
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                      ),
                      child: const Text(
                        'Annuler',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
