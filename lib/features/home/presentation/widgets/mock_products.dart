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

/// Seller Story Model (Instagram/TrendHub style)
class SellerStory {
  final String id;
  final String name;
  final String avatarUrl;
  final bool isLive;
  final bool hasUnread;

  const SellerStory({
    required this.id,
    required this.name,
    required this.avatarUrl,
    this.isLive = false,
    this.hasUnread = true,
  });
}

/// Mock categories for ZYRA Shop
const List<CategoryData> mockCategories = [
  CategoryData(name: 'TOUT', icon: Icons.grid_view_rounded),
  CategoryData(name: 'FEMMES', icon: Icons.woman_2_outlined),
  CategoryData(name: 'HOMMES', icon: Icons.man_2_outlined),
  CategoryData(name: 'NOUVEAUTÉS', icon: Icons.fiber_new_outlined),
  CategoryData(name: 'TENDANCES', icon: Icons.local_fire_department_outlined),
  CategoryData(name: 'PROMOTIONS', icon: Icons.local_offer_outlined),
];

/// Mock Seller Stories (Instagram style)
const List<SellerStory> mockStories = [
  SellerStory(
    id: 's1',
    name: 'Name',
    avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=150',
    isLive: true,
  ),
  SellerStory(
    id: 's2',
    name: 'Naria',
    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=150',
  ),
  SellerStory(
    id: 's3',
    name: 'Rolia',
    avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=150',
  ),
  SellerStory(
    id: 's4',
    name: 'Maria',
    avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=150',
  ),
  SellerStory(
    id: 's5',
    name: 'Dahu',
    avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=150',
  ),
  SellerStory(
    id: 's6',
    name: 'Chloe',
    avatarUrl: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=150',
  ),
];

/// Mock products for ZYRA Shop
const List<Product> mockProducts = [
  Product(
    id: 'e1',
    name: 'Robe Étoilée - Collection Été',
    price: 39.99,
    oldPrice: 52.99,
    rating: 4.8,
    ratingCount: 1200,
    imageUrl: 'https://images.unsplash.com/photo-1595777457583-95e059d581b8?q=80&w=400',
    category: 'FEMMES',
    isFeatured: true,
    isTrending: true,
    countryCode: 'FR',
    creatorName: 'SophieStyle',
    creatorAvatar: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=150',
    viewsCount: '8.3k',
    likesCount: '88',
    commentsCount: '7',
    isLikesCTA: false, // Panier+ style
  ),
  Product(
    id: 'e2',
    name: 'Top Lin Noir - Stylé!',
    price: 24.00,
    rating: 4.6,
    ratingCount: 452,
    imageUrl: 'https://images.unsplash.com/photo-1503342217505-b0a15ec3261c?q=80&w=400',
    category: 'FEMMES',
    isFeatured: true,
    isNewArrival: true,
    countryCode: 'PR',
    creatorName: 'Chloe',
    creatorAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=150',
    viewsCount: '1.2k',
    likesCount: '452',
    commentsCount: '88',
    isLikesCTA: true, // J'aime style
  ),
  Product(
    id: 'e3',
    name: 'Robe Ciel Imprimée',
    price: 42.99,
    rating: 4.9,
    ratingCount: 89,
    imageUrl: 'https://images.unsplash.com/photo-1572804013309-59a88b7e92f1?q=80&w=400',
    category: 'FEMMES',
    isNewArrival: true,
    countryCode: 'IT',
    creatorName: '@StylebyMe',
    creatorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=150',
    viewsCount: '4.5k',
    likesCount: '310',
    commentsCount: '14',
    isLikesCTA: false, // Panier+ style
  ),
  Product(
    id: 'e4',
    name: 'Veste Denim Premium Street',
    price: 59.99,
    oldPrice: 89.99,
    rating: 4.7,
    ratingCount: 210,
    imageUrl: 'https://images.unsplash.com/photo-1544441893-675973e31985?q=80&w=400',
    category: 'FEMMES',
    isFeatured: true,
    isTrending: true,
    countryCode: 'FR',
    creatorName: '@SophieStyle',
    creatorAvatar: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=150',
    viewsCount: '12.4k',
    likesCount: '1.2k',
    commentsCount: '104',
    isLikesCTA: false, // Panier+ style
  ),
  Product(
    id: 'e5',
    name: 'Casque Audio ANC Crystal',
    price: 199.99,
    rating: 4.8,
    ratingCount: 340,
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=400',
    category: 'Maison',
    isTrending: true,
    countryCode: 'FR',
    viewsCount: '3.1k',
    likesCount: '115',
    commentsCount: '12',
  ),
  Product(
    id: 'e6',
    name: 'Robe Floral Spring',
    price: 22.99,
    rating: 4.5,
    ratingCount: 94,
    imageUrl: 'https://images.unsplash.com/photo-1612336307429-8a898d10e223?q=80&w=400',
    category: 'FEMMES',
    isNewArrival: true,
    countryCode: 'FO',
    creatorName: 'Chloe',
    creatorAvatar: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=150',
    viewsCount: '2.3k',
    likesCount: '44',
    commentsCount: '3',
  ),
  Product(
    id: 'e7',
    name: 'Blouse Satinée Lin',
    price: 29.99,
    rating: 4.7,
    ratingCount: 156,
    imageUrl: 'https://images.unsplash.com/photo-1607345366928-199ea26cfe3e?q=80&w=400',
    category: 'FEMMES',
    isTrending: true,
    countryCode: 'FR',
    creatorName: '@StylebyMe',
    creatorAvatar: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=150',
    viewsCount: '5.2k',
    likesCount: '228',
    commentsCount: '34',
    isLikesCTA: true,
  ),
];
