import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/features/delivery/presentation/state/mock_delivery_state.dart';
import 'package:zyra_shop/features/delivery/presentation/screens/onboarding/driver_application_status_screen.dart';

class DriverRegistrationScreen extends StatefulWidget {
  const DriverRegistrationScreen({super.key});

  @override
  State<DriverRegistrationScreen> createState() => _DriverRegistrationScreenState();
}

class _DriverRegistrationScreenState extends State<DriverRegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _dobController = TextEditingController();
  
  final _cityController = TextEditingController(text: 'Abidjan');
  final _addressController = TextEditingController();

  // State selections
  String? _selectedZone;
  String? _selectedVehicle;
  String? _selectedDocumentType;
  String? _uploadedDocumentName;

  bool _isCertified = false;

  final List<String> _zones = ['Cocody', 'Yopougon', 'Marcory', 'Treichville', 'Plateau', 'Koumassi', 'Abobo'];
  
  final List<Map<String, String>> _vehicles = [
    {'id': 'foot', 'label': 'À pied', 'icon': '🚶'},
    {'id': 'moto', 'label': 'Moto', 'icon': '🏍️'},
    {'id': 'car', 'label': 'Voiture', 'icon': '🚗'},
    {'id': 'bike', 'label': 'Vélo', 'icon': '🚲'},
  ];

  final List<String> _documentTypes = ["Carte Nationale d'Identité", 'Passeport', 'Permis de conduire'];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _simulateDocumentUpload() {
    if (_selectedDocumentType == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Veuillez d'abord sélectionner le type de document")));
      return;
    }
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Sélectionner un fichier', style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
              title: Text('Galerie photo', style: GoogleFonts.inter()),
              onTap: () {
                Navigator.pop(context);
                setState(() => _uploadedDocumentName = 'document_scan_${DateTime.now().millisecondsSinceEpoch}.jpg');
              },
            ),
            ListTile(
              leading: const Icon(Icons.file_copy, color: AppColors.primary),
              title: Text('Fichiers locaux', style: GoogleFonts.inter()),
              onTap: () {
                Navigator.pop(context);
                setState(() => _uploadedDocumentName = 'CNI_recto_verso.pdf');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedZone == null || _selectedVehicle == null || _uploadedDocumentName == null || !_isCertified) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez remplir toutes les sélections et certifier les informations.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      // Save to mock state
      MockDeliveryState().submitApplication({
        'firstName': _firstNameController.text,
        'lastName': _lastNameController.text,
        'phone': _phoneController.text,
        'zone': _selectedZone,
        'vehicle': _selectedVehicle,
      });

      // Navigate
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DriverApplicationStatusScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text('Devenir Livreur', style: GoogleFonts.inter(color: AppColors.textPrimary, fontWeight: FontWeight.w600, fontSize: 16)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Rejoignez ZYRA', style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Text('Remplissez ce formulaire pour rejoindre notre réseau de livreurs partenaires.', style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary, height: 1.5)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Informations personnelles'),
                    _buildTextField('Prénom', _firstNameController),
                    _buildTextField('Nom', _lastNameController),
                    _buildTextField('Téléphone', _phoneController, keyboardType: TextInputType.phone),
                    _buildTextField('Email', _emailController, keyboardType: TextInputType.emailAddress),
                    _buildTextField('Date de naissance (JJ/MM/AAAA)', _dobController),
                    
                    const SizedBox(height: 32),
                    _buildSectionTitle('Adresse'),
                    _buildTextField('Ville', _cityController),
                    _buildTextField('Adresse complète', _addressController, maxLines: 2),

                    const SizedBox(height: 32),
                    _buildSectionTitle('Zone de livraison'),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: _zones.map((zone) {
                        final isSelected = _selectedZone == zone;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedZone = zone),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade300),
                              boxShadow: isSelected ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
                            ),
                            child: Text(
                              zone,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected ? Colors.white : AppColors.textPrimary,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 32),
                    _buildSectionTitle('Véhicule'),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: _vehicles.length,
                      itemBuilder: (context, index) {
                        final v = _vehicles[index];
                        final isSelected = _selectedVehicle == v['id'];
                        return GestureDetector(
                          onTap: () => setState(() => _selectedVehicle = v['id']),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary.withValues(alpha: 0.05) : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: isSelected ? AppColors.primary : Colors.grey.shade200, width: isSelected ? 2 : 1),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(v['icon']!, style: const TextStyle(fontSize: 28)),
                                const SizedBox(height: 8),
                                Text(v['label']!, style: GoogleFonts.inter(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 32),
                    _buildSectionTitle("Vérification d'identité"),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isExpanded: true,
                          value: _selectedDocumentType,
                          hint: Text('Choisir un type de document', style: GoogleFonts.inter(color: Colors.grey.shade400)),
                          items: _documentTypes.map((d) => DropdownMenuItem(value: d, child: Text(d))).toList(),
                          onChanged: (val) => setState(() => _selectedDocumentType = val),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: _simulateDocumentUpload,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          color: _uploadedDocumentName == null ? Colors.grey.shade50 : AppColors.primary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _uploadedDocumentName == null ? Colors.grey.shade300 : AppColors.primary,
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              _uploadedDocumentName == null ? Icons.cloud_upload_outlined : Icons.check_circle_rounded,
                              color: _uploadedDocumentName == null ? Colors.grey.shade400 : AppColors.primary,
                              size: 32,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              _uploadedDocumentName == null ? 'Ajouter mon document' : '✓ Document ajouté',
                              style: GoogleFonts.inter(
                                color: _uploadedDocumentName == null ? AppColors.textSecondary : AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (_uploadedDocumentName != null) ...[
                              const SizedBox(height: 4),
                              Text(_uploadedDocumentName!, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
                              const SizedBox(height: 8),
                              Text('[Modifier]', style: GoogleFonts.inter(fontSize: 12, color: AppColors.primary, decoration: TextDecoration.underline)),
                            ]
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 48),
                    _buildSectionTitle('Récapitulatif & Validation'),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _isCertified,
                            activeColor: AppColors.primary,
                            onChanged: (val) => setState(() => _isCertified = val ?? false),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Je certifie que les informations fournies sont exactes et j'accepte que ZYRA traite mes données pour ma candidature.",
                            style: GoogleFonts.inter(fontSize: 13, color: AppColors.textSecondary, height: 1.4),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: _isCertified ? _submit : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: Text(
                          'Envoyer ma demande',
                          style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: _isCertified ? Colors.white : Colors.grey.shade500),
                        ),
                      ),
                    ),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType? keyboardType, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: GoogleFonts.inter(fontSize: 14, color: AppColors.textPrimary),
        validator: (value) => value == null || value.trim().isEmpty ? 'Ce champ est requis' : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(color: Colors.grey.shade500, fontSize: 14),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}

