import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/features/admin/presentation/state/mock_admin_state.dart';
import 'package:zyra_shop/features/admin/presentation/widgets/status_badge.dart';

class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: MockAdminState(),
      builder: (context, _) {
        final products = MockAdminState().products;
        return LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            final tableWidth = constraints.maxWidth < 864 ? 800.0 : constraints.maxWidth - 64.0;
            return SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Modération des Produits', style: GoogleFonts.inter(fontSize: isMobile ? 20 : 24, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 32),
              if (isMobile)
                ...products.map((product) => _buildMobileProductCard(context, product))
              else
                SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: tableWidth,
                  decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black.withOpacity(0.05)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.05))),
                      ),
                      child: Row(
                        children: [
                          Expanded(flex: 3, child: Text('PRODUIT', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54, letterSpacing: 0.5))),
                          Expanded(flex: 2, child: Text('BOUTIQUE', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54, letterSpacing: 0.5))),
                          Expanded(flex: 1, child: Text('SIGNALEMENTS', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54, letterSpacing: 0.5))),
                          Expanded(flex: 1, child: Text('STATUT', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54, letterSpacing: 0.5))),
                          const SizedBox(width: 48),
                        ],
                      ),
                    ),
                    // Rows
                    ...products.map((product) => _buildProductRow(context, product)),
                  ],
                ),
                ),
              ),
            ],
          ),
        );
          },
        );
      },
    );
  }

  Widget _buildProductRow(BuildContext context, Map<String, dynamic> product) {
    return InkWell(
      onTap: () => _showProductDetails(context, product),
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.02))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: const Icon(Icons.inventory_2_outlined, color: Colors.black54, size: 20),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product['name'], style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                    Text(product['price'], style: GoogleFonts.inter(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(product['shopName'], style: GoogleFonts.inter(fontSize: 14, color: Colors.black87)),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                if (product['reports'] > 0) const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 16),
                if (product['reports'] > 0) const SizedBox(width: 4),
                Text(product['reports'].toString(), style: GoogleFonts.inter(fontSize: 14, color: product['reports'] > 0 ? Colors.redAccent : Colors.black87, fontWeight: product['reports'] > 0 ? FontWeight.bold : FontWeight.normal)),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: StatusBadge(status: product['status']),
            ),
          ),
          SizedBox(
            width: 48,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_horiz, color: Colors.black54),
              onSelected: (value) {
                MockAdminState().updateProductStatus(product['id'], value);
              },
              itemBuilder: (context) => [
                if (product['status'] != 'Actif') PopupMenuItem(value: 'Actif', child: Text('Réactiver', style: GoogleFonts.inter())),
                if (product['status'] != 'Bloqué') PopupMenuItem(value: 'Bloqué', child: Text('Bloquer', style: GoogleFonts.inter(color: Colors.red))),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildMobileProductCard(BuildContext context, Map<String, dynamic> product) {
    return InkWell(
      onTap: () => _showProductDetails(context, product),
      borderRadius: BorderRadius.circular(12),
      child: Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: const Icon(Icons.inventory_2_outlined, color: Colors.black54, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product['name'], style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                      Text(product['price'], style: GoogleFonts.inter(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ],
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, color: Colors.black54),
                onSelected: (value) {
                  MockAdminState().updateProductStatus(product['id'], value);
                },
                itemBuilder: (context) => [
                  if (product['status'] != 'Actif') PopupMenuItem(value: 'Actif', child: Text('Réactiver', style: GoogleFonts.inter())),
                  if (product['status'] != 'Bloqué') PopupMenuItem(value: 'Bloqué', child: Text('Bloquer', style: GoogleFonts.inter(color: Colors.red))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Boutique', style: GoogleFonts.inter(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text(product['shopName'], style: GoogleFonts.inter(fontSize: 14, color: Colors.black87)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  StatusBadge(status: product['status']),
                  if (product['reports'] > 0) const SizedBox(height: 8),
                  if (product['reports'] > 0)
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 14),
                        const SizedBox(width: 4),
                        Text('${product['reports']} signalements', style: GoogleFonts.inter(fontSize: 12, color: Colors.redAccent, fontWeight: FontWeight.bold)),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }

  void _showProductDetails(BuildContext context, Map<String, dynamic> product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Détails du produit', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: const Icon(Icons.inventory_2_outlined, color: Colors.black54, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product['name'], style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
                        Text(product['id'], style: GoogleFonts.inter(fontSize: 14, color: Colors.black54)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildDetailRow('Prix', product['price']),
              const SizedBox(height: 16),
              _buildDetailRow('Boutique', product['shopName']),
              const SizedBox(height: 16),
              _buildDetailRow('Signalements', '${product['reports']}'),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Statut actuel', style: GoogleFonts.inter(fontSize: 14, color: Colors.black54)),
                  StatusBadge(status: product['status']),
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: Text('Fermer', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 14, color: Colors.black54)),
        Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.black87)),
      ],
    );
  }
}
