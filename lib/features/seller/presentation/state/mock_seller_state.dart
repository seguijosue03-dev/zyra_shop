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
}
