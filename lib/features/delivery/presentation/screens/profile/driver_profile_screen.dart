import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/features/delivery/domain/entities/delivery_order.dart';
import 'package:zyra_shop/features/delivery/presentation/state/mock_delivery_state.dart';
import 'package:zyra_shop/features/home/presentation/screens/home_navigation_wrapper.dart';
import 'package:zyra_shop/features/delivery/presentation/screens/profile/driver_profile_subscreens.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({super.key});

  void _exitDriverMode(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Quitter le mode livreur', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
        content: Text('Voulez-vous retourner à la boutique ? Vous pourrez revenir à tout moment.', style: GoogleFonts.inter()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Annuler', style: GoogleFonts.inter(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const HomeNavigationWrapper()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: Text('Confirmer', style: GoogleFonts.inter(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: MockDeliveryState(),
      builder: (context, _) {
        final state = MockDeliveryState();
        final name = state.registrationData?['firstName'] ?? 'Livreur ZYRA';
        final lastName = state.registrationData?['lastName'] ?? '';
        final vehicle = state.registrationData?['vehicle'] ?? 'Moto';
        
        String vehicleIcon = '🏍️';
        if (vehicle == 'foot') vehicleIcon = '🚶';
        if (vehicle == 'car') vehicleIcon = '🚗';
        if (vehicle == 'bike') vehicleIcon = '🚲';

        return Scaffold(
          backgroundColor: AppColors.surface,
          appBar: AppBar(
            backgroundColor: AppColors.primary,
            elevation: 0,
            automaticallyImplyLeading: false,
            title: Text('Mon Profil', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: Colors.white),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const DriverSettingsScreen()));
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header profile
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(left: 24, right: 24, bottom: 32, top: 16),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(32), bottomRight: Radius.circular(32)),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          image: const DecorationImage(
                            image: NetworkImage('https://i.pravatar.cc/300'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('$name $lastName', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 4),
                      Text('Livreur $vehicleIcon', style: GoogleFonts.inter(fontSize: 14, color: Colors.white.withValues(alpha: 0.8))),
                    ],
                  ),
                ),
                
                // Stats
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          title: 'Note moyenne',
                          value: state.rating.toStringAsFixed(1),
                          icon: Icons.star_rounded,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildStatCard(
                          title: 'Total livraisons',
                          value: state.deliveries.where((d) => d.status == DeliveryStatus.delivered).length.toString(),
                          icon: Icons.check_circle_rounded,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Menu List
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildMenuItem(context, Icons.person_outline, 'Informations personnelles', const DriverPersonalInfoScreen()),
                      const Divider(height: 1, indent: 56),
                      _buildMenuItem(context, Icons.account_balance_wallet_outlined, 'Mes revenus', const DriverRevenueScreen()),
                      const Divider(height: 1, indent: 56),
                      _buildMenuItem(context, Icons.two_wheeler_outlined, 'Mon véhicule', const DriverVehicleScreen()),
                      const Divider(height: 1, indent: 56),
                      _buildMenuItem(context, Icons.help_outline, 'Aide et support', const DriverSupportScreen()),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Logout
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  width: double.infinity,
                  height: 54,
                  child: OutlinedButton.icon(
                    onPressed: () => _exitDriverMode(context),
                    icon: const Icon(Icons.storefront_rounded, color: AppColors.primary),
                    label: Text('Retour à la boutique', style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 4),
          Text(title, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, Widget destination) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(title, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary)),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
      },
    );
  }
}

