import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/features/admin/presentation/state/mock_admin_state.dart';
import 'package:zyra_shop/features/admin/presentation/widgets/status_badge.dart';

class AdminSellersScreen extends StatelessWidget {
  const AdminSellersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: MockAdminState(),
      builder: (context, _) {
        final sellers = MockAdminState().sellers;
        return LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 600;
            final tableWidth = constraints.maxWidth < 864 ? 800.0 : constraints.maxWidth - 64.0;
            return SingleChildScrollView(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Vendeurs', style: GoogleFonts.inter(fontSize: isMobile ? 20 : 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.add, size: 18),
                    label: Text('Inviter un vendeur', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(0, 44), // Crucial to override theme's double.infinity
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              if (isMobile)
                ...sellers.map((seller) => _buildMobileSellerCard(context, seller))
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
                          Expanded(flex: 2, child: Text('BOUTIQUE', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54, letterSpacing: 0.5))),
                          Expanded(flex: 2, child: Text('PROPRIÉTAIRE', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54, letterSpacing: 0.5))),
                          Expanded(flex: 1, child: Text('DATE', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54, letterSpacing: 0.5))),
                          Expanded(flex: 1, child: Text('STATUT', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black54, letterSpacing: 0.5))),
                          const SizedBox(width: 48), // Action space
                        ],
                      ),
                    ),
                    // Rows
                    ...sellers.map((seller) => _buildSellerRow(context, seller)),
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

  Widget _buildSellerRow(BuildContext context, Map<String, dynamic> seller) {
    return InkWell(
      onTap: () => _showSellerDetails(context, seller),
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black.withOpacity(0.02))),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Colors.grey.shade100,
                  child: Text(seller['shopName'][0], style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(seller['shopName'], style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                    Text(seller['id'], style: GoogleFonts.inter(fontSize: 12, color: Colors.black54)),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(seller['owner'], style: GoogleFonts.inter(fontSize: 14, color: Colors.black87)),
                Text(seller['email'], style: GoogleFonts.inter(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(seller['date'], style: GoogleFonts.inter(fontSize: 14, color: Colors.black87)),
          ),
          Expanded(
            flex: 1,
            child: Align(
              alignment: Alignment.centerLeft,
              child: StatusBadge(status: seller['status']),
            ),
          ),
          SizedBox(
            width: 48,
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.more_horiz, color: Colors.black54),
              onSelected: (value) {
                MockAdminState().updateSellerStatus(seller['id'], value);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Statut mis à jour : $value')));
              },
              itemBuilder: (context) => [
                if (seller['status'] != 'Approuvé') PopupMenuItem(value: 'Approuvé', child: Text('Approuver', style: GoogleFonts.inter())),
                if (seller['status'] != 'Refusé') PopupMenuItem(value: 'Refusé', child: Text('Refuser', style: GoogleFonts.inter())),
                if (seller['status'] != 'Suspendu') PopupMenuItem(value: 'Suspendu', child: Text('Suspendre', style: GoogleFonts.inter(color: Colors.red))),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildMobileSellerCard(BuildContext context, Map<String, dynamic> seller) {
    return InkWell(
      onTap: () => _showSellerDetails(context, seller),
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
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: Colors.grey.shade100,
                    child: Text(seller['shopName'][0], style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(seller['shopName'], style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                      Text(seller['id'], style: GoogleFonts.inter(fontSize: 12, color: Colors.black54)),
                    ],
                  ),
                ],
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_horiz, color: Colors.black54),
                onSelected: (value) {
                  MockAdminState().updateSellerStatus(seller['id'], value);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Statut mis à jour : $value')));
                },
                itemBuilder: (context) => [
                  if (seller['status'] != 'Approuvé') PopupMenuItem(value: 'Approuvé', child: Text('Approuver', style: GoogleFonts.inter())),
                  if (seller['status'] != 'Refusé') PopupMenuItem(value: 'Refusé', child: Text('Refuser', style: GoogleFonts.inter())),
                  if (seller['status'] != 'Suspendu') PopupMenuItem(value: 'Suspendu', child: Text('Suspendre', style: GoogleFonts.inter(color: Colors.red))),
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
                  Text('Propriétaire', style: GoogleFonts.inter(fontSize: 12, color: Colors.black54)),
                  const SizedBox(height: 4),
                  Text(seller['owner'], style: GoogleFonts.inter(fontSize: 14, color: Colors.black87)),
                ],
              ),
              StatusBadge(status: seller['status']),
            ],
          ),
        ],
      ),
      ),
    );
  }

  void _showSellerDetails(BuildContext context, Map<String, dynamic> seller) {
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
                  Text('Détails du vendeur', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.grey.shade100,
                    child: Text(seller['shopName'][0], style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(seller['shopName'], style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87)),
                      Text(seller['id'], style: GoogleFonts.inter(fontSize: 14, color: Colors.black54)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),
              _buildDetailRow('Propriétaire', seller['owner']),
              const SizedBox(height: 16),
              _buildDetailRow('Email', seller['email']),
              const SizedBox(height: 16),
              _buildDetailRow('Date d\'inscription', seller['date']),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Statut actuel', style: GoogleFonts.inter(fontSize: 14, color: Colors.black54)),
                  StatusBadge(status: seller['status']),
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
