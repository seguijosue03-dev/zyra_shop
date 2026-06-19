import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/features/home/presentation/widgets/mock_products.dart';

class SellerStoryDetailsScreen extends StatelessWidget {
  final SellerStory story;

  const SellerStoryDetailsScreen({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Text('Détails de la Story', style: GoogleFonts.inter(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Preview
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 120,
                  height: 180,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    image: DecorationImage(image: NetworkImage(story.contentUrl), fit: BoxFit.cover),
                  ),
                  child: const Center(
                    child: Icon(Icons.play_circle_fill_rounded, color: Colors.white70, size: 40),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(story.linkedProduct?.name ?? 'Story sans produit tagué', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 8),
                      Text('Publiée ${_getTimeAgo(story.createdAt)}', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade600)),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          _buildMiniStat(Icons.visibility_outlined, '${story.analytics.views}', 'Vues'),
                          const SizedBox(width: 24),
                          _buildMiniStat(Icons.favorite_border, '${story.analytics.likes}', 'Likes'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          _buildMiniStat(Icons.shopping_cart_outlined, '${story.analytics.cartAdds}', 'Paniers'),
                          const SizedBox(width: 24),
                          _buildMiniStat(Icons.chat_bubble_outline, '${story.analytics.messagesGenerated}', 'Msgs'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Advanced Insights
            Text('Insights Avancés', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black12),
              ),
              child: Column(
                children: [
                  _buildInsightRow('Taux d\'engagement', '${story.analytics.engagementRate.toStringAsFixed(1)}%'),
                  const Divider(height: 32),
                  _buildInsightRow('Taux d\'ajout au panier', '${story.analytics.views > 0 ? ((story.analytics.cartAdds / story.analytics.views) * 100).toStringAsFixed(1) : 0}%'),
                  const Divider(height: 32),
                  _buildInsightRow('Taux de contact vendeur', '${story.analytics.views > 0 ? ((story.analytics.messagesGenerated / story.analytics.views) * 100).toStringAsFixed(1) : 0}%'),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Viewers List
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Spectateurs', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                Text('${story.analytics.viewers.length} récents', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade600)),
              ],
            ),
            const SizedBox(height: 16),
            if (story.analytics.viewers.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Center(
                  child: Text('Aucun spectateur pour le moment', style: GoogleFonts.inter(color: Colors.grey.shade500)),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black12),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: story.analytics.viewers.length,
                  separatorBuilder: (context, index) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final viewer = story.analytics.viewers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(viewer.avatarUrl),
                      ),
                      title: Text(viewer.name, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                      trailing: Text(_getTimeAgo(viewer.viewedAt), style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500)),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.black54),
            const SizedBox(width: 6),
            Text(value, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildInsightRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade700)),
        Text(value, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }

  String _getTimeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) {
      return 'il y a ${diff.inMinutes} min';
    } else if (diff.inHours < 24) {
      return 'il y a ${diff.inHours}h';
    } else {
      return 'il y a ${diff.inDays}j';
    }
  }
}
