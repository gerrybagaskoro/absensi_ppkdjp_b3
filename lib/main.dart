import 'package:absensi_ppkdjp_b3/utils/app_theme.dart';
import 'package:absensi_ppkdjp_b3/utils/theme_provider.dart';
import 'package:absensi_ppkdjp_b3/views/auth/forgot_account_presensi.dart';
import 'package:absensi_ppkdjp_b3/views/auth/login_presensi.dart';
import 'package:absensi_ppkdjp_b3/views/auth/register_presensi.dart';
import 'package:absensi_ppkdjp_b3/views/onboard_screen.dart';
import 'package:absensi_ppkdjp_b3/views/presensi/dashboard_presensi.dart';
import 'package:absensi_ppkdjp_b3/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart'; // <--- tambahkan provider

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Absensi PPKD',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      supportedLocales: const [Locale('en', 'US'), Locale('id', 'ID')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        OnboardingScreen.id: (context) => const OnboardingScreen(),
        LoginPresensi.id: (context) => const LoginPresensi(),
        RegisterPresensi.id: (context) => const RegisterPresensi(),
        ForgotResetPasswordScreen.id: (context) =>
            const ForgotResetPasswordScreen(),
        DashboardPresensi.id: (context) => const DashboardPresensi(),
      },
    );
  }
}
