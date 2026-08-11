import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SellerHelpScreen extends StatelessWidget {
  const SellerHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
          'Centre d\'aide Vendeur',
          style: GoogleFonts.inter(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.support_agent_rounded, color: Colors.white, size: 32),
                const SizedBox(height: 16),
                Text(
                  'Besoin d\'assistance ?',
                  style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  'Notre équipe de support vendeur est disponible 7j/7 pour vous accompagner dans le développement de votre boutique.',
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Ouverture du chat live...')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Contacter le support'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          Text('Foire aux questions', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 16),
          _buildFaqItem('Comment ajouter un nouveau produit ?', 'Allez dans l\'onglet Produits, cliquez sur l\'icône "+" et remplissez le formulaire détaillé. Votre produit sera visible une fois validé.'),
          _buildFaqItem('Quand vais-je recevoir mes paiements ?', 'Les paiements sont effectués automatiquement tous les lundis pour les commandes livrées la semaine précédente.'),
          _buildFaqItem('Quels sont les frais de commission ?', 'La plateforme ZYRA prélève une commission de 12% sur chaque transaction, plus 0.5 FCFA de frais fixes pour le traitement bancaire.'),
          _buildFaqItem('Comment modifier mes modes de livraison ?', 'Dans votre espace Boutique, rendez-vous dans "Modes de livraison" pour activer ou désactiver les options souhaitées.'),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: ExpansionTile(
        title: Text(question, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
        childrenPadding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
        iconColor: Colors.black87,
        collapsedIconColor: Colors.black54,
        children: [
          Text(answer, style: GoogleFonts.inter(fontSize: 14, color: Colors.black54, height: 1.5)),
        ],
      ),
    );
  }
}
