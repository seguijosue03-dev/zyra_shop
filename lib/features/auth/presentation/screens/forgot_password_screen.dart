import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/core/theme/app_text_styles.dart';
import 'package:zyra_shop/features/auth/providers/auth_providers.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/auth_gradient_button.dart';

// ── Reset mode ─────────────────────────────────────────────────────────────────
enum _ResetMode { email, phone }

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _sent = false;
  _ResetMode _mode = _ResetMode.email;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSend() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    if (_mode == _ResetMode.email) {
      await ref.read(authNotifierProvider.notifier).forgotPassword(
            email: _emailCtrl.text.trim(),
          );
    } else {
      String phone = _phoneCtrl.text.trim();
      if (!phone.startsWith('+')) phone = '+$phone';
      await ref.read(authNotifierProvider.notifier).forgotPasswordWithPhone(
            phone: phone,
          );
    }

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

    setState(() => _sent = true);
  }

  void _switchMode(_ResetMode mode) {
    if (_mode == mode) return;
    setState(() {
      _mode = mode;
      _sent = false;
    });
    _formKey.currentState?.reset();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                child: Row(
                  children: [
                    _BackButton(onTap: () => Navigator.pop(context)),
                  ],
                ),
              ),
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
                  child: _sent
                      ? _SuccessView(
                          key: ValueKey('success_${_mode.name}'),
                          identifier: _mode == _ResetMode.email
                              ? _emailCtrl.text.trim()
                              : _phoneCtrl.text.trim(),
                          isPhone: _mode == _ResetMode.phone,
                          onBackToLogin: () => Navigator.pop(context),
                          onResend: () => setState(() => _sent = false),
                        )
                      : _InputView(
                          key: ValueKey('input_${_mode.name}'),
                          formKey: _formKey,
                          emailCtrl: _emailCtrl,
                          phoneCtrl: _phoneCtrl,
                          isLoading: authState.isLoading,
                          mode: _mode,
                          onSwitchMode: _switchMode,
                          onSend: _onSend,
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
  final TextEditingController phoneCtrl;
  final bool isLoading;
  final _ResetMode mode;
  final void Function(_ResetMode) onSwitchMode;
  final VoidCallback onSend;
  final VoidCallback onBackToLogin;

  const _InputView({
    super.key,
    required this.formKey,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.isLoading,
    required this.mode,
    required this.onSwitchMode,
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
          // ── Icon ──
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
          Text('Mot de passe oublié ?', style: AppTextStyles.headlineLarge),
          const SizedBox(height: 12),
          Text(
            mode == _ResetMode.email
                ? 'Pas de panique ! Entrez votre adresse e-mail et nous vous enverrons un lien pour réinitialiser votre mot de passe.'
                : 'Entrez votre numéro de téléphone. Vous recevrez un code OTP par SMS pour réinitialiser votre mot de passe.',
            style: AppTextStyles.bodyMedium.copyWith(height: 1.65),
          ),
          const SizedBox(height: 28),

          // ── Toggle Email / Phone ──
          _ModeToggle(current: mode, onSwitch: onSwitchMode),
          const SizedBox(height: 24),

          // ── Form field ──
          Form(
            key: formKey,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              switchInCurve: Curves.easeOutCubic,
              child: mode == _ResetMode.email
                  ? AuthTextField(
                      key: const ValueKey('email_fp'),
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
                    )
                  : _PhoneField(
                      key: const ValueKey('phone_fp'),
                      controller: phoneCtrl,
                      onEditingComplete: onSend,
                    ),
            ),
          ),
          const SizedBox(height: 28),
          AuthGradientButton(
            label: mode == _ResetMode.email
                ? 'Envoyer le lien'
                : 'Envoyer le code SMS',
            isLoading: isLoading,
            onPressed: isLoading ? null : onSend,
          ),
          const SizedBox(height: 24),
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

// ── Mode toggle widget ─────────────────────────────────────────────────────────

class _ModeToggle extends StatelessWidget {
  final _ResetMode current;
  final void Function(_ResetMode) onSwitch;

  const _ModeToggle({required this.current, required this.onSwitch});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F0F0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          // Sliding pill
          AnimatedAlign(
            duration: const Duration(milliseconds: 240),
            curve: Curves.easeInOut,
            alignment: current == _ResetMode.email
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: FractionallySizedBox(
              widthFactor: 0.5,
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Labels
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => onSwitch(_ResetMode.email),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.email_outlined,
                          size: 16,
                          color: current == _ResetMode.email
                              ? AppColors.primary
                              : Colors.black45,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'E-mail',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: current == _ResetMode.email
                                ? AppColors.primary
                                : Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => onSwitch(_ResetMode.phone),
                  behavior: HitTestBehavior.opaque,
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 16,
                          color: current == _ResetMode.phone
                              ? AppColors.primary
                              : Colors.black45,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Téléphone',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: current == _ResetMode.phone
                                ? AppColors.primary
                                : Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Phone field ───────────────────────────────────────────────────────────────

class _PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onEditingComplete;

  const _PhoneField({super.key, required this.controller, this.onEditingComplete});

  @override
  Widget build(BuildContext context) {
    return AuthTextField(
      label: 'Numéro de téléphone',
      hint: '+243 XXX XXX XXX',
      controller: controller,
      keyboardType: TextInputType.phone,
      prefixIcon: Icons.phone_outlined,
      textInputAction: TextInputAction.done,
      onEditingComplete: onEditingComplete,
      validator: (v) {
        if (v == null || v.trim().isEmpty) {
          return 'Veuillez entrer votre numéro de téléphone';
        }
        final digits = v.replaceAll(RegExp(r'[^\d]'), '');
        if (digits.length < 8) {
          return 'Numéro de téléphone invalide';
        }
        return null;
      },
    );
  }
}

// ── Success view ──────────────────────────────────────────────────────────────

class _SuccessView extends StatefulWidget {
  final String identifier;
  final bool isPhone;
  final VoidCallback onBackToLogin;
  final VoidCallback onResend;

  const _SuccessView({
    super.key,
    required this.identifier,
    required this.isPhone,
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
                  child: Icon(
                    widget.isPhone
                        ? Icons.sms_outlined
                        : Icons.mark_email_read_outlined,
                    size: 44,
                    color: AppColors.success,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 36),
          Text(
            widget.isPhone ? 'SMS envoyé !' : 'E-mail envoyé !',
            style: AppTextStyles.headlineLarge,
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.65,
              ),
              children: [
                TextSpan(
                  text: widget.isPhone
                      ? 'Un code OTP a été envoyé au numéro '
                      : 'Un lien de réinitialisation a été envoyé à ',
                ),
                TextSpan(
                  text: widget.identifier,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextSpan(
                  text: widget.isPhone
                      ? '. Vérifiez vos SMS.'
                      : '. Vérifiez votre boîte de réception et vos spams.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          AuthGradientButton(
            label: 'Retour à la connexion',
            onPressed: widget.onBackToLogin,
          ),
          const SizedBox(height: 24),
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
                    TextSpan(
                      text: widget.isPhone
                          ? "Vous n'avez pas reçu le SMS ? "
                          : "Vous n'avez pas reçu l'e-mail ? ",
                    ),
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