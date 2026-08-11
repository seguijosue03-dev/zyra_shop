import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/features/seller/domain/entities/seller_story.dart';
import 'package:zyra_shop/features/seller/presentation/state/mock_dashboard_state.dart';

class SellerCreateStoryScreen extends StatefulWidget {
  const SellerCreateStoryScreen({super.key});

  @override
  State<SellerCreateStoryScreen> createState() => _SellerCreateStoryScreenState();
}

class _SellerCreateStoryScreenState extends State<SellerCreateStoryScreen> {
  bool _isUploading = false;
  bool _mediaSelected = false;

  void _simulateUpload() async {
    setState(() => _isUploading = true);
    
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Create a new empty story
    final newStory = SellerStory(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sellerId: 'me',
      sellerName: 'Ma Boutique',
      sellerAvatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200',
      contentUrl: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=600',
      createdAt: DateTime.now(),
      // Analytics will naturally default to 0 views, 0 likes etc.
    );

    MockDashboardState().addStory(newStory);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Votre story a été publiée avec succès !'),
        backgroundColor: Colors.green,
      )
    );
    
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Nouvelle Story', style: GoogleFonts.inter(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Contenu visuel', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8),
            Text('Format vertical (9:16) recommandé. 15s max pour les vidéos.', style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600)),
            const SizedBox(height: 16),
            
            // Mock Upload Area
            GestureDetector(
              onTap: () {
                setState(() => _mediaSelected = true);
              },
              child: Container(
                width: double.infinity,
                height: 350,
                decoration: BoxDecoration(
                  color: _mediaSelected ? Colors.black.withOpacity(0.05) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _mediaSelected ? Colors.green.withOpacity(0.5) : Colors.grey.shade300, 
                    width: 2, 
                    style: BorderStyle.solid
                  ),
                ),
                child: _mediaSelected 
                  ? Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.network(
                            'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=600',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check_rounded, color: Colors.white, size: 32),
                        ),
                        Positioned(
                          top: 12,
                          right: 12,
                          child: GestureDetector(
                            onTap: () => setState(() => _mediaSelected = false),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                              child: const Icon(Icons.close_rounded, color: Colors.white, size: 16),
                            ),
                          ),
                        )
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.cloud_upload_outlined, size: 40, color: Colors.black54),
                        ),
                        const SizedBox(height: 16),
                        Text('Appuyez pour uploader', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(height: 4),
                        Text('Photos ou Vidéos (MP4, JPG)', style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade500)),
                      ],
                    ),
              ),
            ),
            
            const SizedBox(height: 32),
            Text('Lier un produit (Optionnel)', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.inventory_2_outlined, color: Colors.black54),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sélectionner un produit', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                        Text('Permet l\'ajout direct au panier', style: GoogleFonts.inter(fontSize: 12, color: Colors.grey.shade500)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: Colors.black54),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: ElevatedButton(
          onPressed: (_mediaSelected && !_isUploading) ? _simulateUpload : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF4B72),
            disabledBackgroundColor: Colors.grey.shade300,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: _isUploading
            ? const SizedBox(
                width: 24, 
                height: 24, 
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
              )
            : Text(
                'Publier la story',
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
              ),
        ),
      ),
    );
  }
}
