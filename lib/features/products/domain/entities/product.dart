class Product {
  final String id;
  final String name;
  final double price;
  final double? oldPrice;
  final double rating;
  final int ratingCount;
  final String imageUrl;
  final String category;
  final bool isFeatured;
  final bool isTrending;
  final bool isNewArrival;
  
  // Social commerce fields
  final String countryCode;
  final String? creatorName;
  final String? creatorAvatar;
  final String? viewsCount;
  final String? likesCount;
  final String? commentsCount;
  final bool isLikesCTA;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.ratingCount,
    required this.imageUrl,
    required this.category,
    this.isFeatured = false,
    this.isTrending = false,
    this.isNewArrival = false,
    this.countryCode = 'FR',
    this.creatorName,
    this.creatorAvatar,
    this.viewsCount,
    this.likesCount,
    this.commentsCount,
    this.isLikesCTA = false,
  });

  bool get hasDiscount => oldPrice != null && oldPrice! > price;

  int get discountPercentage {
    if (!hasDiscount) return 0;
    final diff = oldPrice! - price;
    return ((diff / oldPrice!) * 100).round();
  }
}
