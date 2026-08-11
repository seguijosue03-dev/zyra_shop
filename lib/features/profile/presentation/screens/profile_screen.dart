import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/core/services/auth_service.dart';
import 'package:zyra_shop/features/auth/presentation/screens/login_screen.dart';
import 'package:zyra_shop/features/checkout/presentation/screens/checkout_address_screen.dart' as zyra_checkout;
import 'package:zyra_shop/features/orders/presentation/screens/orders_list_screen.dart' as zyra_orders;
import 'package:zyra_shop/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:zyra_shop/features/profile/presentation/screens/payment_methods_screen.dart';
import 'package:zyra_shop/features/profile/presentation/screens/settings_screen.dart';
import 'package:zyra_shop/features/seller/presentation/state/mock_seller_state.dart';
import 'package:zyra_shop/features/seller/presentation/screens/onboarding/seller_registration_screen.dart';
import 'package:zyra_shop/features/seller/presentation/screens/onboarding/seller_pending_approval_screen.dart';
import 'package:zyra_shop/features/seller/presentation/screens/onboarding/seller_contract_screen.dart';
import 'package:zyra_shop/features/seller/presentation/screens/dashboard/seller_dashboard_wrapper.dart';

class ProfileScreen extends StatefulWidget {
  final VoidCallback onNavigateHome;
  final VoidCallback onNavigateFavorites;

  const ProfileScreen({
    super.key,
    required this.onNavigateHome,
    required this.onNavigateFavorites,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _profileImageUrl;
  bool _isUploading = false;

  void _simulateAvatarUpload() async {
    setState(() => _isUploading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    setState(() {
      _isUploading = false;
      _profileImageUrl = 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200';
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Photo de profil mise à jour avec succès !'), backgroundColor: Colors.green));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Profil', style: GoogleFonts.inter(fontSize: 16, color: Colors.grey.shade700, fontWeight: FontWeight.w600)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black54, size: 20),
          onPressed: widget.onNavigateHome,
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            // Pink Wave Band Background
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              height: 180,
              child: ClipPath(
                clipper: _ProfileBandClipper(),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.primary, const Color(0xFFE91E63)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
            ),
            
            // Content
            Column(
              children: [
                const SizedBox(height: 10),
                // Avatar
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(55),
                        child: _isUploading
                            ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF4B72)))
                            : _profileImageUrl != null
                                ? Image.network(_profileImageUrl!, fit: BoxFit.cover)
                                : Icon(Icons.person, size: 60, color: Colors.grey.shade300),
                      ),
                    ),
                    GestureDetector(
                      onTap: _simulateAvatarUpload,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4),
                          ],
                        ),
                        child: const Icon(Icons.camera_alt_outlined, size: 18, color: Color(0xFFFF4B72)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 120),
                
                // My Orders Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Mes Commandes', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                        const SizedBox(height: 28),
                        // 3x2 Grid
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildOrderGridItem(Icons.account_balance_wallet, 'Paiement\nen attente', Colors.lightBlue, () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const zyra_orders.OrdersListScreen()));
                            }),
                            _buildOrderGridItem(Icons.local_shipping, 'Livré', Colors.amber.shade600, () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const zyra_orders.OrdersListScreen()));
                            }),
                            _buildOrderGridItem(Icons.shopping_basket, 'En cours', AppColors.primary, () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const zyra_orders.OrdersListScreen()));
                            }),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildOrderGridItem(Icons.inventory, 'Annulé', Colors.green, () {
                              Navigator.push(context, MaterialPageRoute(builder: (_) => const zyra_orders.OrdersListScreen()));
                            }),
                            _buildOrderGridItem(Icons.favorite, 'Favoris', const Color(0xFFFF4B72), () {
                              widget.onNavigateFavorites();
                            }),
                            _buildOrderGridItem(Icons.headset_mic, 'Service\nClient', Colors.deepPurple.shade400, () {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Service Client (Mock)')));
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // List options
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildProfileListTile(Icons.person_outline, 'Modifier le profil', () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const EditProfileScreen()));
                      }),
                      _buildProfileListTile(Icons.location_on_outlined, 'Adresses de livraison', () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const zyra_checkout.CheckoutAddressScreen()),
                        );
                      }),
                      _buildProfileListTile(Icons.payment_outlined, 'Modes de paiement', () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const PaymentMethodsScreen()));
                      }),
                      _buildProfileListTile(Icons.settings_outlined, 'Paramètres', () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
                      }),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Divider(),
                      ),
                      _buildProfileListTile(Icons.storefront_outlined, 'Espace Vendeur', () {
                        final status = MockSellerState().status;
                        if (status == SellerStatus.none) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SellerRegistrationScreen()));
                        } else if (status == SellerStatus.pending) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SellerPendingApprovalScreen()));
                        } else if (status == SellerStatus.contractRequired) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SellerContractScreen()));
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => const SellerDashboardWrapper()));
                        }
                      }, iconColor: const Color(0xFFFF4B72)),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Logout
                GestureDetector(
                  onTap: () async {
                    // TODO: Intégration Backend - Le backend doit s'assurer que la méthode logout() supprime la session.
                    await AuthService().logout();

                    if (!context.mounted) return;
                    Navigator.of(context).pushAndRemoveUntil(
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 600),
                        pageBuilder: (ctx, animation, _) => const LoginScreen(),
                        transitionsBuilder: (ctx, animation, _, child) => FadeTransition(
                          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
                          child: child,
                        ),
                      ),
                      (route) => false,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.logout_rounded, color: Colors.grey, size: 20),
                      const SizedBox(width: 8),
                      Text('Se déconnecter', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderGridItem(IconData icon, String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 26),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileListTile(IconData icon, String title, VoidCallback onTap, {Color? iconColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Row(
          children: [
            Icon(icon, color: iconColor ?? Colors.grey.shade500, size: 24),
            const SizedBox(width: 20),
            Expanded(
              child: Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 14),
          ],
        ),
      ),
    );
  }
}

class _ProfileBandClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, 40);
    path.quadraticBezierTo(size.width * 0.5, 120, size.width, 0);
    path.lineTo(size.width, size.height - 40);
    path.quadraticBezierTo(size.width * 0.5, size.height + 40, 0, size.height - 80);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
