import 'package:absensi_ppkdjp_b3/utils/app_logo.dart';
import 'package:flutter/material.dart';

class AboutApp extends StatelessWidget {
  const AboutApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tentang Aplikasi",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange[700],
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            AppLogo(height: 240, width: 240),
            const SizedBox(height: 20),

            // Nama aplikasi
            const Text(
              "Presensi Kita",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 8),

            // Versi
            const Text("Versi 1.0.0", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 30),
            // Deskripsi
            const Text(
              "Aplikasi Presensi ini dibuat untuk mempermudah proses absensi "
              "dan pencatatan kehadiran.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, height: 1.5),
            ),
            const Spacer(),
            const Text(
              "© 2025 - Gerry Bagaskoro Putro",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
