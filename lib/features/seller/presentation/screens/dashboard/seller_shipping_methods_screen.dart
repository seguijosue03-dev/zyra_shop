import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/features/seller/presentation/state/mock_seller_state.dart';

class SellerShippingMethodsScreen extends StatefulWidget {
  const SellerShippingMethodsScreen({super.key});

  @override
  State<SellerShippingMethodsScreen> createState() => _SellerShippingMethodsScreenState();
}

class _SellerShippingMethodsScreenState extends State<SellerShippingMethodsScreen> {
  late List<String> _selectedMethods;

  final List<Map<String, dynamic>> _availableMethods = [
    {
      'id': 'Standard',
      'title': 'Livraison Standard',
      'description': 'Livraison en 3 à 5 jours ouvrés.',
      'icon': Icons.local_shipping_outlined,
    },
    {
      'id': 'Express',
      'title': 'Livraison Express',
      'description': 'Livraison en 24h à 48h.',
      'icon': Icons.bolt_outlined,
    },
    {
      'id': 'Point Relais',
      'title': 'Point Relais',
      'description': 'Retrait dans l\'un de nos points partenaires.',
      'icon': Icons.storefront_outlined,
    },
    {
      'id': 'Retrait',
      'title': 'Retrait en magasin',
      'description': 'Le client vient récupérer sa commande sur place.',
      'icon': Icons.shopping_bag_outlined,
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedMethods = List.from(MockSellerState().shippingMethods);
  }

  void _save() {
    MockSellerState().updateStoreData(newShippingMethods: _selectedMethods);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Modes de livraison mis à jour !'), backgroundColor: Colors.green),
    );
    Navigator.pop(context);
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
          'Modes de livraison',
          style: GoogleFonts.inter(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sélectionnez les modes de livraison que vous proposez à vos clients.',
              style: GoogleFonts.inter(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 24),
            ..._availableMethods.map((method) => _buildMethodItem(method)).toList(),
          ],
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
            'Enregistrer',
            style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildMethodItem(Map<String, dynamic> method) {
    final isSelected = _selectedMethods.contains(method['id']);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedMethods.remove(method['id']);
          } else {
            _selectedMethods.add(method['id']);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black.withOpacity(0.02) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? Colors.black87 : Colors.grey.shade200, width: isSelected ? 1.5 : 1),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected ? Colors.black87 : Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(method['icon'], color: isSelected ? Colors.white : Colors.black54, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method['title'],
                    style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    method['description'],
                    style: GoogleFonts.inter(fontSize: 13, color: Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: isSelected ? Colors.black87 : Colors.grey.shade300,
            ),
          ],
        ),
      ),
    );
  }
}
