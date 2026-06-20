import 'package:flutter/material.dart';

import 'package:zyra_shop/features/products/domain/entities/product.dart';
import 'package:zyra_shop/features/products/domain/entities/category.dart';
import 'package:zyra_shop/features/seller/domain/entities/seller_story.dart';

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
