import 'package:flutter/material.dart';

class MockSettingsState extends ChangeNotifier {
  static final MockSettingsState _instance = MockSettingsState._internal();
  factory MockSettingsState() => _instance;
  MockSettingsState._internal();

  // 1. Général & Plateforme
  bool maintenanceMode = false;
  bool showGlobalBanner = true;
  String globalBannerText = "Soldes d'été : -20% sur tout le site !";
  String defaultCurrency = "FCFA (XOF)";
  String defaultLanguage = "Français";
  double defaultTaxRate = 20.0;

  // 2. Vendeurs & Commissions
  bool allowNewRegistrations = true;
  bool autoApproveSellers = false;
  double globalCommission = 12.0; 
  double fixedFeePerTransaction = 0.50;

  // 3. Catalogue & Produits
  bool autoApproveProducts = true;
  int maxImagesPerProduct = 5;
  int reportsBeforeAutoHide = 3;

  // 4. Paiements & Expéditions
  bool stripeEnabled = true;
  bool paypalEnabled = true;
  bool applePayEnabled = false;

  // 5. Sécurité
  bool twoFactorAuth = false;

  void updateSetting(VoidCallback action) {
    action();
    notifyListeners();
  }
}
