import 'package:flutter/foundation.dart';

/// TODO: Le développeur backend doit implémenter les vrais appels API ici
class AuthService {
  // Singleton
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  /// Fonction de déconnexion
  Future<void> logout() async {
    debugPrint('⏳ Appel Backend : Invalidation du token en cours...');
    await Future.delayed(const Duration(milliseconds: 500)); // Simulation de l'appel réseau
    
    debugPrint('🗑️ Suppression du token local (SharedPreferences/SecureStorage)...');
    await Future.delayed(const Duration(milliseconds: 200));

    debugPrint('✅ Déconnexion réussie.');
  }
}
