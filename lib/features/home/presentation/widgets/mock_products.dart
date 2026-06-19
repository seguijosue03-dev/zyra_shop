import 'package:flutter/material.dart';

/// Product Model for social-commerce presentation
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
  
  // Social commerce fields matching reference image
  final String countryCode;      // e.g. "FR", "PR"
  final String? creatorName;     // e.g. "SophieStyle"
  final String? creatorAvatar;   // Profile pic URL
  final String? viewsCount;      // e.g. "8.3k"
  final String? likesCount;      // e.g. "88"
  final String? commentsCount;   // e.g. "20"
  final bool isLikesCTA;         // True -> "J'aime", False -> "Panier+"

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

/// Category Model
class CategoryData {
  final String name;
  final IconData icon;

  const CategoryData({
    required this.name,
    required this.icon,
  });
}

class StoryViewer {
  final String id;
  final String name;
  final String avatarUrl;
  final DateTime viewedAt;

  const StoryViewer({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.viewedAt,
  });
}

class StoryAnalytics {
  final int views;
  final int likes;
  final int cartAdds;
  final int messagesGenerated;
  final List<StoryViewer> viewers;

  const StoryAnalytics({
    this.views = 0,
    this.likes = 0,
    this.cartAdds = 0,
    this.messagesGenerated = 0,
    this.viewers = const [],
  });

  double get engagementRate {
    if (views == 0) return 0.0;
    return ((likes + cartAdds + messagesGenerated) / views) * 100;
  }
}

/// Seller Story Model (Instagram/TrendHub style)
class SellerStory {
  final String id;
  final String sellerId;
  final String sellerName;
  final String sellerAvatarUrl;
  final String contentUrl; // Image or video URL
  final bool isVideo;
  final DateTime createdAt;
  final Product? linkedProduct; // The shoppable tag
  final StoryAnalytics analytics;
  final bool hasUnread;

  const SellerStory({
    required this.id,
    required this.sellerId,
    required this.sellerName,
    required this.sellerAvatarUrl,
    required this.contentUrl,
    this.isVideo = false,
    required this.createdAt,
    this.linkedProduct,
    this.analytics = const StoryAnalytics(),
    this.hasUnread = true,
  });
}

const List<CategoryData> mockCategories = [
  CategoryData(name: 'TOUT', icon: Icons.grid_view_rounded),
  CategoryData(name: 'FEMMES', icon: Icons.woman_2_outlined),
  CategoryData(name: 'HOMMES', icon: Icons.man_2_outlined),
  CategoryData(name: 'ENFANTS', icon: Icons.child_care_outlined),
  CategoryData(name: 'NOUVEAUTÉS', icon: Icons.fiber_new_outlined),
  CategoryData(name: 'TENDANCES', icon: Icons.local_fire_department_outlined),
  CategoryData(name: 'PROMOTIONS', icon: Icons.local_offer_outlined),
];

/// Mock Seller Stories (Instagram style)
final List<SellerStory> mockStories = [
  SellerStory(
    id: 's1',
    sellerId: 'sel1',
    sellerName: 'Zyra Fashion',
    sellerAvatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200',
    contentUrl: 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?q=80&w=600',
    createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    hasUnread: true,
    linkedProduct: const Product(
      id: 'p1',
      name: 'Robe d\'été florale',
      price: 25000,
      oldPrice: 35000,
      rating: 4.8,
      ratingCount: 124,
      imageUrl: 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?q=80&w=200',
      category: 'FEMMES',
    ),
    analytics: StoryAnalytics(
      views: 1245,
      likes: 342,
      cartAdds: 45,
      messagesGenerated: 12,
      viewers: [
        StoryViewer(id: 'v1', name: 'Alice D.', avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=150', viewedAt: DateTime.now().subtract(const Duration(minutes: 5))),
        StoryViewer(id: 'v2', name: 'Marie L.', avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=150', viewedAt: DateTime.now().subtract(const Duration(minutes: 15))),
      ],
    ),
  ),
  SellerStory(
    id: 's2',
    sellerId: 'sel2',
    sellerName: 'Urban Kicks',
    sellerAvatarUrl: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?q=80&w=200',
    contentUrl: 'https://images.unsplash.com/photo-1552346154-21d32810baa3?q=80&w=600',
    createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    hasUnread: true,
    linkedProduct: const Product(
      id: 'p2',
      name: 'Sneakers Urban X',
      price: 45000,
      rating: 4.9,
      ratingCount: 89,
      imageUrl: 'https://images.unsplash.com/photo-1552346154-21d32810baa3?q=80&w=200',
      category: 'HOMMES',
    ),
    analytics: const StoryAnalytics(
      views: 890,
      likes: 120,
      cartAdds: 15,
      messagesGenerated: 3,
    ),
  ),
  SellerStory(
    id: 's3',
    sellerId: 'sel3',
    sellerName: 'Luxury Watches',
    sellerAvatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=200',
    contentUrl: 'https://images.unsplash.com/photo-1524592094714-cb9c5a498363?q=80&w=600',
    createdAt: DateTime.now().subtract(const Duration(hours: 12)),
    hasUnread: false,
    analytics: const StoryAnalytics(
      views: 3200,
      likes: 560,
      cartAdds: 80,
      messagesGenerated: 25,
    ),
  ),
];

const List<Product> mockProducts = [];
