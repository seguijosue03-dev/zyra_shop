import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/core/theme/app_text_styles.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_gradient_button.dart';
import '../widgets/zyra_logo_widget.dart';

/// ZYRA Register Screen
///
/// Design: 80% clean white + 20% purple accent.
/// All text in French. Form validation in French.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _isLoading = false;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _onRegister() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez accepter les conditions d'utilisation"),
        ),
      );
      return;
    }
    setState(() => _isLoading = true);
    // Mock registration delay
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Compte créé avec succès ! (mock)')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              // ── Back button header ────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    _BackButton(onTap: () => Navigator.pop(context)),
                  ],
                ),
              ),

              // ── Scrollable content ────────────────
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // Logo
                      const Center(child: ZyraLogoWidget(size: 62)),
                      const SizedBox(height: 28),

                      // Heading
                      Text('Créer un compte', style: AppTextStyles.displayMedium),
                      const SizedBox(height: 8),
                      Text(
                        'Rejoignez des milliers d\'acheteurs sur Zyra.',
                        style: AppTextStyles.bodyMedium,
                      ),
                      const SizedBox(height: 28),

                      // Form
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            // Full name
                            AuthTextField(
                              label: 'Nom complet',
                              hint: 'Jean Dupont',
                              controller: _nameCtrl,
                              keyboardType: TextInputType.name,
                              prefixIcon: Icons.person_outline,
                              textInputAction: TextInputAction.next,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Veuillez entrer votre nom complet';
                                }
                                if (v.trim().length < 2) {
                                  return 'Le nom doit contenir au moins 2 caractères';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Email
                            AuthTextField(
                              label: 'Adresse e-mail',
                              hint: 'exemple@email.com',
                              controller: _emailCtrl,
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.email_outlined,
                              textInputAction: TextInputAction.next,
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
                            const SizedBox(height: 16),

                            // Password
                            AuthTextField(
                              label: 'Mot de passe',
                              hint: '••••••••',
                              controller: _passwordCtrl,
                              isPassword: true,
                              prefixIcon: Icons.lock_outline,
                              textInputAction: TextInputAction.next,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Veuillez entrer un mot de passe';
                                }
                                if (v.length < 8) {
                                  return 'Le mot de passe doit contenir au moins 8 caractères';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),

                            // Confirm password
                            AuthTextField(
                              label: 'Confirmer le mot de passe',
                              hint: '••••••••',
                              controller: _confirmCtrl,
                              isPassword: true,
                              prefixIcon: Icons.lock_outline,
                              textInputAction: TextInputAction.done,
                              onEditingComplete: _onRegister,
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Veuillez confirmer votre mot de passe';
                                }
                                if (v != _passwordCtrl.text) {
                                  return 'Les mots de passe ne correspondent pas';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Terms checkbox
                      _TermsRow(
                        accepted: _acceptedTerms,
                        onChanged: (val) =>
                            setState(() => _acceptedTerms = val ?? false),
                      ),
                      const SizedBox(height: 24),

                      // CTA button
                      AuthGradientButton(
                        label: 'S\'inscrire',
                        isLoading: _isLoading,
                        onPressed: _isLoading ? null : _onRegister,
                      ),
                      const SizedBox(height: 28),

                      // Login link
                      Center(
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                              children: [
                                const TextSpan(text: 'Déjà un compte ? '),
                                TextSpan(
                                  text: 'Se connecter',
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
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Internal widgets ──────────────────────────────────────────────────────────

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border, width: 1),
        ),
        child: const Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _TermsRow extends StatelessWidget {
  final bool accepted;
  final ValueChanged<bool?> onChanged;

  const _TermsRow({required this.accepted, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!accepted),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: Checkbox(
              value: accepted,
              onChanged: onChanged,
              activeColor: AppColors.primary,
              side: const BorderSide(color: AppColors.border, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                children: [
                  const TextSpan(
                    text: 'En créant un compte, vous acceptez nos ',
                  ),
                  TextSpan(
                    text: 'Conditions d\'utilisation',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const TextSpan(text: ' et notre '),
                  TextSpan(
                    text: 'Politique de confidentialité',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
