import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zyra_shop/features/auth/providers/auth_providers.dart';
import 'package:zyra_shop/features/home/presentation/home.dart';
import 'login_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeCtrl;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));

    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);

    _playSequence();
  }

  Future<void> _playSequence() async {
    _fadeCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 2500));
    if (!mounted) return;
    await _checkSessionAndNavigate();
  }

  Future<void> _checkSessionAndNavigate() async {
    final user = await ref.read(currentUserProvider.future);

    if (!mounted) return;

    if (user != null) {
      _navigateToHome();
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (ctx, animation, _) => const HomeNavigationWrapper(),
        transitionsBuilder: (ctx, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
          child: child,
        ),
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
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
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Image.asset(
            'assets/images/zyra_splash_logo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}