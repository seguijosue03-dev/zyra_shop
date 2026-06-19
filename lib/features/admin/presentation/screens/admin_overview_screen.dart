import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/core/theme/app_shadows.dart';

class AdminOverviewScreen extends StatelessWidget {
  const AdminOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        int columns = 4;
        if (width < 600) {
          columns = 1;
        } else if (width < 900) {
          columns = 2;
        } else if (width < 1200) {
          columns = 3;
        }

        final double padding = width < 600 ? 16 : 32;
        final double spacing = 24;
        final double cardWidth = (width - (spacing * (columns - 1)) - (padding * 2)) / columns;

        return SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Vue d\'ensemble', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 32),
              Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  SizedBox(width: cardWidth, child: _buildMetricCard('Volume d\'affaires (GMV)', '0 FCFA', '0%')),
                  SizedBox(width: cardWidth, child: _buildMetricCard('Revenus Plateforme', '0 FCFA', '0%')),
                  SizedBox(width: cardWidth, child: _buildMetricCard('Vendeurs Actifs', '0', '0')),
                  SizedBox(width: cardWidth, child: _buildMetricCard('Nouveaux Clients', '0', '0%')),
                ],
              ),
              const SizedBox(height: 32),
          Container(
            height: 300,
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.premiumCard,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Évolution des revenus', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                const SizedBox(height: 24),
                Expanded(
                  child: Center(
                    child: Text('Chart Placeholder (Spline Curve)', style: GoogleFonts.inter(color: Colors.grey.shade400)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    },
  );
  }

  Widget _buildMetricCard(String title, String value, String change) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.premiumCard,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.black54)),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(Icons.arrow_upward, size: 12, color: Colors.green.shade700),
                    const SizedBox(width: 4),
                    Text(change, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.green.shade700)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
