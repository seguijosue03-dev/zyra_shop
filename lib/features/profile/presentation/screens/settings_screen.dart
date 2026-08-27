import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _promosEnabled = false;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black54, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Paramètres', style: GoogleFonts.inter(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Préférences'),
            _buildSwitchTile('Notifications Push', 'Recevoir des alertes sur les commandes', _notificationsEnabled, (val) => setState(() => _notificationsEnabled = val)),
            _buildSwitchTile('Emails Promotionnels', 'Offres spéciales et nouveautés', _promosEnabled, (val) => setState(() => _promosEnabled = val)),
            _buildSwitchTile('Mode Sombre', 'Activer le thème sombre (Aperçu)', _darkMode, (val) => setState(() => _darkMode = val)),
            
            const SizedBox(height: 24),
            _buildSectionHeader('Général'),
            _buildListTile('Langue', 'Français', Icons.language, () => _showLanguageBottomSheet(context)),
            _buildListTile('Devise', 'FCFA (XOF)', Icons.money, () => _showCurrencyBottomSheet(context)),
            
            const SizedBox(height: 24),
            _buildSectionHeader('À propos'),
            _buildListTile('Conditions d\'utilisation', null, Icons.description_outlined, () => _showLegalBottomSheet(context, 'Conditions d\'utilisation')),
            _buildListTile('Politique de confidentialité', null, Icons.privacy_tip_outlined, () => _showLegalBottomSheet(context, 'Politique de confidentialité')),
            _buildListTile('Version de l\'application', '1.0.0', Icons.info_outline, () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12, top: 8),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade500, letterSpacing: 1),
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      title: Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
      subtitle: Text(subtitle, style: GoogleFonts.inter(fontSize: 13, color: Colors.grey.shade600)),
      activeThumbColor: const Color(0xFFFF4B72),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  Widget _buildListTile(String title, String? trailingText, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey.shade500, size: 22),
      title: Text(title, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailingText != null)
            Text(trailingText, style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500)),
          if (trailingText == null || trailingText != '1.0.0') ...[
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey, size: 14),
          ]
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      onTap: onTap,
    );
  }

  void _showLanguageBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 24),
            Text('Sélectionner la langue', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              title: Text('Français', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.check, color: Color(0xFFFF4B72)),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              title: Text('Anglais', style: GoogleFonts.inter()),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Langue changée en Anglais')));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            ),
            const SizedBox(height: 24),
            Text('Sélectionner la devise', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ListTile(
              title: Text('FCFA (XOF)', style: GoogleFonts.inter(fontWeight: FontWeight.bold)),
              trailing: const Icon(Icons.check, color: Color(0xFFFF4B72)),
              onTap: () => Navigator.pop(ctx),
            ),
            ListTile(
              title: Text('Euro (€)', style: GoogleFonts.inter()),
              onTap: () {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Devise changée en Euro')));
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showLegalBottomSheet(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(width: 40, height: 4, margin: const EdgeInsets.only(bottom: 24), decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              ),
              Text(title, style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: controller,
                  children: [
                    Text(
                      'Bienvenue sur Zyra Shop. En utilisant notre application, vous acceptez les termes décrits ci-dessous.\n\n'
                      '1. Acceptation des conditions\nEn accédant et en utilisant cette application, vous acceptez d\'être lié par ces conditions. Si vous n\'acceptez pas ces conditions, veuillez ne pas utiliser notre service.\n\n'
                      '2. Achats et Paiements\nTous les paiements sont traités de manière sécurisée. Nous ne stockons pas les détails complets de votre carte de crédit sur nos serveurs sans votre consentement explicite.\n\n'
                      '3. Livraisons et Retours\nLes politiques de livraison varient selon les vendeurs. Veuillez consulter la fiche produit pour les délais estimés. Les retours sont acceptés sous 14 jours si le produit est défectueux.\n\n'
                      '4. Propriété intellectuelle\nLe contenu de cette application (textes, images, logos) est la propriété de Zyra Shop et de ses partenaires.\n\n'
                      '5. Protection des données\nVos données personnelles sont traitées conformément à notre politique de confidentialité. Nous ne vendons pas vos données à des tiers.',
                      style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade700, height: 1.6),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF4B72),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text('J\'ai compris', style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
