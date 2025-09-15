// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:absensi_ppkdjp_b3/utils/app_logo.dart';
import 'package:flutter/material.dart';

import 'dashboard_peserta.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Simulasi delay splash 3 detik
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const DashboardPeserta()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[700],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppLogo(height: 300, width: 300),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          "© 2025 Presensi Kita",
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
