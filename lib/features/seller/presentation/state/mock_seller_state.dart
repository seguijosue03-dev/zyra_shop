import 'package:flutter/foundation.dart';

enum SellerStatus {
  none,
  pending,
  contractRequired,
  active,
}

class MockSellerState extends ChangeNotifier {
  static final MockSellerState _instance = MockSellerState._internal();
  factory MockSellerState() => _instance;
  MockSellerState._internal();

  SellerStatus _status = SellerStatus.none;

  SellerStatus get status => _status;

  void submitRegistration() {
    _status = SellerStatus.pending;
    notifyListeners();
  }

  // Admin simulation shortcut
  void simulateAdminApproval() {
    if (_status == SellerStatus.pending) {
      _status = SellerStatus.contractRequired;
      notifyListeners();
    }
  }

  void acceptContract() {
    if (_status == SellerStatus.contractRequired) {
      _status = SellerStatus.active;
      notifyListeners();
    }
  }

  void reset() {
    _status = SellerStatus.none;
    notifyListeners();
  }

  // --- Dynamic Mock Store Data ---
  String storeName = "ZYRA Seller";
  String storeDescription = "Bienvenue dans ma boutique ZYRA ! Découvrez nos collections exclusives.";
  double rating = 4.8;
  int reviewsCount = 124;
  List<String> shippingMethods = ["Standard", "Express"];
  String bankAccountEnding = "4242";

  void updateStoreData({
    String? name,
    String? description,
    List<String>? newShippingMethods,
    String? newBankAccountEnding,
  }) {
    if (name != null) storeName = name;
    if (description != null) storeDescription = description;
    if (newShippingMethods != null) shippingMethods = newShippingMethods;
    if (newBankAccountEnding != null) bankAccountEnding = newBankAccountEnding;
    notifyListeners();
  }

  // --- Seller Settings ---
  bool notificationsNewOrder = true;
  bool vacationMode = false;
  bool autoAcceptOrders = false;

  void updateSettings({
    bool? newNotifications,
    bool? newVacation,
    bool? newAutoAccept,
  }) {
    if (newNotifications != null) notificationsNewOrder = newNotifications;
    if (newVacation != null) vacationMode = newVacation;
    if (newAutoAccept != null) autoAcceptOrders = newAutoAccept;
    notifyListeners();
  }
}
