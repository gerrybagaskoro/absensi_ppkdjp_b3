// ignore_for_file: use_build_context_synchronously

import 'package:absensi_ppkdjp_b3/extension/navigation.dart';
import 'package:absensi_ppkdjp_b3/preference/shared_preference.dart';
import 'package:absensi_ppkdjp_b3/views/auth/login_presensi.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatelessWidget {
  static const String id = '/onboard_presensi';
  const OnboardingScreen({super.key});

  Future<void> _onIntroEnd(BuildContext context) async {
    await PreferenceHandler.saveOnboardingShown(true);
    context.pushReplacement(LoginPresensi());
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final bodyStyle = TextStyle(
      fontSize: 16,
      color: colorScheme.onSurfaceVariant,
    );

    final pageDecoration = PageDecoration(
      bodyTextStyle: bodyStyle,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: colorScheme.onSurface,
      ),
    );

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Selamat Datang",
          body:
              "Aplikasi presensi digital yang memudahkan absensi sehari-hari.",
          image: Icon(Icons.access_time, size: 150, color: colorScheme.primary),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Cepat & Mudah",
          body: "Login sekali, presensi bisa dilakukan lebih praktis.",
          image: Icon(Icons.touch_app, size: 150, color: colorScheme.primary),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Data Aman",
          body: "Semua presensi tersimpan dengan aman dan terintegrasi.",
          image: Icon(
            Icons.verified_user,
            size: 150,
            color: colorScheme.primary,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Mulai Sekarang",
          body: "Siap untuk presensi digital? Yuk kita mulai!",
          image: Icon(
            Icons.rocket_launch,
            size: 150,
            color: colorScheme.primary,
          ),
          decoration: pageDecoration,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      showSkipButton: true,
      skip: const Text("Lewati"),
      next: const Icon(Icons.arrow_forward),
      done: const Text("Mulai", style: TextStyle(fontWeight: FontWeight.bold)),
      dotsDecorator: DotsDecorator(
        size: const Size.square(8.0),
        activeSize: const Size(20.0, 8.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        activeColor: colorScheme.primary,
        color: colorScheme.outlineVariant,
      ),
    );
  }
}
