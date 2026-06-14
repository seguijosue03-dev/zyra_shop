import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/core/theme/app_text_styles.dart';
import 'package:zyra_shop/core/state/app_state.dart';
import '../widgets/checkout_progress_indicator.dart';
import 'checkout_payment_screen.dart';

class CheckoutAddressScreen extends StatefulWidget {
  const CheckoutAddressScreen({super.key});

  @override
  State<CheckoutAddressScreen> createState() => _CheckoutAddressScreenState();
}

class _CheckoutAddressScreenState extends State<CheckoutAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController(text: 'Josue Segui (360003)');
  final _phoneController = TextEditingController(text: '07 07 07 07 07');
  final _addressController = TextEditingController(text: 'Marwadi university');
  final _cityController = TextEditingController(text: 'Marwadi university');
  final _communeController = TextEditingController(text: 'Marwadi university');
  final _zipController = TextEditingController(text: '00225');

  Widget _buildTextField(String label, String hint, TextEditingController controller, {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: type,
            style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.inter(color: AppColors.textHint, fontSize: 14),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border, width: 1.2),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.border, width: 1.2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
            validator: (value) {
              if (label.contains('optionnel')) return null;
              if (value == null || value.trim().isEmpty) {
                return 'Ce champ est requis';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Adresse de livraison', style: AppTextStyles.headlineLarge.copyWith(fontSize: 18)),
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
          const CheckoutProgressIndicator(currentStep: 1),
          const Divider(color: AppColors.border, height: 1),
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField('Nom complet', 'Kouassi Jean', _nameController),
                    _buildTextField('Numéro de téléphone', '07 07 07 07 07', _phoneController, type: TextInputType.phone),
                    _buildTextField('Adresse', 'Rue des Jardins, Immeuble A', _addressController),
                    _buildTextField('Ville', 'Abidjan', _cityController),
                    _buildTextField('Commune', 'Cocody', _communeController),
                    _buildTextField('Code postal (optionnel)', 'Ex: 00225', _zipController, type: TextInputType.number),
                  ],
                ),
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
                    if (_formKey.currentState!.validate()) {
                      // Save the address to AppState
                      final name = _nameController.text.trim();
                      final location = '${_addressController.text.trim()}, ${_cityController.text.trim()}';
                      AppState().saveShippingAddress(name, location);
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const CheckoutPaymentScreen()),
                      );
                    }
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
