import 'package:flutter/material.dart';

/// ZYRA Shop — Brand Color Palette
///
/// Design split:
///   • 80% → Clean white marketplace (surfaces, typography, borders)
///   • 20% → ZYRA brand accent (CTAs, active states, highlights)
class AppColors {
  AppColors._();

  // ────────────────────────────────────────────────
  // BRAND ACCENT  (20% — extracted from ZYRA logo)
  // ────────────────────────────────────────────────
  static const Color primary = Color(0xFF8B3DFF);
  static const Color secondary = Color(0xFFC75CFF);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF8B3DFF), Color(0xFFC75CFF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient primaryGradientDiagonal = LinearGradient(
    colors: [Color(0xFF8B3DFF), Color(0xFFC75CFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ────────────────────────────────────────────────
  // BACKGROUNDS & SURFACES  (80% — clean marketplace)
  // ────────────────────────────────────────────────
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFF7F7F9);
  static const Color surfaceElevated = Color(0xFFEFEFF5);

  // ────────────────────────────────────────────────
  // TYPOGRAPHY
  // ────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF111827);   // Premium Black
  static const Color textSecondary = Color(0xFF374151); // Dark Gray
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textLink = Color(0xFF8B3DFF);

  // ────────────────────────────────────────────────
  // BORDERS & DIVIDERS
  // ────────────────────────────────────────────────
  static const Color border = Color(0xFFE5E7EB);
  static const Color borderFocused = Color(0xFF8B3DFF);
  static const Color divider = Color(0xFFF3F4F6);

  // ────────────────────────────────────────────────
  // STATUS
  // ────────────────────────────────────────────────
  static const Color success = Color(0xFF10B981);
  static const Color successSurface = Color(0xFFECFDF5);
  static const Color error = Color(0xFFEF4444);
  static const Color errorSurface = Color(0xFFFEF2F2);
  static const Color warning = Color(0xFFF59E0B);

  // ────────────────────────────────────────────────
  // DARK MODE  (ready for future)
  // ────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF0F0F14);
  static const Color darkSurface = Color(0xFF1A1A24);
  static const Color darkSurfaceElevated = Color(0xFF252532);
  static const Color darkTextPrimary = Color(0xFFF1F1F5);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkBorder = Color(0xFF2D2D3D);
}
