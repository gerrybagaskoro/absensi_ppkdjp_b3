import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double width;
  final double height;

  const AppLogo({super.key, this.width = 80, this.height = 80});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/applogo_presensi_kita.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
    );
  }
}
