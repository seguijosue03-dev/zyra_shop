import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/features/seller/presentation/state/mock_seller_state.dart';

class SellerSettingsScreen extends StatelessWidget {
  const SellerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: MockSellerState(),
      builder: (context, _) {
        final state = MockSellerState();
        
        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Paramètres Boutique',
              style: GoogleFonts.inter(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Text('Préférences Générales', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 16),
              _buildSettingCard(
                children: [
                  _buildToggleRow(
                    icon: Icons.notifications_active_outlined,
                    title: 'Notifications de commandes',
                    subtitle: 'Être alerté à chaque nouvelle commande.',
                    value: state.notificationsNewOrder,
                    onChanged: (val) => state.updateSettings(newNotifications: val),
                  ),
                  const Divider(height: 32),
                  _buildToggleRow(
                    icon: Icons.check_circle_outline,
                    title: 'Accepter auto. les commandes',
                    subtitle: 'Valide automatiquement les commandes entrantes.',
                    value: state.autoAcceptOrders,
                    onChanged: (val) => state.updateSettings(newAutoAccept: val),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              
              Text('Mode Vacances', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 16),
              _buildSettingCard(
                children: [
                  _buildToggleRow(
                    icon: Icons.flight_takeoff_rounded,
                    title: 'Activer le mode vacances',
                    subtitle: 'Met votre boutique en pause, les clients ne pourront plus commander.',
                    value: state.vacationMode,
                    onChanged: (val) {
                      state.updateSettings(newVacation: val);
                      if (val) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Boutique mise en pause (Mode Vacances activé)')),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              Text('Compte', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 16),
              _buildSettingCard(
                children: [
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cette action nécessitera une confirmation par email.')),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.delete_outline, color: Colors.red.shade600, size: 20),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Supprimer ma boutique', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.red.shade600)),
                                const SizedBox(height: 2),
                                Text('Cette action est irréversible.', style: GoogleFonts.inter(fontSize: 13, color: Colors.black54)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildSettingCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildToggleRow({
    required IconData icon, 
    required String title, 
    required String subtitle, 
    required bool value, 
    required ValueChanged<bool> onChanged
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: value ? Colors.black87 : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: value ? Colors.white : Colors.black87, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
              const SizedBox(height: 2),
              Text(subtitle, style: GoogleFonts.inter(fontSize: 13, color: Colors.black54)),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: Colors.black87,
        ),
      ],
    );
  }
}
