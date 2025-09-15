import 'package:absensi_ppkdjp_b3/views/auth/login_peserta.dart';
import 'package:absensi_ppkdjp_b3/views/auth/register_peserta.dart';
import 'package:absensi_ppkdjp_b3/views/dashboard_peserta.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Absensi PPKD',
      theme: ThemeData(primarySwatch: Colors.orange),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginPeserta(),
        '/register': (context) => const RegisterPeserta(),
        '/dashboard': (context) => const DashboardPeserta(),
      },
    );
  }
}
