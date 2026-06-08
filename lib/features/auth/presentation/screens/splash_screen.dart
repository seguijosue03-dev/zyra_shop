import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zyra_shop/core/theme/app_colors.dart';
import 'login_screen.dart';

/// ZYRA Splash Screen
///
/// Premium three-phase logo reveal animation:
///   Phase 1 — Logo scales in + fades (easeOutBack spring feel)
///   Phase 2 — "ZYRA" wordmark slides up + fades
///   Phase 3 — Tagline fades in + thin progress bar fills
///   Navigate — Smooth fade transition to [LoginScreen]
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Controllers
  late final AnimationController _logoCtrl;
  late final AnimationController _textCtrl;
  late final AnimationController _taglineCtrl;
  late final AnimationController _barCtrl;

  // Animations
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _textFade;
  late final Animation<Offset> _textSlide;
  late final Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));

    // ── Init controllers ─────────────────────────
    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 880),
    );
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 620),
    );
    _taglineCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _barCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    // ── Init animations ──────────────────────────
    _logoScale = Tween<double>(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOutBack),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoCtrl,
        curve: const Interval(0.0, 0.60, curve: Curves.easeOut),
      ),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.45),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));
    _taglineFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _taglineCtrl, curve: Curves.easeOut),
    );

    _playSequence();
  }

  Future<void> _playSequence() async {
    // Phase 1: logo
    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    _logoCtrl.forward();

    // Phase 2: wordmark
    await Future.delayed(const Duration(milliseconds: 520));
    if (!mounted) return;
    _textCtrl.forward();

    // Phase 3: tagline + bar
    await Future.delayed(const Duration(milliseconds: 320));
    if (!mounted) return;
    _taglineCtrl.forward();
    _barCtrl.forward();

    // Hold then navigate
    await Future.delayed(const Duration(milliseconds: 2100));
    if (!mounted) return;
    _navigateToLogin();
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 750),
        pageBuilder: (ctx, animation, _) => const LoginScreen(),
        transitionsBuilder: (ctx, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _taglineCtrl.dispose();
    _barCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Main content (centered vertically) ──
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  ScaleTransition(
                    scale: _logoScale,
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 148,
                        fit: BoxFit.contain,
                        errorBuilder: (_, _, _) =>
                            const _FallbackLogo(size: 148),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  // ZYRA wordmark
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textFade,
                      child: Text(
                        'ZYRA',
                        style: GoogleFonts.inter(
                          fontSize: 46,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                          letterSpacing: 10,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Tagline
                  FadeTransition(
                    opacity: _taglineFade,
                    child: Text(
                      'SHOP. STYLE. YOU.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                        letterSpacing: 4.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom progress bar ──────────────────
          FadeTransition(
            opacity: _taglineFade,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 64),
              child: AnimatedBuilder(
                animation: _barCtrl,
                builder: (context, child) => SizedBox(
                  width: 52,
                  height: 3,
                  child: LinearProgressIndicator(
                    value: _barCtrl.value,
                    backgroundColor: AppColors.border,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shown when `assets/images/logo.png` is not found.
class _FallbackLogo extends StatelessWidget {
  final double size;
  const _FallbackLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradientDiagonal,
        borderRadius: BorderRadius.circular(size * 0.22),
      ),
      child: Center(
        child: Text(
          'Z',
          style: TextStyle(
            fontSize: size * 0.55,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1,
          ),
        ),
      ),
    );
  }
}
