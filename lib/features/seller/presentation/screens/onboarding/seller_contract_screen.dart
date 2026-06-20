import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/features/seller/presentation/state/mock_seller_state.dart';
import 'seller_welcome_screen.dart';

class SellerContractScreen extends StatefulWidget {
  const SellerContractScreen({super.key});

  @override
  State<SellerContractScreen> createState() => _SellerContractScreenState();
}

class _SellerContractScreenState extends State<SellerContractScreen> {
  bool _accepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB), // Very light gray background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, // Force them to read/accept or close app
        title: Text('Contrat vendeur ZYRA', style: GoogleFonts.inter(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Conditions Générales de Vente (CGV)', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 16),
                      _buildSection('1. Engagement qualité', 'En tant que vendeur sur ZYRA, vous vous engagez à fournir des produits d\'une qualité irréprochable, correspondant exactement aux descriptions fournies.'),
                      _buildSection('2. Livraison', 'Les commandes doivent être expédiées dans un délai maximum de 48 heures ouvrées après validation de la commande.'),
                      _buildSection('3. Retours', 'Vous acceptez notre politique de retour gratuit sous 14 jours pour tous les clients, à l\'exception des produits personnalisés.'),
                      _buildSection('4. Respect des clients', 'La communication avec les acheteurs doit toujours être respectueuse, professionnelle et orientée vers la résolution des problèmes.'),
                      _buildSection('5. Frais de plateforme', 'ZYRA prélève une commission fixe de 8% sur chaque vente réalisée via la plateforme, incluant les frais de traitement de paiement.'),
                      _buildSection('6. Politique vendeur', 'En cas de non-respect de ces règles, ZYRA se réserve le droit de suspendre ou supprimer votre compte vendeur sans préavis.'),
                    ],
                  ),
                ),
              ),
            ),
            
            // Footer fixed at bottom
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -4)),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Checkbox(
                        value: _accepted,
                        onChanged: (val) => setState(() => _accepted = val ?? false),
                        activeColor: const Color(0xFFFF4B72),
                      ),
                      Expanded(
                        child: Text(
                          'J\'ai lu et j\'accepte le contrat vendeur ZYRA',
                          style: GoogleFonts.inter(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _accepted
                          ? () {
                              MockSellerState().acceptContract();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SellerWelcomeScreen()));
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF4B72),
                        disabledBackgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Text(
                        'Commencer maintenant',
                        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: _accepted ? Colors.white : Colors.grey.shade500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          Text(content, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade600, height: 1.5)),
        ],
      ),
    );
  }
}
