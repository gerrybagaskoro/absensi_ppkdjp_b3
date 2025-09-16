import 'package:absensi_ppkdjp_b3/views/auth/login_presensi.dart';
import 'package:absensi_ppkdjp_b3/views/auth/register_presensi.dart';
import 'package:absensi_ppkdjp_b3/views/presensi/dashboard_presensi.dart';
import 'package:absensi_ppkdjp_b3/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Absensi PPKD',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('id', 'ID'), // tambah locale Indonesia
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // initialRoute: '/splash',
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginPresensi(),
        '/splash': (context) => const SplashScreen(),
        '/register': (context) => const RegisterPresensi(),
        '/dashboard': (context) => const DashboardPresensi(),
      },
    );
  }
}
