import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/core/theme/app_text_styles.dart';
import '../widgets/checkout_progress_indicator.dart';
import '../widgets/payment_method_card.dart';
import 'checkout_summary_screen.dart';

class CheckoutPaymentScreen extends StatefulWidget {
  const CheckoutPaymentScreen({super.key});

  @override
  State<CheckoutPaymentScreen> createState() => _CheckoutPaymentScreenState();
}

class _CheckoutPaymentScreenState extends State<CheckoutPaymentScreen> {
  String _selectedMethod = 'Wave';

  final List<Map<String, dynamic>> _methods = [
    {
      'id': 'Wave',
      'title': 'Wave',
      'desc': 'Paiement mobile simple et sans frais',
      'icon': Icons.waves_rounded,
    },
    {
      'id': 'Orange Money',
      'title': 'Orange Money',
      'desc': 'Payez avec votre compte Orange',
      'icon': Icons.phone_android_rounded,
    },
    {
      'id': 'MTN Money',
      'title': 'MTN Mobile Money',
      'desc': 'Payez avec votre compte MTN',
      'icon': Icons.phone_iphone_rounded,
    },
    {
      'id': 'Moov Money',
      'title': 'Moov Money',
      'desc': 'Payez avec votre compte Moov',
      'icon': Icons.smartphone_rounded,
    },
    {
      'id': 'Carte Bancaire',
      'title': 'Carte Bancaire',
      'desc': 'Visa, Mastercard',
      'icon': Icons.credit_card_rounded,
    },
    {
      'id': 'Cash',
      'title': 'Paiement à la livraison',
      'desc': 'Payez en espèces à la réception',
      'icon': Icons.local_shipping_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Mode de paiement', style: AppTextStyles.headlineLarge.copyWith(fontSize: 18)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          const CheckoutProgressIndicator(currentStep: 2),
          const Divider(color: AppColors.border, height: 1),
          
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Choisissez un mode de paiement',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._methods.map((method) => PaymentMethodCard(
                        title: method['title'],
                        description: method['desc'],
                        icon: method['icon'],
                        isSelected: _selectedMethod == method['id'],
                        onTap: () {
                          setState(() {
                            _selectedMethod = method['id'];
                          });
                        },
                      )),
                ],
              ),
            ),
          ),
          
          // Bottom Action
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: AppColors.border, width: 1.2)),
            ),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CheckoutSummaryScreen()),
                    );
                  },
                  child: Text(
                    'Continuer',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
