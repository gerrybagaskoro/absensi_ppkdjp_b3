import 'package:absensi_ppkdjp_b3/views/auth/login_peserta.dart';
import 'package:absensi_ppkdjp_b3/views/auth/register_peserta.dart';
import 'package:absensi_ppkdjp_b3/views/dashboard_peserta.dart';
import 'package:absensi_ppkdjp_b3/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absensi PPKD',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      initialRoute: '/splash',
      routes: {
        '/login': (context) => const LoginPeserta(),
        '/splash': (context) => const SplashScreen(),
        '/register': (context) => const RegisterPeserta(),
        '/dashboard': (context) => const DashboardPeserta(),
      },
    );
  }
}
