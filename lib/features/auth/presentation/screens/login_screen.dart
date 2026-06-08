import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/core/theme/app_text_styles.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_gradient_button.dart';
import '../widgets/zyra_logo_widget.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';

/// ZYRA Login Screen
///
/// Design: 80% clean white marketplace + 20% purple accent.
/// All text in French.
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
    // Mock authentication delay
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Connexion réussie ! (mock)')),
    );
  }

  void _goToRegister() {
    Navigator.push(
      context,
      _slideUpRoute(const RegisterScreen()),
    );
  }

  void _goToForgotPassword() {
    Navigator.push(
      context,
      _slideUpRoute(const ForgotPasswordScreen()),
    );
  }

  PageRouteBuilder<dynamic> _slideUpRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) => SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 44),

                // ── Logo ────────────────────────────
                const Center(child: ZyraLogoWidget(size: 72)),
                const SizedBox(height: 36),

                // ── Heading ─────────────────────────
                Text('Bienvenue 👋', style: AppTextStyles.displayMedium),
                const SizedBox(height: 8),
                Text(
                  'Connectez-vous à votre compte Zyra.',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 32),

                // ── Form ────────────────────────────
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      AuthTextField(
                        label: 'Adresse e-mail',
                        hint: 'exemple@email.com',
                        controller: _emailCtrl,
                        focusNode: _emailFocus,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        textInputAction: TextInputAction.next,
                        onEditingComplete: () => _passwordFocus.requestFocus(),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) {
                            return 'Veuillez entrer votre adresse e-mail';
                          }
                          final emailRegex =
                              RegExp(r'^[\w-.]+@([\w-]+\.)+[\w]{2,4}$');
                          if (!emailRegex.hasMatch(v.trim())) {
                            return 'Adresse e-mail invalide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 18),
                      AuthTextField(
                        label: 'Mot de passe',
                        hint: '••••••••',
                        controller: _passwordCtrl,
                        focusNode: _passwordFocus,
                        isPassword: true,
                        prefixIcon: Icons.lock_outline,
                        textInputAction: TextInputAction.done,
                        onEditingComplete: _onSignIn,
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return 'Veuillez entrer votre mot de passe';
                          }
                          if (v.length < 8) {
                            return 'Le mot de passe doit contenir au moins 8 caractères';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),

                // ── Forgot password link ─────────────
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: _goToForgotPassword,
                    child: Text(
                      'Mot de passe oublié ?',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // ── CTA button ──────────────────────
                AuthGradientButton(
                  label: 'Se connecter',
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _onSignIn,
                ),
                const SizedBox(height: 44),

                // ── Sign-up link ────────────────────
                Center(
                  child: GestureDetector(
                    onTap: _goToRegister,
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                        children: [
                          const TextSpan(text: 'Pas encore de compte ? '),
                          TextSpan(
                            text: 'Créer un compte',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


