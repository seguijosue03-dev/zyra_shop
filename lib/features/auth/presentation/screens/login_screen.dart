import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'package:zyra_shop/features/auth/providers/auth_providers.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'package:zyra_shop/features/home/presentation/home.dart';
import 'package:zyra_shop/features/admin/presentation/screens/admin_dashboard_wrapper.dart';

// ── Login mode ─────────────────────────────────────────────────────────────────
enum _LoginMode { email, phone }

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _emailFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _passwordFocus = FocusNode();

  _LoginMode _mode = _LoginMode.email;
  late final AnimationController _tabAnim;
  late final Animation<double> _indicatorSlide;

  @override
  void initState() {
    super.initState();
    _tabAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );
    _indicatorSlide = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _tabAnim, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passwordCtrl.dispose();
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _passwordFocus.dispose();
    _tabAnim.dispose();
    super.dispose();
  }

  void _switchMode(_LoginMode mode) {
    if (_mode == mode) return;
    setState(() => _mode = mode);
    if (mode == _LoginMode.phone) {
      _tabAnim.forward();
    } else {
      _tabAnim.reverse();
    }
    _formKey.currentState?.reset();
  }

  Future<void> _onSignIn() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    if (_mode == _LoginMode.email) {
      await ref.read(authNotifierProvider.notifier).login(
            email: _emailCtrl.text.trim(),
            password: _passwordCtrl.text.trim(),
          );
    } else {
      // Format the phone number: prepend + if missing
      String phone = _phoneCtrl.text.trim();
      if (!phone.startsWith('+')) phone = '+$phone';
      await ref.read(authNotifierProvider.notifier).loginWithPhone(
            phone: phone,
            password: _passwordCtrl.text.trim(),
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

    if (authState.user?.role == 'admin') {
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
        pageBuilder: (_, _, _) => const RegisterScreen(),
        transitionsBuilder: (_, a, _, c) =>
            FadeTransition(opacity: a, child: c),
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
    bool isPhone = false,
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
              keyboardType: isPhone
                  ? TextInputType.phone
                  : isPassword
                      ? TextInputType.text
                      : TextInputType.emailAddress,
              inputFormatters: isPhone
                  ? [FilteringTextInputFormatter.allow(RegExp(r'[+\d]'))]
                  : null,
              textInputAction: nextFocus != null
                  ? TextInputAction.next
                  : TextInputAction.done,
              onEditingComplete: () {
                if (nextFocus != null) {
                  nextFocus.requestFocus();
                } else {
                  _onSignIn();
                }
              },
              validator: (v) {
                if (v == null || v.trim().isEmpty) return '';
                if (isPhone) {
                  final digits = v.replaceAll(RegExp(r'[^\d]'), '');
                  if (digits.length < 8) return '';
                }
                return null;
              },
              style: GoogleFonts.inter(
                  fontSize: 15,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle:
                    GoogleFonts.inter(color: Colors.black38, fontSize: 15),
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

  // ── Mode toggle tab bar ────────────────────────────────────────────────────
  Widget _buildToggle(double screenWidth) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24, left: 0),
      child: AnimatedBuilder(
        animation: _indicatorSlide,
        builder: (context, _) {
          return Container(
            width: screenWidth * 0.82,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F0F0),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Stack(
              children: [
                // Sliding indicator
                AnimatedAlign(
                  duration: const Duration(milliseconds: 240),
                  curve: Curves.easeInOut,
                  alignment: _mode == _LoginMode.email
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
                        onTap: () => _switchMode(_LoginMode.email),
                        behavior: HitTestBehavior.opaque,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.email_outlined,
                                size: 16,
                                color: _mode == _LoginMode.email
                                    ? AppColors.primary
                                    : Colors.black45,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'E-mail',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: _mode == _LoginMode.email
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
                        onTap: () => _switchMode(_LoginMode.phone),
                        behavior: HitTestBehavior.opaque,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.phone_outlined,
                                size: 16,
                                color: _mode == _LoginMode.phone
                                    ? AppColors.primary
                                    : Colors.black45,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Téléphone',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: _mode == _LoginMode.phone
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
        },
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
                  color: AppColors.secondary.withValues(alpha: 0.9),
                ),
              ),
            ),

            // ── Main Content ──
            SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 120),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const SizedBox(height: 36),

                    // ── Toggle Email / Phone ──
                    _buildToggle(screenWidth),

                    // ── Fields card ──
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
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 280),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeIn,
                              transitionBuilder: (child, anim) =>
                                  FadeTransition(opacity: anim, child: child),
                              child: Column(
                                key: ValueKey(_mode),
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (_mode == _LoginMode.email)
                                    _buildTextField(
                                      controller: _emailCtrl,
                                      icon: Icons.person_outline,
                                      hint: 'Adresse e-mail',
                                      focusNode: _emailFocus,
                                      nextFocus: _passwordFocus,
                                    )
                                  else
                                    _buildTextField(
                                      controller: _phoneCtrl,
                                      icon: Icons.phone_outlined,
                                      hint: '+243 XXX XXX XXX',
                                      isPhone: true,
                                      focusNode: _phoneFocus,
                                      nextFocus: _passwordFocus,
                                    ),
                                  const Divider(
                                      height: 1,
                                      color: Color(0xFFF0F0F0),
                                      indent: 24,
                                      endIndent: 24),
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
                                    const SnackBar(
                                        content: Text(
                                            'Veuillez remplir tous les champs')),
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
                                child: isLoading
                                    ? const Center(
                                        child: SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2),
                                        ),
                                      )
                                    : const Icon(Icons.arrow_forward,
                                        color: Colors.white, size: 24),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

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
                            color: Colors.black45,
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

            // ── Register Pill ──
            Positioned(
              bottom: 40,
              left: 0,
              child: GestureDetector(
                onTap: _goToRegister,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
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
                      color: AppColors.error,
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