import 'package:zyra_shop/features/products/domain/entities/product.dart';

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
