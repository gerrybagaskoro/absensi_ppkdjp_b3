// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'dart:async';

import 'package:absensi_ppkdjp_b3/extension/navigation.dart';
import 'package:absensi_ppkdjp_b3/preference/shared_preference.dart';
import 'package:absensi_ppkdjp_b3/utils/app_logo.dart';
import 'package:absensi_ppkdjp_b3/views/auth/login_presensi.dart';
import 'package:absensi_ppkdjp_b3/views/onboard_screen.dart';
import 'package:absensi_ppkdjp_b3/views/presensi/dashboard_presensi.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const String id = '/splash_presensi';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    _startSplash();
  }

  Future<void> _startSplash() async {
    await Future.delayed(const Duration(seconds: 5));

    bool onboardingShown = false;
    bool isLoggedIn = false;
    String? token;

    try {
      onboardingShown = await PreferenceHandler.getOnboardingShown().timeout(
        const Duration(seconds: 2),
      );
      isLoggedIn =
          await PreferenceHandler.getLogin().timeout(
            const Duration(seconds: 2),
          ) ??
          false;
      token = await PreferenceHandler.getToken().timeout(
        const Duration(seconds: 2),
      );
    } catch (e) {
      print("Error membaca SharedPreferences: $e");
      onboardingShown = false;
      isLoggedIn = false;
      token = null;
    }

    if (!mounted) return;

    if (isLoggedIn && token != null && token.isNotEmpty) {
      context.pushNamedAndRemoveAll(DashboardPresensi.id);
      return;
    }

    if (!onboardingShown) {
      context.pushReplacement(const OnboardingScreen());
      return;
    }

    context.pushReplacement(const LoginPresensi());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[700],
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const AppLogo(height: 300, width: 300),
              const SizedBox(height: 24),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "© 2025 Gerry Bagaskoro Putro",
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
