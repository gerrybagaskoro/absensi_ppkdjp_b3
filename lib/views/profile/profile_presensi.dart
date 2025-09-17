import 'package:absensi_ppkdjp_b3/api/profile_service.dart';
import 'package:absensi_ppkdjp_b3/extension/navigation.dart';
import 'package:absensi_ppkdjp_b3/model/auth/get_profile_model.dart';
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
  Data? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final profile = await ProfileService.fetchProfile();
    if (!mounted) return;
    setState(() {
      _profile = profile?.data;
      _isLoading = false;
    });
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text("Konfirmasi"),
        content: const Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () async {
              Navigator.pop(context);
              await _logout();
            },
            child: const Text("Ya, Keluar"),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    await PreferenceHandler.clearAll();
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Anda telah keluar."),
        backgroundColor: Colors.red,
      ),
    );

    context.pushReplacement(LoginPresensi());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.orange, width: 4),
                    ),
                    child: CircleAvatar(
                      radius: 52,
                      backgroundImage: _profile?.profilePhoto != null
                          ? NetworkImage(
                              "https://appabsensi.mobileprojp.com/storage/${_profile!.profilePhoto}",
                            )
                          : null,
                      backgroundColor: Colors.grey[300],
                      child: _profile?.profilePhoto == null
                          ? const Icon(
                              Icons.person,
                              size: 50,
                              color: Colors.white,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _profile?.name ?? "Tidak ada nama",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _profile?.email ?? "Tidak ada email",
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
                          icon: Icons.info,
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
    return ListTile(
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
    );
  }
}
