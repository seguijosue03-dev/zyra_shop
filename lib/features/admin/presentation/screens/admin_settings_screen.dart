import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/features/admin/presentation/state/mock_settings_state.dart';

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  int _selectedTab = 0;

  final List<String> _tabs = [
    'Général & Plateforme',
    'Vendeurs & Commissions',
    'Catalogue & Produits',
    'Paiements & Expéditions',
    'Sécurité & Profil',
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return ListenableBuilder(
      listenable: MockSettingsState(),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFFAFAFA),
          body: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
        );
      },
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar for settings
        Container(
          width: 260,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(right: BorderSide(color: Colors.black.withOpacity(0.05))),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Centre de Contrôle', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
              ),
              ...List.generate(_tabs.length, (index) => _buildTabItem(index)),
            ],
          ),
        ),
        // Content Area
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_tabs[_selectedTab], style: GoogleFonts.inter(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const SizedBox(height: 32),
                    _buildCurrentTabContent(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Centre de Contrôle', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: List.generate(_tabs.length, (index) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(_tabs[index], style: GoogleFonts.inter()),
                  selected: _selectedTab == index,
                  onSelected: (val) {
                    if (val) setState(() => _selectedTab = index);
                  },
                  selectedColor: Colors.black87,
                  labelStyle: TextStyle(color: _selectedTab == index ? Colors.white : Colors.black87),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.black.withOpacity(0.1)),
                ),
              )),
            ),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.all(24),
            child: _buildCurrentTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index) {
    final isSelected = _selectedTab == index;
    return InkWell(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black.withOpacity(0.04) : Colors.transparent,
          border: Border(
            left: BorderSide(color: isSelected ? Colors.black87 : Colors.transparent, width: 3),
          ),
        ),
        child: Row(
          children: [
            Text(
              _tabs[index],
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.black87 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentTabContent() {
    switch (_selectedTab) {
      case 0: return _buildGeneralTab();
      case 1: return _buildSellersTab();
      case 2: return _buildCatalogTab();
      case 3: return _buildPaymentsTab();
      case 4: return _buildSecurityTab();
      default: return const SizedBox.shrink();
    }
  }

  // --- TAB 0: Général ---
  Widget _buildGeneralTab() {
    final state = MockSettingsState();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSettingsCard(
          child: Column(
            children: [
              _buildToggleRow(
                icon: Icons.construction,
                title: 'Mode Maintenance Global',
                subtitle: 'Bloque l\'accès aux clients. Seuls les admins peuvent se connecter.',
                value: state.maintenanceMode,
                onChanged: (val) => state.updateSetting(() => state.maintenanceMode = val),
              ),
              const Divider(height: 32),
              _buildToggleRow(
                icon: Icons.campaign_outlined,
                title: 'Bannière d\'annonce',
                subtitle: 'Afficher un message promotionnel en haut de l\'application.',
                value: state.showGlobalBanner,
                onChanged: (val) => state.updateSetting(() => state.showGlobalBanner = val),
              ),
              if (state.showGlobalBanner) ...[
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: state.globalBannerText,
                  onChanged: (val) => state.globalBannerText = val,
                  decoration: const InputDecoration(labelText: 'Texte de la bannière'),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 32),
        _buildSettingsCard(
          child: Column(
            children: [
              _buildActionRow(icon: Icons.language, title: 'Langue par défaut', subtitle: state.defaultLanguage),
              const Divider(height: 32),
              _buildActionRow(icon: Icons.payments_outlined, title: 'Devise principale', subtitle: state.defaultCurrency),
              const Divider(height: 32),
              _buildActionRow(icon: Icons.percent, title: 'Taxe globale (TVA)', subtitle: '${state.defaultTaxRate}%'),
            ],
          ),
        ),
      ],
    );
  }

  // --- TAB 1: Vendeurs ---
  Widget _buildSellersTab() {
    final state = MockSettingsState();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSettingsCard(
          child: Column(
            children: [
              _buildToggleRow(
                icon: Icons.person_add_alt_1_outlined,
                title: 'Autoriser les nouvelles inscriptions',
                subtitle: 'Permet à de nouveaux vendeurs de créer une boutique sur ZYRA.',
                value: state.allowNewRegistrations,
                onChanged: (val) => state.updateSetting(() => state.allowNewRegistrations = val),
              ),
              const Divider(height: 32),
              _buildToggleRow(
                icon: Icons.fact_check_outlined,
                title: 'Approbation automatique des vendeurs',
                subtitle: 'Si désactivé, l\'admin doit valider manuellement chaque nouveau vendeur.',
                value: state.autoApproveSellers,
                onChanged: (val) => state.updateSetting(() => state.autoApproveSellers = val),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _buildSettingsCard(
          child: Column(
            children: [
              _buildActionRow(icon: Icons.account_balance_wallet_outlined, title: 'Commission ZYRA globale', subtitle: '${state.globalCommission}% par transaction'),
              const Divider(height: 32),
              _buildActionRow(icon: Icons.money, title: 'Frais fixes par transaction', subtitle: '${state.fixedFeePerTransaction} FCFA'),
            ],
          ),
        ),
      ],
    );
  }

  // --- TAB 2: Catalogue ---
  Widget _buildCatalogTab() {
    final state = MockSettingsState();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSettingsCard(
          child: Column(
            children: [
              _buildToggleRow(
                icon: Icons.inventory_2_outlined,
                title: 'Approbation automatique des produits',
                subtitle: 'Les produits publiés par les vendeurs sont visibles immédiatement.',
                value: state.autoApproveProducts,
                onChanged: (val) => state.updateSetting(() => state.autoApproveProducts = val),
              ),
              const Divider(height: 32),
              _buildActionRow(icon: Icons.image_outlined, title: 'Limite d\'images par produit', subtitle: '${state.maxImagesPerProduct} images max'),
              const Divider(height: 32),
              _buildActionRow(icon: Icons.warning_amber_rounded, title: 'Masquage automatique', subtitle: 'Après ${state.reportsBeforeAutoHide} signalements'),
            ],
          ),
        ),
      ],
    );
  }

  // --- TAB 3: Paiements ---
  Widget _buildPaymentsTab() {
    final state = MockSettingsState();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSettingsCard(
          child: Column(
            children: [
              _buildToggleRow(
                icon: Icons.credit_card,
                title: 'Paiements via Stripe (CB)',
                subtitle: 'Activer les paiements par carte bancaire.',
                value: state.stripeEnabled,
                onChanged: (val) => state.updateSetting(() => state.stripeEnabled = val),
              ),
              const Divider(height: 32),
              _buildToggleRow(
                icon: Icons.paypal,
                title: 'Paiements via PayPal',
                subtitle: 'Permettre aux clients de payer avec leur compte PayPal.',
                value: state.paypalEnabled,
                onChanged: (val) => state.updateSetting(() => state.paypalEnabled = val),
              ),
              const Divider(height: 32),
              _buildToggleRow(
                icon: Icons.apple,
                title: 'Apple Pay / Google Pay',
                subtitle: 'Activer le paiement en un clic sur mobile.',
                value: state.applePayEnabled,
                onChanged: (val) => state.updateSetting(() => state.applePayEnabled = val),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- TAB 4: Sécurité ---
  Widget _buildSecurityTab() {
    final state = MockSettingsState();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSettingsCard(
          child: Row(
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.grey.shade200,
                child: Text('A', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Admin ZYRA', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
                    Text('superadmin@zyra.com', style: GoogleFonts.inter(fontSize: 14, color: Colors.black54)),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  minimumSize: const Size(0, 44),
                  side: BorderSide(color: Colors.black.withOpacity(0.1)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Modifier', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        _buildSettingsCard(
          child: Column(
            children: [
              _buildToggleRow(
                icon: Icons.security,
                title: 'Authentification à deux facteurs (2FA)',
                subtitle: 'Exiger un code SMS lors de la connexion au panel admin.',
                value: state.twoFactorAuth,
                onChanged: (val) => state.updateSetting(() => state.twoFactorAuth = val),
              ),
              const Divider(height: 32),
              _buildActionRow(icon: Icons.lock_outline, title: 'Changer le mot de passe', subtitle: 'Dernière modification il y a 3 mois', trailingButton: true),
            ],
          ),
        ),
        const SizedBox(height: 48),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            label: Text('Se déconnecter', style: GoogleFonts.inter(color: Colors.redAccent, fontWeight: FontWeight.w600)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.redAccent),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  // --- Helper Widgets ---

  Widget _buildSettingsCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildToggleRow({required IconData icon, required String title, required String subtitle, required bool value, required ValueChanged<bool> onChanged}) {
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
          activeColor: Colors.black87,
        ),
      ],
    );
  }

  Widget _buildActionRow({required IconData icon, required String title, required String subtitle, bool trailingButton = false}) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.black87, size: 20),
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
        if (trailingButton)
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 0,
              minimumSize: const Size(0, 36),
              side: BorderSide(color: Colors.black.withOpacity(0.1)),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: Text('Modifier', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600)),
          )
        else
          const Icon(Icons.chevron_right, color: Colors.black54),
      ],
    );
  }
}
