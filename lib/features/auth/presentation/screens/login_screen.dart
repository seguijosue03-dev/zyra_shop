import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'package:zyra_shop/features/home/presentation/home.dart';
import 'package:zyra_shop/features/admin/presentation/screens/admin_dashboard_wrapper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  Future<void> _onSignIn() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Faster mock
    if (!mounted) return;
    setState(() => _isLoading = false);

    if (_emailCtrl.text.trim().toLowerCase() == 'admin@zyra.com') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AdminDashboardWrapper()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeNavigationWrapper()),
      );
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const RegisterScreen(),
        transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
      ),
    );
  }

  void _goToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    bool isPassword = false,
    required FocusNode focusNode,
    FocusNode? nextFocus,
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
              textInputAction: nextFocus != null ? TextInputAction.next : TextInputAction.done,
              onEditingComplete: () {
                if (nextFocus != null) {
                  nextFocus.requestFocus();
                } else {
                  _onSignIn();
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
    final screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA), // Slightly off-white to make the white container pop
        body: Stack(
          children: [
            // ── Background Corner Blobs ──
            Positioned(
              top: -120,
              left: -80,
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
              bottom: -100,
              right: -80,
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
              bottom: -40,
              right: 60,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.secondary.withOpacity(0.9),
                ),
              ),
            ),

            // ── Main Content ──
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 140), // Push down to avoid top blob completely
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Logo centered
                    Center(
                      child: Column(
                        children: [
                          Image.asset('assets/images/logo.png', width: 100),
                          const SizedBox(height: 16),
                          Text(
                            'Se connecter',
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

                    // Perfect Form Container
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // White Box
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
                                color: Colors.black.withOpacity(0.06),
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
                                  controller: _emailCtrl,
                                  icon: Icons.person_outline,
                                  hint: 'Adresse e-mail',
                                  focusNode: _emailFocus,
                                  nextFocus: _passwordFocus,
                                ),
                                const Divider(height: 1, color: Color(0xFFF0F0F0), indent: 24, endIndent: 24),
                                _buildTextField(
                                  controller: _passwordCtrl,
                                  icon: Icons.lock_outline,
                                  hint: 'Mot de passe',
                                  isPassword: true,
                                  focusNode: _passwordFocus,
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Action Button Perfectly Overlapping Right Edge
                        Positioned(
                          right: -28, // Half of button width
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
                                _onSignIn();
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
                                child: _isLoading
                                    ? const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)))
                                    : const Icon(Icons.arrow_forward, color: Colors.white, size: 24),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Forgot Password Left-Aligned
                    Container(
                      width: screenWidth * 0.82,
                      padding: const EdgeInsets.only(top: 16, left: 24),
                      alignment: Alignment.centerLeft,
                      child: GestureDetector(
                        onTap: _goToForgotPassword,
                        child: Text(
                          'Mot de passe oublié ?',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.black45, // Slightly darker for better readability
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),

            // ── Register Pill attached to Left Edge ──
            Positioned(
              bottom: 40,
              left: 0,
              child: GestureDetector(
                onTap: _goToRegister,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(2, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    'Créer un compte',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.error, // Red pill text like reference
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


