// ignore_for_file: use_build_context_synchronously

import 'package:absensi_ppkdjp_b3/extension/navigation.dart';
import 'package:absensi_ppkdjp_b3/preference/shared_preference.dart';
import 'package:absensi_ppkdjp_b3/views/auth/login_presensi.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  Future<void> _onIntroEnd(BuildContext context) async {
    // Simpan status onboarding sudah pernah ditampilkan
    await PreferenceHandler.saveOnboardingShown(true);

    // Lanjut ke halaman login
    context.pushReplacement(LoginPresensi());
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 16, color: Colors.black87);
    const pageDecoration = PageDecoration(
      bodyTextStyle: bodyStyle,
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );

    return IntroductionScreen(
      pages: [
        PageViewModel(
          title: "Selamat Datang",
          body:
              "Aplikasi presensi digital yang memudahkan absensi sehari-hari.",
          image: const Icon(Icons.access_time, size: 150, color: Colors.orange),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Cepat & Mudah",
          body: "Login sekali, presensi bisa dilakukan lebih praktis.",
          image: const Icon(Icons.touch_app, size: 150, color: Colors.orange),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Data Aman",
          body: "Semua presensi tersimpan dengan aman dan terintegrasi.",
          image: const Icon(
            Icons.verified_user,
            size: 150,
            color: Colors.orange,
          ),
          decoration: pageDecoration,
        ),
        PageViewModel(
          title: "Mulai Sekarang",
          body: "Siap untuk presensi digital? Yuk kita mulai!",
          image: const Icon(
            Icons.rocket_launch,
            size: 150,
            color: Colors.orange,
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
        activeColor: Colors.orange[700]!,
      ),
    );
  }
}
