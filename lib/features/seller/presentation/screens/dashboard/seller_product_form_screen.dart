import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/features/home/presentation/widgets/mock_products.dart';
import 'package:zyra_shop/features/seller/presentation/state/mock_dashboard_state.dart';

class SellerProductFormScreen extends StatefulWidget {
  const SellerProductFormScreen({super.key});

  @override
  State<SellerProductFormScreen> createState() => _SellerProductFormScreenState();
}

class _SellerProductFormScreenState extends State<SellerProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();

  final List<String> _sizes = ['S', 'M', 'L'];
  final TextEditingController _sizeController = TextEditingController();

  final List<String> _colors = ['Noir', 'Blanc'];
  final TextEditingController _colorController = TextEditingController();

  String? _selectedCategory;

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _sizeController.dispose();
    _colorController.dispose();
    super.dispose();
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
          icon: const Icon(Icons.close_rounded, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Ajouter un produit', style: GoogleFonts.inter(color: Colors.black87, fontSize: 16, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {
              final priceVal = _priceController.text.trim().isEmpty ? '0' : _priceController.text.trim();
              final nameVal = _nameController.text.trim().isEmpty ? 'Nouveau Produit' : _nameController.text.trim();
              
              MockDashboardState().addProduct({
                'id': DateTime.now().millisecondsSinceEpoch.toString(),
                'name': nameVal,
                'price': '$priceVal FCFA',
                'originalPrice': null,
                'discount': null,
                'stock': int.tryParse(_stockController.text) ?? 10,
                'imageUrl': 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?q=80&w=200',
                'status': 'En stock',
                'statusColor': Colors.green,
                'category': _selectedCategory ?? 'TOUT',
              });
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Produit enregistré')));
              Navigator.pop(context);
            },
            child: Text('Enregistrer', style: GoogleFonts.inter(color: const Color(0xFFFF4B72), fontWeight: FontWeight.bold)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(color: Colors.grey.shade200, height: 1),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Photos Section
              _buildSectionTitle('Photos du produit'),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildAddPhotoBox(),
                    const SizedBox(width: 16),
                    _buildMockPhoto('https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?q=80&w=200'),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Basic Info
              _buildSectionTitle('Informations générales'),
              _buildTextField('Nom du produit', 'Ex: Robe d\'été florale', controller: _nameController),
              const SizedBox(height: 16),
              _buildTextField('Description', 'Décrivez votre produit...', maxLines: 4, controller: _descController),
              const SizedBox(height: 16),
              _buildDropdownField('Catégorie', 'Sélectionner une catégorie', mockCategories.map((e) => e.name).toList(), _selectedCategory, (val) {
                setState(() => _selectedCategory = val);
              }),
              const SizedBox(height: 32),

              // Pricing & Promotion
              _buildSectionTitle('Tarification & Promotion'),
              Row(
                children: [
                  Expanded(child: _buildTextField('Prix original (FCFA)', 'Ex: 25000', keyboardType: TextInputType.number, controller: _priceController)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildTextField('Réduction (%)', 'Ex: 20', keyboardType: TextInputType.number)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green.shade200)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Prix promotionnel calculé', style: GoogleFonts.inter(fontSize: 13, color: Colors.green.shade800, fontWeight: FontWeight.w600)),
                    Text('20 000 FCFA', style: GoogleFonts.inter(fontSize: 16, color: Colors.green.shade800, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Inventory & Variants
              _buildSectionTitle('Inventaire & Variantes'),
              _buildTextField('Quantité en stock', 'Ex: 50', keyboardType: TextInputType.number, controller: _stockController),
              const SizedBox(height: 16),
              _buildTagsField('Tailles disponibles', 'Ajouter une taille et faire Entrée', _sizes, _sizeController, (val) {
                setState(() => _sizes.add(val));
              }, (val) {
                setState(() => _sizes.remove(val));
              }),
              const SizedBox(height: 16),
              _buildTagsField('Couleurs', 'Ajouter une couleur et faire Entrée', _colors, _colorController, (val) {
                setState(() => _colors.add(val));
              }, (val) {
                setState(() => _colors.remove(val));
              }),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(title, style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  Widget _buildTextField(String label, String hint, {TextInputType? keyboardType, int maxLines = 1, TextEditingController? controller}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: GoogleFonts.inter(fontSize: 15, color: Colors.black),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black12, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.black87, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, String hint, List<String> items, String? selectedValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12, width: 1),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedValue,
              hint: Text(hint, style: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 14)),
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54),
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTagsField(String label, String hint, List<String> items, TextEditingController controller, Function(String) onAdd, Function(String) onRemove) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 13, color: Colors.black87, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (items.isNotEmpty) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: items.map((item) => Chip(
                    label: Text(item, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                    backgroundColor: Colors.grey.shade100,
                    deleteIconColor: Colors.black54,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6), side: BorderSide(color: Colors.grey.shade300)),
                    onDeleted: () => onRemove(item),
                  )).toList(),
                ),
                const SizedBox(height: 12),
              ],
              TextField(
                controller: controller,
                style: GoogleFonts.inter(fontSize: 14, color: Colors.black87),
                decoration: InputDecoration(
                  hintText: hint,
                  hintStyle: GoogleFonts.inter(color: Colors.grey.shade400, fontSize: 13),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty && !items.contains(value.trim())) {
                    onAdd(value.trim());
                    controller.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAddPhotoBox() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black26, width: 1), // Typically dashed, using solid for simplicity
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.add_a_photo_outlined, color: Colors.black54),
          const SizedBox(height: 8),
          Text('Ajouter', style: GoogleFonts.inter(fontSize: 12, color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildMockPhoto(String url) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
        border: Border.all(color: Colors.black12),
      ),
      alignment: Alignment.topRight,
      child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        child: const Icon(Icons.close, size: 12, color: Colors.black87),
      ),
    );
  }
}
