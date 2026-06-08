import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/core/theme/app_text_styles.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_gradient_button.dart';

/// ZYRA Forgot Password Screen
///
/// Two animated states:
///   [_InputState]   — E-mail field + send button
///   [_SuccessState] — Animated checkmark + confirmation message
///
/// All text in French.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSendLink() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // Mock API delay
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      _emailSent = true;
    });
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
              // Header with back button
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

              // Animated content switch
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 450),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.08),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: _emailSent
                      ? _SuccessView(
                          key: const ValueKey('success'),
                          email: _emailCtrl.text.trim(),
                          onBackToLogin: () => Navigator.pop(context),
                          onResend: () => setState(() => _emailSent = false),
                        )
                      : _InputView(
                          key: const ValueKey('input'),
                          formKey: _formKey,
                          emailCtrl: _emailCtrl,
                          isLoading: _isLoading,
                          onSend: _onSendLink,
                          onBackToLogin: () => Navigator.pop(context),
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

// ── Input view ────────────────────────────────────────────────────────────────

class _InputView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final bool isLoading;
  final VoidCallback onSend;
  final VoidCallback onBackToLogin;

  const _InputView({
    super.key,
    required this.formKey,
    required this.emailCtrl,
    required this.isLoading,
    required this.onSend,
    required this.onBackToLogin,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Icon illustration
          Center(
            child: Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                Icons.lock_reset_rounded,
                size: 42,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 36),

          // Heading
          Text('Mot de passe oublié ?', style: AppTextStyles.headlineLarge),
          const SizedBox(height: 12),
          Text(
            'Pas de panique ! Entrez votre adresse e-mail et nous vous enverrons un lien pour réinitialiser votre mot de passe.',
            style: AppTextStyles.bodyMedium.copyWith(height: 1.65),
          ),
          const SizedBox(height: 32),

          // Email form
          Form(
            key: formKey,
            child: AuthTextField(
              label: 'Adresse e-mail',
              hint: 'exemple@email.com',
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email_outlined,
              textInputAction: TextInputAction.done,
              onEditingComplete: onSend,
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
          ),
          const SizedBox(height: 28),

          // Send link button
          AuthGradientButton(
            label: 'Envoyer le lien',
            isLoading: isLoading,
            onPressed: isLoading ? null : onSend,
          ),
          const SizedBox(height: 24),

          // Back to login link
          Center(
            child: GestureDetector(
              onTap: onBackToLogin,
              child: Text(
                'Retour à la connexion',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Success view ──────────────────────────────────────────────────────────────

class _SuccessView extends StatefulWidget {
  final String email;
  final VoidCallback onBackToLogin;
  final VoidCallback onResend;

  const _SuccessView({
    super.key,
    required this.email,
    required this.onBackToLogin,
    required this.onResend,
  });

  @override
  State<_SuccessView> createState() => _SuccessViewState();
}

class _SuccessViewState extends State<_SuccessView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _checkCtrl;
  late final Animation<double> _checkScale;
  late final Animation<double> _checkFade;

  @override
  void initState() {
    super.initState();
    _checkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _checkScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _checkCtrl, curve: Curves.elasticOut),
    );
    _checkFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _checkCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
    _checkCtrl.forward();
  }

  @override
  void dispose() {
    _checkCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Animated checkmark
          Center(
            child: ScaleTransition(
              scale: _checkScale,
              child: FadeTransition(
                opacity: _checkFade,
                child: Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: AppColors.successSurface,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  child: const Icon(
                    Icons.mark_email_read_outlined,
                    size: 44,
                    color: AppColors.success,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 36),

          // Heading
          Text('E-mail envoyé !', style: AppTextStyles.headlineLarge),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.65,
              ),
              children: [
                const TextSpan(
                  text:
                      'Un lien de réinitialisation a été envoyé à ',
                ),
                TextSpan(
                  text: widget.email,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const TextSpan(
                  text:
                      '. Vérifiez votre boîte de réception et vos spams.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),

          // Back to login button
          AuthGradientButton(
            label: 'Retour à la connexion',
            onPressed: widget.onBackToLogin,
          ),
          const SizedBox(height: 24),

          // Resend link
          Center(
            child: GestureDetector(
              onTap: widget.onResend,
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    const TextSpan(text: "Vous n'avez pas reçu l'e-mail ? "),
                    TextSpan(
                      text: 'Renvoyer',
                      style: GoogleFonts.inter(
                        fontSize: 13,
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
    );
  }
}

// ── Shared back button ────────────────────────────────────────────────────────

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
