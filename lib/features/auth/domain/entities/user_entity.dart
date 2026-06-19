class UserEntity {
  final String id;
  final String email;
  final String? fullName;
  final String? avatarUrl;
  final String? phone;
  final String role; // 'customer' | 'seller' | 'admin'
  final bool isActive;
  final DateTime createdAt;

  const UserEntity({
    required this.id,
    required this.email,
    this.fullName,
    this.avatarUrl,
    this.phone,
    required this.role,
    required this.isActive,
    required this.createdAt,
  });
}