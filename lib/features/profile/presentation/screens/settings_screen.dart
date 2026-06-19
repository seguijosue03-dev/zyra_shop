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
            _buildListTile('Langue', 'Français', Icons.language),
            _buildListTile('Devise', 'FCFA (XOF)', Icons.money),
            
            const SizedBox(height: 24),
            _buildSectionHeader('À propos'),
            _buildListTile('Conditions d\'utilisation', null, Icons.description_outlined),
            _buildListTile('Politique de confidentialité', null, Icons.privacy_tip_outlined),
            _buildListTile('Version de l\'application', '1.0.0', Icons.info_outline),
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
      activeColor: const Color(0xFFFF4B72),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  Widget _buildListTile(String title, String? trailingText, IconData icon) {
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
      onTap: () {},
    );
  }
}
