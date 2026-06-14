import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';

class CheckoutProgressIndicator extends StatelessWidget {
  final int currentStep;

  const CheckoutProgressIndicator({super.key, required this.currentStep});

  @override
  Widget build(BuildContext context) {
    const steps = ['Adresse', 'Paiement', 'Résumé'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.white,
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            final stepIndex = index ~/ 2;
            final isActive = currentStep > stepIndex + 1;
            return Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                height: 2,
                color: isActive ? AppColors.primary : const Color(0xFFE5E7EB),
              ),
            );
          }

          final stepIndex = index ~/ 2;
          final stepNumber = stepIndex + 1;
          final isActive = currentStep >= stepNumber;
          final isCompleted = currentStep > stepNumber;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted
                      ? AppColors.primary
                      : isActive
                          ? AppColors.primary
                          : const Color(0xFFF3F4F6),
                  border: Border.all(
                    color: isActive ? AppColors.primary : const Color(0xFFE5E7EB),
                    width: 2,
                  ),
                ),
                alignment: Alignment.center,
                child: isCompleted
                    ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                    : Text(
                        '$stepNumber',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isActive ? Colors.white : const Color(0xFF9CA3AF),
                        ),
                      ),
              ),
              const SizedBox(height: 6),
              Text(
                steps[stepIndex],
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? AppColors.textPrimary : const Color(0xFF9CA3AF),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
