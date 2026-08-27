import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/features/seller/presentation/state/mock_seller_state.dart';
import 'seller_request_sent_screen.dart';

class SellerRegistrationScreen extends StatefulWidget {
  const SellerRegistrationScreen({super.key});

  @override
  State<SellerRegistrationScreen> createState() => _SellerRegistrationScreenState();
}

class _SellerRegistrationScreenState extends State<SellerRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogoUploaded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black54, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Devenir vendeur', style: GoogleFonts.inter(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w600)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset('assets/images/logo.png', width: 60),
              ),
              const SizedBox(height: 24),
              Text('Devenir vendeur sur ZYRA', style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 8),
              Text('Remplissez ce formulaire pour créer votre boutique et commencer à vendre.', style: GoogleFonts.inter(fontSize: 14, color: Colors.grey.shade600)),
              const SizedBox(height: 32),

              _buildTextField('Nom complet', Icons.person_outline),
              const SizedBox(height: 20),
              _buildTextField('Nom de la boutique', Icons.storefront_outlined),
              const SizedBox(height: 20),
              _buildTextField('Adresse e-mail', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 20),
              _buildTextField('Numéro de téléphone', Icons.phone_outlined, keyboardType: TextInputType.phone),
              const SizedBox(height: 20),
              _buildTextField('Ville', Icons.location_city_outlined),
              const SizedBox(height: 20),
              _buildTextField('Description de la boutique', Icons.description_outlined, maxLines: 4),
              const SizedBox(height: 24),

              Text('Logo de la boutique', style: GoogleFonts.inter(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isLogoUploaded = !_isLogoUploaded;
                  });
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    color: _isLogoUploaded ? Colors.green.withValues(alpha: 0.1) : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _isLogoUploaded ? Colors.green : Colors.black26, width: 1),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        _isLogoUploaded ? Icons.check_circle_outline : Icons.cloud_upload_outlined,
                        color: _isLogoUploaded ? Colors.green : Colors.black87,
                        size: 36,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _isLogoUploaded ? 'Logo_Boutique.png' : 'Cliquez pour télécharger',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: _isLogoUploaded ? Colors.green : Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (!_isLogoUploaded) ...[
                        const SizedBox(height: 4),
                        Text('PNG, JPG jusqu\'à 5MB', style: GoogleFonts.inter(fontSize: 12, color: Colors.black54)),
                      ]
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [AppColors.primary, Color(0xFFC2185B)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    boxShadow: [
                      BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        MockSellerState().submitRegistration();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const SellerRequestSentScreen()));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: Text('Soumettre ma demande', style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, IconData icon, {TextInputType? keyboardType, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 14, color: Colors.black87, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black26, width: 1),
          ),
          child: Row(
            crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: maxLines > 1 ? 16 : 0),
                child: Icon(icon, color: Colors.black87, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  keyboardType: keyboardType,
                  maxLines: maxLines,
                  style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
                  validator: (v) => v!.isEmpty ? 'Ce champ est requis' : null,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    hintText: 'Saisir $label'.toLowerCase(),
                    hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
