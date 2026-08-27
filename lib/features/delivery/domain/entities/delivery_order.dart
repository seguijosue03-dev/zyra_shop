enum DeliveryStatus {
  prepared,
  pickedUp,
  outForDelivery,
  delivered,
}

class DeliveryOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final String address;
  final String zone;
  final int itemCount;
  final double totalAmount;
  final DeliveryStatus status;
  final DateTime createdAt;

  const DeliveryOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.address,
    required this.zone,
    required this.itemCount,
    required this.totalAmount,
    required this.status,
    required this.createdAt,
  });

  DeliveryOrder copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    String? address,
    String? zone,
    int? itemCount,
    double? totalAmount,
    DeliveryStatus? status,
    DateTime? createdAt,
  }) {
    return DeliveryOrder(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      address: address ?? this.address,
      zone: zone ?? this.zone,
      itemCount: itemCount ?? this.itemCount,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
