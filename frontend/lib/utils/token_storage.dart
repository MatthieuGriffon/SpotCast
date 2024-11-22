import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorage = FlutterSecureStorage();

/// Stocke le token d'accès de manière sécurisée
Future<void> storeAccessToken(String token) async {
  await secureStorage.write(key: 'access_token', value: token);
}

/// Récupère le token d'accès stocké
Future<String?> getAccessToken() async {
  return await secureStorage.read(key: 'access_token');
}

/// Supprime le token d'accès
Future<void> deleteAccessToken() async {
  await secureStorage.delete(key: 'access_token');
}
