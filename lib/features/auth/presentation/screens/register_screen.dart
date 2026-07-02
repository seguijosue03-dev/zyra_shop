import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/features/auth/providers/auth_providers.dart';
import 'package:zyra_shop/features/home/presentation/home.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _whatsappCtrl = TextEditingController();

  final _nameFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _whatsappFocus = FocusNode();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _passwordCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _whatsappCtrl.dispose();
    _nameFocus.dispose();
    _passwordFocus.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _whatsappFocus.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authNotifierProvider.notifier).register(
      email: _emailCtrl.text.trim(),
      password: _passwordCtrl.text.trim(),
      fullName: _nameCtrl.text.trim(),
    );

    if (!mounted) return;

    final authState = ref.read(authNotifierProvider);

    if (authState.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authState.errorMessage!),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    // Register successful → navigate to home
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const HomeNavigationWrapper()),
          (route) => false,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool isPassword = false,
    required FocusNode focusNode,
    FocusNode? nextFocus,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54, size: 22),
          const SizedBox(width: 16),
          Expanded(
            child: TextFormField(
              controller: controller,
              focusNode: focusNode,
              obscureText: isPassword,
              keyboardType: keyboardType,
              textInputAction: nextFocus != null ? TextInputAction.next : TextInputAction.done,
              onEditingComplete: () {
                if (nextFocus != null) {
                  nextFocus.requestFocus();
                } else {
                  _onRegister();
                }
              },
              validator: (v) => v!.isEmpty ? '' : null,
              style: GoogleFonts.inter(fontSize: 15, color: Colors.black87, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: GoogleFonts.inter(color: Colors.black38, fontSize: 15),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                filled: false,
                fillColor: Colors.transparent,
                errorStyle: const TextStyle(height: 0, color: Colors.transparent),
                contentPadding: const EdgeInsets.symmetric(vertical: 20),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState.isLoading;
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        body: Stack(
          children: [
            // ── Background Corner Blobs ──
            Positioned(
              top: -100,
              left: -100,
              child: Container(
                width: 260,
                height: 260,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary,
                ),
              ),
            ),
            Positioned(
              bottom: -120,
              right: -60,
              child: Container(
                width: 280,
                height: 280,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary,
                ),
              ),
            ),
            Positioned(
              bottom: 60,
              right: -80,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary.withValues(alpha: 0.9),
                ),
              ),
            ),

            // ── Main Content ──
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 140),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Image.asset('assets/images/logo.png', width: 100),
                          const SizedBox(height: 16),
                          Text(
                            'Créer un compte',
                            style: GoogleFonts.inter(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),

                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: screenWidth * 0.82,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(50),
                              bottomRight: Radius.circular(50),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildTextField(
                                  controller: _nameCtrl,
                                  icon: Icons.person_outline,
                                  hint: 'Nom d\'utilisateur',
                                  focusNode: _nameFocus,
                                  nextFocus: _passwordFocus,
                                ),
                                const Divider(height: 1, color: Color(0xFFF0F0F0), indent: 24, endIndent: 24),
                                _buildTextField(
                                  controller: _passwordCtrl,
                                  icon: Icons.lock_outline,
                                  hint: 'Mot de passe',
                                  isPassword: true,
                                  focusNode: _passwordFocus,
                                  nextFocus: _emailFocus,
                                ),
                                const Divider(height: 1, color: Color(0xFFF0F0F0), indent: 24, endIndent: 24),
                                _buildTextField(
                                  controller: _emailCtrl,
                                  icon: Icons.email_outlined,
                                  hint: 'Adresse e-mail',
                                  focusNode: _emailFocus,
                                  nextFocus: _phoneFocus,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const Divider(height: 1, color: Color(0xFFF0F0F0), indent: 24, endIndent: 24),
                                _buildTextField(
                                  controller: _phoneCtrl,
                                  icon: Icons.phone_outlined,
                                  hint: 'Numéro de téléphone',
                                  focusNode: _phoneFocus,
                                  keyboardType: TextInputType.phone,
                                  nextFocus: _whatsappFocus,
                                ),
                                const Divider(height: 1, color: Color(0xFFF0F0F0), indent: 24, endIndent: 24),
                                _buildTextField(
                                  controller: _whatsappCtrl,
                                  icon: Icons.chat_outlined,
                                  hint: 'Numéro WhatsApp',
                                  focusNode: _whatsappFocus,
                                  keyboardType: TextInputType.phone,
                                ),
                              ],
                            ),
                          ),
                        ),

                        Positioned(
                          right: -28,
                          top: 0,
                          bottom: 0,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                if (!_formKey.currentState!.validate()) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Veuillez remplir tous les champs')),
                                  );
                                  return;
                                }
                                _onRegister();
                              },
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppColors.primaryGradientDiagonal,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black26,
                                      blurRadius: 10,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: isLoading
                                    ? const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)))
                                    : const Icon(Icons.check, color: Colors.white, size: 28),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),

            // ── Floating Login Pill ──
            Positioned(
              top: 50,
              right: 0,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      bottomLeft: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 15,
                        offset: const Offset(-2, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    'Se connecter',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}