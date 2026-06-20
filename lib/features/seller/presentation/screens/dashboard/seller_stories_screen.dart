import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/features/seller/domain/entities/seller_story.dart';
import 'package:zyra_shop/features/seller/presentation/state/mock_dashboard_state.dart';
import 'package:zyra_shop/features/seller/presentation/screens/dashboard/seller_story_details_screen.dart';

class SellerStoriesScreen extends StatelessWidget {
  const SellerStoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: Text('Stories', style: GoogleFonts.inter(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Publier', style: GoogleFonts.inter(color: const Color(0xFFFF4B72), fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: ListenableBuilder(
        listenable: MockDashboardState(),
        builder: (context, _) {
          final stories = MockDashboardState().stories;
          
          if (stories.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  Icon(Icons.play_circle_outline, size: 80, color: Colors.grey.shade300),
                  const SizedBox(height: 24),
                  Text('Engagez votre audience', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 8),
                  Text('Publiez votre première story pour mettre en avant vos produits.', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500), textAlign: TextAlign.center),
                ],
              ),
            );
          }

          int totalViews = stories.fold(0, (sum, s) => sum + s.analytics.views);
          int totalLikes = stories.fold(0, (sum, s) => sum + s.analytics.likes);
          int totalCart = stories.fold(0, (sum, s) => sum + s.analytics.cartAdds);
          int totalMsgs = stories.fold(0, (sum, s) => sum + s.analytics.messagesGenerated);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Performance des stories', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildMetricCard('Vues', totalViews.toString(), Icons.visibility_outlined, Colors.blue)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildMetricCard('Likes', totalLikes.toString(), Icons.favorite_border, Colors.red)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildMetricCard('Ajouts Panier', totalCart.toString(), Icons.shopping_cart_outlined, Colors.green)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildMetricCard('Messages', totalMsgs.toString(), Icons.chat_bubble_outline, Colors.orange)),
                  ],
                ),
                const SizedBox(height: 32),
                Text('Stories publiées', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 16),
                ...stories.map((story) => _buildStoryCard(context, story)),
                const SizedBox(height: 80),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          MockDashboardState().addStory(
            SellerStory(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              sellerId: 'me',
              sellerName: 'Mon Boutique',
              sellerAvatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200',
              contentUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=600',
              createdAt: DateTime.now(),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Story publiée (Mock)')));
        },
        backgroundColor: Colors.black87,
        elevation: 4,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('Nouvelle Story', style: GoogleFonts.inter(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(title, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildStoryCard(BuildContext context, SellerStory story) {
    final isActive = DateTime.now().difference(story.createdAt).inHours < 24;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => SellerStoryDetailsScreen(story: story)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                image: DecorationImage(image: NetworkImage(story.contentUrl), fit: BoxFit.cover),
              ),
              child: const Center(
                child: Icon(Icons.play_circle_fill_rounded, color: Colors.white70, size: 32),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(child: Text(story.linkedProduct?.name ?? 'Story', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: isActive ? Colors.green.shade50 : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(isActive ? 'Actif' : 'Expiré', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.bold, color: isActive ? Colors.green : Colors.grey.shade600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.visibility_outlined, size: 16, color: Colors.black54),
                        const SizedBox(width: 4),
                        Text('${story.analytics.views}', style: GoogleFonts.inter(fontSize: 13, color: Colors.black54)),
                        const SizedBox(width: 16),
                        const Icon(Icons.favorite_border, size: 16, color: Colors.black54),
                        const SizedBox(width: 4),
                        Text('${story.analytics.likes}', style: GoogleFonts.inter(fontSize: 13, color: Colors.black54)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
