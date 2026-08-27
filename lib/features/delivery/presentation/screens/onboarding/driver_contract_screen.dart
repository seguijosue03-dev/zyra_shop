import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/features/delivery/presentation/state/mock_delivery_state.dart';
import 'package:zyra_shop/features/delivery/presentation/screens/dashboard/driver_dashboard_wrapper.dart';

class DriverContractScreen extends StatefulWidget {
  const DriverContractScreen({super.key});

  @override
  State<DriverContractScreen> createState() => _DriverContractScreenState();
}

class _DriverContractScreenState extends State<DriverContractScreen> {
  bool _readContract = false;
  bool _acceptConditions = false;

  void _onJeMeLance() {
    MockDeliveryState().acceptContract();
    
    // Show success transition
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🎉', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 24),
              Text('Bienvenue chez ZYRA !', style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              const SizedBox(height: 12),
              Text(
                'Votre compte livreur est maintenant actif.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(fontSize: 15, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.pop(context); // close dialog
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DriverDashboardWrapper()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.1),
        centerTitle: true,
        title: Column(
          children: [
            Text('Contrat de partenariat', style: GoogleFonts.inter(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16)),
            Text('Livreur ZYRA', style: GoogleFonts.inter(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection('1. Conditions générales', "Le présent contrat régit les relations entre ZYRA (\"la Plateforme\") et le livreur indépendant (\"le Partenaire\"). Ce contrat n'établit aucun lien de subordination ni de relation employeur-employé."),
                  _buildSection('2. Responsabilités du livreur', "Le Partenaire s'engage à maintenir son moyen de transport en bon état de fonctionnement, à respecter le code de la route, et à disposer des assurances nécessaires pour son activité."),
                  _buildSection('3. Conditions de livraison', "Le livreur s'engage à récupérer et livrer les colis dans les délais impartis. Les marchandises doivent être transportées dans des conditions garantissant leur intégrité. Toute perte ou dommage causé par le livreur peut entraîner des pénalités."),
                  _buildSection("4. Utilisation de l'application", "Le Partenaire doit utiliser l'application ZYRA de manière loyale. Il est strictement interdit de partager ses identifiants ou de manipuler le système de géolocalisation. Le statut \"En ligne\" implique une disponibilité immédiate pour accepter des courses."),
                  _buildSection('5. Règles de comportement', "Le livreur représente l'image de ZYRA. Une courtoisie exemplaire est exigée envers les clients, les vendeurs et les équipes support. Tout signalement de comportement inapproprié sera examiné."),
                  _buildSection('6. Rémunération', 'La rémunération est calculée selon la grille tarifaire en vigueur, basée sur la distance et les bonus éventuels. Les paiements sont effectués chaque semaine sur le compte ou mobile money du Partenaire.'),
                  _buildSection('7. Conditions de résiliation', 'Chaque partie peut résilier le présent contrat moyennant un préavis de 7 jours. ZYRA se réserve le droit de suspendre immédiatement le compte en cas de fraude avérée ou de violation grave des conditions.'),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 20, offset: const Offset(0, -5))],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildCheckboxRow(
                    value: _readContract,
                    text: "J'ai lu et compris le contrat.",
                    onChanged: (val) => setState(() => _readContract = val ?? false),
                  ),
                  const SizedBox(height: 12),
                  _buildCheckboxRow(
                    value: _acceptConditions,
                    text: "J'accepte les conditions de livraison ZYRA.",
                    onChanged: (val) => setState(() => _acceptConditions = val ?? false),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: (_readContract && _acceptConditions) ? _onJeMeLance : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: Colors.grey.shade300,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text(
                        'JE ME LANCE',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: (_readContract && _acceptConditions) ? Colors.white : Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          Text(content, style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary, height: 1.6)),
        ],
      ),
    );
  }

  Widget _buildCheckboxRow({required bool value, required String text, required ValueChanged<bool?> onChanged}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(
            value: value,
            activeColor: AppColors.primary,
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }
}

