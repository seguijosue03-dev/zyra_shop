import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SellerTermsScreen extends StatelessWidget {
  const SellerTermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Conditions Générales',
          style: GoogleFonts.inter(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Conditions Générales de Vente et d\'Utilisation - Vendeurs', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 8),
            Text('Dernière mise à jour : Octobre 2023', style: GoogleFonts.inter(fontSize: 13, color: Colors.black54)),
            const SizedBox(height: 24),
            
            _buildSection(
              title: '1. Acceptation des conditions',
              content: 'En créant une boutique sur la plateforme ZYRA, le vendeur accepte sans réserve les présentes conditions générales. Celles-ci régissent les relations entre ZYRA, le Vendeur et les Clients finaux.',
            ),
            _buildSection(
              title: '2. Obligations du vendeur',
              content: 'Le Vendeur s\'engage à proposer des produits conformes aux lois en vigueur, à décrire ses articles avec exactitude, et à honorer les commandes dans les délais annoncés. Tout manquement répété pourra entraîner la suspension de la boutique.',
            ),
            _buildSection(
              title: '3. Frais et Commissions',
              content: 'ZYRA prélève une commission de 12% sur chaque transaction réalisée via la plateforme, à laquelle s\'ajoutent des frais de traitement fixes. Le Vendeur accepte ce barème de facturation lors de la création de son compte.',
            ),
            _buildSection(
              title: '4. Paiements',
              content: 'Les sommes dues au Vendeur sont conservées sur un compte séquestre jusqu\'à la validation de la livraison par le client. Les virements vers le compte bancaire du Vendeur sont effectués de manière hebdomadaire.',
            ),
            _buildSection(
              title: '5. Litiges et Retours',
              content: 'En cas de litige avec un client, le Vendeur s\'engage à privilégier une résolution amiable. ZYRA se réserve le droit de rembourser le client et de débiter le Vendeur si le produit s\'avère non conforme ou non livré.',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 8),
          Text(content, style: GoogleFonts.inter(fontSize: 14, color: Colors.black87, height: 1.6)),
        ],
      ),
    );
  }
}
