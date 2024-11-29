import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

import '../../utils/token_storage.dart'; // Pour storeAccessToken
import '../../providers/auth_provider.dart'; // Pour authProvider

class LoginModal extends ConsumerStatefulWidget {
  const LoginModal({super.key});

  @override
  ConsumerState<LoginModal> createState() => _LoginModalState();
}

class _LoginModalState extends ConsumerState<LoginModal> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginUser() async {
    final String apiUrl = '${dotenv.get('API_BASE_URL')}/auth/login';

    setState(() {
      _isLoading = true;
    });

    try {
      // Logique de requête POSTS
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Stocker le token
        await storeAccessToken(responseData['token']);

        // Mettre à jour l'état global avec Riverpod
        ref.read(authProvider.notifier).login(responseData['token']);

        // Rediriger vers l'écran principal
        Navigator.of(context).pushReplacementNamed('/spots');
      } else {
        _showMessage(responseData['message'] ?? 'Erreur lors de la connexion.');
      }
    } catch (e) {
      _showMessage('Erreur réseau : ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleGoogleLogin() async {
    try {
      final url = "https://spotcast-dev.loca.lt/auth/google";
      final result = await FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: "com.example.spotcast",
      );
      final token = Uri.parse(result).queryParameters['token'];
      if (token != null) {
        await storeAccessToken(token);
        ref.read(authProvider.notifier).login(token);
        Navigator.of(context).pushReplacementNamed('/spots');
      } else {
        print("Échec de l'authentification via Google");
      }
    } catch (e) {
      print("Erreur lors de l'authentification Google : $e");
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showForgotPasswordDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Réinitialiser le mot de passe'),
          content: const Text(
              'Veuillez entrer votre email pour recevoir un lien de réinitialisation.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Envoyer'),
            ),
          ],
        );
      },
    );
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
                'Connexion',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Nunito',
                ),
              ),
              const SizedBox(height: 8),

              // Bouton "Continuer avec Google"
              ElevatedButton.icon(
                onPressed: _handleGoogleLogin,
                icon: Image.asset(
                  'assets/icon/google_logo.png',
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

              // Champ d'email
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 10, fontFamily: 'Nunito'),
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
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
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Bouton de connexion
              ElevatedButton(
                onPressed: _isLoading ? null : _loginUser,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B3A57),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Se connecter',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
              ),
              const SizedBox(height: 10),

              // Bouton "Mot de passe oublié ?"
              TextButton(
                onPressed: _showForgotPasswordDialog,
                child: const Text(
                  'Mot de passe oublié ?',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
