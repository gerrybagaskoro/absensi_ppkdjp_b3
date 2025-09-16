import 'package:absensi_ppkdjp_b3/extension/navigation.dart';
import 'package:absensi_ppkdjp_b3/preference/shared_preference.dart';
import 'package:absensi_ppkdjp_b3/views/auth/login_presensi.dart';
import 'package:absensi_ppkdjp_b3/views/profile/about_app.dart';
import 'package:absensi_ppkdjp_b3/views/profile/edit_profile_presensi.dart';
import 'package:absensi_ppkdjp_b3/views/profile/settings_presensi.dart';
import 'package:flutter/material.dart';

class ProfilePresensi extends StatefulWidget {
  const ProfilePresensi({super.key});

  @override
  State<ProfilePresensi> createState() => _ProfilePresensiState();
}

class _ProfilePresensiState extends State<ProfilePresensi> {
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text("Konfirmasi"),
          content: const Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // ✅ tutup dialog
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {
                Navigator.pop(context); // ✅ tutup dialog dulu
                await _logout(); // ✅ proses logout
              },
              child: const Text("Ya, Keluar"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _logout() async {
    // Hapus semua data kecuali onboarding
    await PreferenceHandler.clearAll();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Anda telah keluar."),
        backgroundColor: Colors.red,
      ),
    );

    // Arahkan ke login dan hapus semua halaman sebelumnya
    context.pushReplacement(LoginPresensi());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 24),
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/images/kano-pfp.jpg"),
            ),
            const SizedBox(height: 24),
            const Text(
              "Gerry Bagaskoro Putro",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "gerry@example.com",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildMenuItem(
                    icon: Icons.edit,
                    text: "Edit Profil",
                    onTap: () => context.push(EditProfilePage()),
                  ),
                  _buildMenuItem(
                    icon: Icons.settings,
                    text: "Pengaturan",
                    onTap: () => context.push(SettingsPresensi()),
                  ),
                  _buildMenuItem(
                    icon: Icons.android,
                    text: "Tentang Aplikasi",
                    onTap: () => context.push(AboutApp()),
                  ),
                  _buildMenuItem(
                    icon: Icons.logout,
                    text: "Keluar",
                    color: Colors.red,
                    onTap: _showLogoutDialog,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color color = Colors.orange,
  }) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: color),
          title: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: color == Colors.red ? Colors.red : Colors.black87,
            ),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: onTap,
        ),
      ],
    );
  }
}
