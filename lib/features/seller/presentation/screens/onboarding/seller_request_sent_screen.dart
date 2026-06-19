import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/features/home/presentation/home.dart';

class SellerRequestSentScreen extends StatelessWidget {
  const SellerRequestSentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9FAFB),
        elevation: 0,
        automaticallyImplyLeading: false, 
        centerTitle: true,
        title: Image.asset('assets/images/logo.png', height: 28),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check_circle_rounded, color: Colors.green.shade600, size: 32),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Bienvenue sur le parcours vendeur ZYRA',
                      style: GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87, height: 1.2),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Votre demande de devenir vendeur sur ZYRA a été enregistrée avec succès.\n\nNotre équipe va examiner votre dossier et vérifier les informations fournies.\n\nVous recevrez une réponse par email dans un délai maximum de 24 heures.\n\nSi votre demande est approuvée, un contrat vendeur officiel vous sera envoyé.\n\nVous devrez lire et accepter ce contrat avant d\'accéder à votre espace vendeur.\n\nUne fois le contrat accepté, votre compte vendeur sera activé et vous pourrez commencer à vendre sur ZYRA.\n\nSi votre demande est refusée, vous recevrez également une notification par email.',
                      style: GoogleFonts.inter(fontSize: 14, color: Colors.black87, height: 1.6),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Timeline
              Text('Les prochaines étapes', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black12),
                ),
                child: Column(
                  children: [
                    _buildTimelineStep(1, 'Analyse du dossier', isFirst: true),
                    _buildTimelineStep(2, 'Réponse par email'),
                    _buildTimelineStep(3, 'Réception du contrat vendeur'),
                    _buildTimelineStep(4, 'Acceptation du contrat'),
                    _buildTimelineStep(5, 'Activation du compte vendeur'),
                    _buildTimelineStep(6, 'Accès au tableau de bord', isLast: true),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Trust Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
                      child: const Icon(Icons.shield_outlined, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pourquoi cette vérification ?', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 8),
                          Text(
                            'Chez ZYRA, chaque vendeur est vérifié afin de garantir la qualité des produits, protéger les acheteurs et maintenir un environnement de confiance sur la plateforme.',
                            style: GoogleFonts.inter(fontSize: 13, color: Colors.white70, height: 1.5),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Email Notification Card
              Container(
                padding: const EdgeInsets.all(24),
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
                        const Icon(Icons.email_outlined, color: AppColors.primary, size: 24),
                        const SizedBox(width: 12),
                        Text('Notification par email', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text('Toutes les étapes importantes vous seront communiquées par email :', style: GoogleFonts.inter(fontSize: 14, color: Colors.black87)),
                    const SizedBox(height: 12),
                    _buildBullet('Validation de la demande'),
                    _buildBullet('Refus de la demande'),
                    _buildBullet('Envoi du contrat vendeur'),
                    _buildBullet('Activation du compte vendeur'),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Bottom Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const HomeNavigationWrapper()),
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    backgroundColor: Colors.white,
                  ),
                  child: Text(
                    'Retour à l\'accueil',
                    style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineStep(int step, String title, {bool isFirst = false, bool isLast = false}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    step.toString(),
                    style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: Colors.black12,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Text(
                title,
                style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: GoogleFonts.inter(fontSize: 14, color: Colors.black87)),
          ),
        ],
      ),
    );
  }
}
