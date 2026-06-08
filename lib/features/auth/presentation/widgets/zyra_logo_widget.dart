import 'package:flutter/material.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';

/// Reusable ZYRA logo widget.
///
/// Displays `assets/images/logo.png` at the requested [size].
/// Falls back to a gradient "Z" container if the asset is unavailable.
class ZyraLogoWidget extends StatelessWidget {
  /// Width of the logo image.
  final double size;

  const ZyraLogoWidget({super.key, this.size = 90});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/logo.png',
      width: size,
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => _FallbackLogo(size: size),
    );
  }
}

/// Shown when `assets/images/logo.png` is not found.
class _FallbackLogo extends StatelessWidget {
  final double size;
  const _FallbackLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradientDiagonal,
        borderRadius: BorderRadius.circular(size * 0.22),
      ),
      child: Center(
        child: Text(
          'Z',
          style: TextStyle(
            fontSize: size * 0.56,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1,
          ),
        ),
      ),
    );
  }
}
