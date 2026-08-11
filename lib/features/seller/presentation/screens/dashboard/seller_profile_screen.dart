import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/features/seller/presentation/state/mock_seller_state.dart';
import 'package:zyra_shop/features/seller/presentation/state/mock_dashboard_state.dart';
import 'seller_edit_store_screen.dart';
import 'seller_shipping_methods_screen.dart';
import 'seller_bank_info_screen.dart';
import 'seller_help_screen.dart';
import 'seller_terms_screen.dart';
import 'seller_settings_screen.dart';
import 'package:zyra_shop/features/home/presentation/home.dart';

class SellerProfileScreen extends StatelessWidget {
  final VoidCallback? onNavigateProducts;

  const SellerProfileScreen({super.key, this.onNavigateProducts});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([MockSellerState(), MockDashboardState()]),
      builder: (context, _) {
        final sellerState = MockSellerState();
        final dashboardState = MockDashboardState();

        return Scaffold(
          backgroundColor: const Color(0xFFF4F6F8), // Softer background
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: false,
            automaticallyImplyLeading: false,
            title: Text(
              'Boutique', 
              style: GoogleFonts.inter(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold)
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.home_outlined, color: Colors.black87),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeNavigationWrapper()),
                          (route) => false,
                        );
                      },
                    ),
                    Container(width: 1, height: 24, color: Colors.grey.shade300),
                    IconButton(
                      icon: const Icon(Icons.settings_outlined, color: Colors.black87),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerSettingsScreen()));
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Modern Store Profile Card
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF232526), Color(0xFF414345)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                              ],
                            ),
                            child: const Center(child: Icon(Icons.storefront_rounded, size: 40, color: Colors.white)),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                            child: const Icon(Icons.verified_rounded, color: Colors.blueAccent, size: 20),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(sellerState.storeName, style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                      const SizedBox(height: 6),
                      Text(
                        sellerState.storeDescription, 
                        style: GoogleFonts.inter(fontSize: 14, color: Colors.black54),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(sellerState.rating.toString(), style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.amber)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('${sellerState.reviewsCount} avis', style: GoogleFonts.inter(fontSize: 13, color: Colors.black54, fontWeight: FontWeight.w500)),
                        ],
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerEditStoreScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: Text('Gérer ma boutique', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Dashboard Action Tiles
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildModernTile(
                        context: context,
                        icon: Icons.inventory_2_outlined, 
                        title: 'Tous les produits', 
                        value: '${dashboardState.products.length}',
                        onTap: () {
                          if (onNavigateProducts != null) onNavigateProducts!();
                        },
                      ),
                      const Divider(height: 1, indent: 64, endIndent: 24, color: Color(0xFFF0F0F0)),
                      _buildModernTile(
                        context: context,
                        icon: Icons.local_shipping_outlined, 
                        title: 'Modes de livraison', 
                        value: sellerState.shippingMethods.isEmpty ? 'Aucun' : sellerState.shippingMethods.join(', '),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerShippingMethodsScreen()));
                        },
                      ),
                      const Divider(height: 1, indent: 64, endIndent: 24, color: Color(0xFFF0F0F0)),
                      _buildModernTile(
                        context: context,
                        icon: Icons.account_balance_wallet_outlined, 
                        title: 'Informations bancaires', 
                        value: '**** ${sellerState.bankAccountEnding}',
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerBankInfoScreen()));
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Support & Terms
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10)),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildModernTile(
                        context: context,
                        icon: Icons.help_outline_rounded, 
                        title: 'Centre d\'aide Vendeur', 
                        value: null,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerHelpScreen()));
                        },
                      ),
                      const Divider(height: 1, indent: 64, endIndent: 24, color: Color(0xFFF0F0F0)),
                      _buildModernTile(
                        context: context,
                        icon: Icons.description_outlined, 
                        title: 'Conditions Générales', 
                        value: null,
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const SellerTermsScreen()));
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _buildModernTile({
    required BuildContext context,
    required IconData icon, 
    required String title, 
    String? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24), // Match container radius loosely for corners
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.black87, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
            ),
            if (value != null) ...[
              const SizedBox(width: 12),
              Flexible(
                child: Text(
                  value, 
                  style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey.shade500),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            const SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey.shade400, size: 14),
          ],
        ),
      ),
    );
  }
}
