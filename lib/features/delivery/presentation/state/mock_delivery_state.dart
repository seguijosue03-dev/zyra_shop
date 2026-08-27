import 'package:flutter/material.dart';
import 'package:zyra_shop/features/delivery/domain/entities/delivery_order.dart';
import 'package:zyra_shop/features/notifications/presentation/state/mock_notifications_state.dart';
import 'package:zyra_shop/features/notifications/domain/entities/notification_entity.dart';

enum DriverStatus {
  none,
  pending,
  rejected,
  approved,
  contractPending,
  active,
}

class MockDeliveryState extends ChangeNotifier {
  static final MockDeliveryState _instance = MockDeliveryState._internal();
  factory MockDeliveryState() => _instance;

  MockDeliveryState._internal() {
    _initMockDeliveries();
  }

  DriverStatus _status = DriverStatus.none;
  DriverStatus get status => _status;

  bool _isOnline = false;
  bool get isOnline => _isOnline;

  double _rating = 5.0;
  double get rating => _rating;

  Map<String, dynamic>? _registrationData;
  Map<String, dynamic>? get registrationData => _registrationData;

  void updateRegistrationData(Map<String, dynamic> newData) {
    _registrationData = {...(_registrationData ?? {}), ...newData};
    notifyListeners();
  }

  List<DeliveryOrder> _deliveries = [];
  List<DeliveryOrder> get deliveries => _deliveries;

  void _initMockDeliveries() {
    _deliveries = [
      DeliveryOrder(
        id: 'ZY1234',
        customerName: 'Sophie Martin',
        customerPhone: '+225 01 23 45 67 89',
        address: 'Rue des Jardins, Immeuble A, 3e étage',
        zone: 'Cocody',
        itemCount: 3,
        totalAmount: 25000,
        status: DeliveryStatus.prepared,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
      DeliveryOrder(
        id: 'ZY1235',
        customerName: 'Jean Dupont',
        customerPhone: '+225 05 55 55 55 55',
        address: 'Quartier Maroc, Villa 42',
        zone: 'Yopougon',
        itemCount: 1,
        totalAmount: 12000,
        status: DeliveryStatus.prepared,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      DeliveryOrder(
        id: 'ZY1236',
        customerName: 'Marie Claire',
        customerPhone: '+225 07 77 77 77 77',
        address: 'Zone 4, Rue Pierre et Marie Curie',
        zone: 'Marcory',
        itemCount: 5,
        totalAmount: 85000,
        status: DeliveryStatus.pickedUp,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      DeliveryOrder(
        id: 'ZY1237',
        customerName: 'Kouassi Paul',
        customerPhone: '+225 01 11 11 11 11',
        address: 'Avenue Chardy, Plateau',
        zone: 'Plateau',
        itemCount: 2,
        totalAmount: 34000,
        status: DeliveryStatus.outForDelivery,
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      DeliveryOrder(
        id: 'ZY1238',
        customerName: 'Awa Sanogo',
        customerPhone: '+225 07 22 22 22 22',
        address: 'Rond Point, Abobo',
        zone: 'Abobo',
        itemCount: 1,
        totalAmount: 5000,
        status: DeliveryStatus.delivered,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
    ];
  }

  void submitApplication(Map<String, dynamic> data) {
    _registrationData = data;
    _status = DriverStatus.pending;
    notifyListeners();
  }

  void devSetStatus(DriverStatus newStatus) {
    _status = newStatus;
    if (newStatus == DriverStatus.active) {
      _isOnline = true;
    }
    notifyListeners();
  }

  void acceptContract() {
    _status = DriverStatus.active;
    _isOnline = true;
    notifyListeners();
  }

  void toggleOnlineStatus() {
    _isOnline = !_isOnline;
    notifyListeners();
  }

  void updateDeliveryStatus(String id, DeliveryStatus newStatus) {
    final index = _deliveries.indexWhere((d) => d.id == id);
    if (index != -1) {
      _deliveries[index] = _deliveries[index].copyWith(status: newStatus);
      _generateNotificationForStatusUpdate(_deliveries[index]);
      notifyListeners();
    }
  }

  void bulkUpdateDeliveries(List<String> ids, DeliveryStatus newStatus) {
    for (var id in ids) {
      final index = _deliveries.indexWhere((d) => d.id == id);
      if (index != -1) {
        _deliveries[index] = _deliveries[index].copyWith(status: newStatus);
        _generateNotificationForStatusUpdate(_deliveries[index]);
      }
    }
    notifyListeners();
  }

  void addReview(String deliveryId, double rating) {
    // Basic local state logic to average rating
    _rating = (_rating + rating) / 2.0;
    notifyListeners();
  }

  void _generateNotificationForStatusUpdate(DeliveryOrder order) {
    String title = '';
    String body = '';

    switch (order.status) {
      case DeliveryStatus.pickedUp:
        title = 'Colis récupéré';
        body = 'Votre commande #${order.id} a été récupérée par le livreur ZYRA.';
        break;
      case DeliveryStatus.outForDelivery:
        title = 'En cours de livraison';
        body = 'Votre commande #${order.id} est en route ! Suivez le livreur.';
        break;
      case DeliveryStatus.delivered:
        title = 'Commande livrée';
        body = 'Votre commande #${order.id} a été livrée avec succès. Donnez votre avis !';
        break;
      default:
        return; // No notification needed
    }

    MockNotificationsState().addNotification(
      NotificationEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: title,
        description: body,
        fullDescription: body,
        date: DateTime.now(),
        category: NotificationCategory.orders,
        actionLabel: 'Voir',
        isRead: false,
      ),
    );
  }

  // KPIs
  List<DeliveryOrder> get deliveriesToday => _deliveries;
  
  int get pendingCount => _deliveries.where((d) => d.status == DeliveryStatus.prepared).length;
  int get inProgressCount => _deliveries.where((d) => d.status == DeliveryStatus.outForDelivery || d.status == DeliveryStatus.pickedUp).length;
  int get deliveredCount => _deliveries.where((d) => d.status == DeliveryStatus.delivered).length;
}
