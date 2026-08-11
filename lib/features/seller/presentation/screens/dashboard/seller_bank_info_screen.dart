import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/features/seller/presentation/state/mock_seller_state.dart';

class SellerBankInfoScreen extends StatefulWidget {
  const SellerBankInfoScreen({super.key});

  @override
  State<SellerBankInfoScreen> createState() => _SellerBankInfoScreenState();
}

class _SellerBankInfoScreenState extends State<SellerBankInfoScreen> {
  late TextEditingController _ibanController;
  late TextEditingController _bicController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Default mock data to populate the fields to match the ending digits
    final state = MockSellerState();
    _ibanController = TextEditingController(text: 'FR76 3000 4028 3719 3847 ${state.bankAccountEnding}');
    _bicController = TextEditingController(text: 'SOCFRPP');
  }

  @override
  void dispose() {
    _ibanController.dispose();
    _bicController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      // Just extract the last 4 characters safely
      String text = _ibanController.text.replaceAll(' ', '');
      String ending = text.length >= 4 ? text.substring(text.length - 4) : text;
      
      MockSellerState().updateStoreData(newBankAccountEnding: ending);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informations bancaires mises à jour !'), backgroundColor: Colors.green),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Informations bancaires',
          style: GoogleFonts.inter(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF232526), Color(0xFF414345)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8)),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.account_balance_rounded, color: Colors.white70, size: 28),
                        Text('ZYRA PAYOUT', style: GoogleFonts.inter(color: Colors.white70, fontWeight: FontWeight.bold, letterSpacing: 2)),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      _ibanController.text.isEmpty ? 'FR76 •••• •••• •••• ••••' : _ibanController.text,
                      style: GoogleFonts.sourceCodePro(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 1.5),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('TITULAIRE', style: GoogleFonts.inter(color: Colors.white54, fontSize: 10, letterSpacing: 1)),
                            const SizedBox(height: 4),
                            Text(MockSellerState().storeName.toUpperCase(), style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('BIC/SWIFT', style: GoogleFonts.inter(color: Colors.white54, fontSize: 10, letterSpacing: 1)),
                            const SizedBox(height: 4),
                            Text(_bicController.text, style: GoogleFonts.inter(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Text(
                'Mettre à jour vos coordonnées',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 8),
              Text(
                'Ces informations sont utilisées pour vous reverser vos gains sur les ventes.',
                style: GoogleFonts.inter(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _ibanController,
                decoration: InputDecoration(
                  labelText: 'IBAN',
                  labelStyle: GoogleFonts.inter(fontSize: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.credit_card_outlined),
                ),
                onChanged: (_) => setState(() {}),
                validator: (val) => val == null || val.isEmpty ? 'Champ requis' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _bicController,
                decoration: InputDecoration(
                  labelText: 'Code BIC / SWIFT',
                  labelStyle: GoogleFonts.inter(fontSize: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  prefixIcon: const Icon(Icons.account_balance_outlined),
                ),
                onChanged: (_) => setState(() {}),
                validator: (val) => val == null || val.isEmpty ? 'Champ requis' : null,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: MediaQuery.of(context).padding.bottom + 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
          ],
        ),
        child: ElevatedButton(
          onPressed: _save,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black87,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text(
            'Sécuriser et Enregistrer',
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
