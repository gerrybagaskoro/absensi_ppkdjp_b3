import 'package:absensi_ppkdjp_b3/extension/navigation.dart';
import 'package:absensi_ppkdjp_b3/views/auth/login_peserta.dart';
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
              onPressed: () {
                context.pop; // Tutup dialog
              },
              child: const Text("Batal"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                context.pushNamedAndRemoveAll('/login'); // Tutup dialog
                _logout();
              },
              child: const Text("Ya, Keluar"),
            ),
          ],
        );
      },
    );
  }

  void _logout() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Anda telah keluar."),
        backgroundColor: Colors.red,
      ),
    );

    // contoh: arahkan kembali ke halaman login
    context.pushReplacement(LoginPeserta());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Profil", style: TextStyle(color: Colors.white)),
      //   backgroundColor: Colors.orange,
      //   elevation: 0,
      //   centerTitle: true,
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 24),

            // Avatar pakai image lokal
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage("assets/images/kano-pfp.jpg"),
            ),
            const SizedBox(height: 24),

            // Nama
            const Text(
              "Gerry Bagaskoro Putro",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 4),

            // Email
            Text(
              "gerry@example.com",
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),

            // Menu profil
            Expanded(
              child: ListView(
                children: [
                  _buildMenuItem(
                    icon: Icons.edit,
                    text: "Edit Profil",
                    onTap: () {
                      context.push(EditProfilePage());
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.settings,
                    text: "Pengaturan",
                    onTap: () {
                      context.push(SettingsPresensi());
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.android,
                    text: "Tentang Aplikasi",
                    onTap: () {
                      context.push(AboutApp());
                    },
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
        // const Divider(height: 1),
      ],
    );
  }
}
