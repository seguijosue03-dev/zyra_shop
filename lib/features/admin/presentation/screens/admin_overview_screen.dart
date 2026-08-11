import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/core/theme/app_shadows.dart';

class AdminOverviewScreen extends StatefulWidget {
  const AdminOverviewScreen({super.key});

  @override
  State<AdminOverviewScreen> createState() => _AdminOverviewScreenState();
}

class _AdminOverviewScreenState extends State<AdminOverviewScreen> {
  int _selectedChartTab = 0;

  Widget _buildChartTab(String title, int index) {
    final isActive = _selectedChartTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedChartTab = index),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontSize: 16,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          color: isActive ? const Color(0xFFE91E63) : Colors.grey.shade400,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        int columns = 4;
        if (width < 500) {
          columns = 2;
        } else if (width < 900) {
          columns = 2;
        } else if (width < 1200) {
          columns = 3;
        }

        final double padding = width < 500 ? 16 : 32;
        final double spacing = width < 500 ? 12 : 24;
        final double cardWidth = (width - (spacing * (columns - 1)) - (padding * 2)) / columns;
        final bool isSmall = width < 500;

        return SingleChildScrollView(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Vue d\'ensemble', style: GoogleFonts.outfit(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: -0.5)),
                  const SizedBox(height: 4),
                  Text('Voici ce qui se passe sur votre plateforme aujourd\'hui.', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade500)),
                ],
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: [
                  SizedBox(width: cardWidth, child: _buildMetricCard('Volume d\'affaires', '0 FCFA', '+0.00%', Icons.account_balance_wallet_rounded, true, isSmall)),
                  SizedBox(width: cardWidth, child: _buildMetricCard('Revenus Nette', '0 FCFA', '+0.00%', Icons.insights_rounded, false, isSmall)),
                  SizedBox(width: cardWidth, child: _buildMetricCard('Vendeurs Actifs', '0', '+0.00%', Icons.storefront_rounded, false, isSmall)),
                  SizedBox(width: cardWidth, child: _buildMetricCard('Nouveaux Clients', '0', '+0.00%', Icons.people_alt_rounded, true, isSmall)),
                ],
              ),
              const SizedBox(height: 32),
          Container(
            height: 380,
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildChartTab('Revenus', 0),
                    const SizedBox(width: 24),
                    _buildChartTab('Vendeurs', 1),
                    const SizedBox(width: 24),
                    _buildChartTab('Commandes', 2),
                  ],
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 8),
                    child: CustomPaint(
                      size: const Size(double.infinity, double.infinity),
                      painter: _SplineChartPainter(),
                    ),
                  ),
                ),
                // X Axis Labels
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'].map((label) {
                    return Text(label, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey.shade500));
                  }).toList(),
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

  Widget _buildMetricCard(String title, String value, String change, IconData icon, bool isPrimary, bool isSmall) {
    return Container(
      padding: EdgeInsets.all(isSmall ? 16 : 24),
      decoration: BoxDecoration(
        color: isPrimary ? const Color(0xFFE91E63) : const Color(0xFF232323),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: (isPrimary ? const Color(0xFFE91E63) : Colors.black).withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(title, style: GoogleFonts.inter(fontSize: isSmall ? 12 : 14, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.9))),
              ),
              Container(
                padding: EdgeInsets.all(isSmall ? 6 : 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: isSmall ? 14 : 18),
              ),
            ],
          ),
          SizedBox(height: isSmall ? 16 : 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: GoogleFonts.outfit(fontSize: isSmall ? 20 : 28, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5)),
              Text(change, style: GoogleFonts.inter(fontSize: isSmall ? 11 : 13, fontWeight: FontWeight.w600, color: Colors.white.withOpacity(0.9))),
            ],
          ),
        ],
      ),
    );
  }
}

class _SplineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE91E63)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Hardcoded data points relative to size
    final points = [
      Offset(0, size.height * 0.6),
      Offset(size.width * 0.1, size.height * 0.5),
      Offset(size.width * 0.2, size.height * 0.8),
      Offset(size.width * 0.35, size.height * 0.65),
      Offset(size.width * 0.45, size.height * 0.75),
      Offset(size.width * 0.6, size.height * 0.2),
      Offset(size.width * 0.7, size.height * 0.25),
      Offset(size.width * 0.85, size.height * 0.1),
      Offset(size.width, size.height * 0.4),
    ];

    // Selected points that have dots and drop lines
    final highlightedIndices = [1, 2, 4, 5, 6, 8];

    // Draw drop lines
    final linePaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    for (var index in highlightedIndices) {
      if (index < points.length) {
        final pt = points[index];
        canvas.drawLine(pt, Offset(pt.dx, size.height), linePaint);
      }
    }

    // Draw spline curve
    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      // Control points for a simple smooth curve
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p1.dx, p1.dy);
    }
    
    canvas.drawPath(path, paint);

    // Draw dots
    final dotOuterPaint = Paint()..color = Colors.black87..style = PaintingStyle.stroke..strokeWidth = 2.5;
    final dotInnerPaint = Paint()..color = Colors.white..style = PaintingStyle.fill;

    for (var index in highlightedIndices) {
      if (index < points.length) {
        final pt = points[index];
        canvas.drawCircle(pt, 5, dotInnerPaint);
        canvas.drawCircle(pt, 5, dotOuterPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
