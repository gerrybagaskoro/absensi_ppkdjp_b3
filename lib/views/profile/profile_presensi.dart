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
                      border: Border.all(color: Colors.orange, width: 5),
                    ),
                    child: CircleAvatar(
                      radius: 92,
                      backgroundImage: _profile?.profilePhotoUrl != null
                          ? NetworkImage(
                              _profile!.profilePhotoUrl!,
                            ) // 🔥 langsung pakai URL dari API
                          : _profile?.profilePhoto != null
                          ? NetworkImage(
                              "https://appabsensi.mobileprojp.com/storage/${_profile!.profilePhoto}",
                            )
                          : null,
                      backgroundColor: Colors.grey[300],
                      child:
                          (_profile?.profilePhotoUrl == null &&
                              _profile?.profilePhoto == null)
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
                    style: TextStyle(fontSize: 20, color: Colors.black87),
                  ),
                  Text(
                    _profile?.email ?? "Tidak ada email",
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const SizedBox(height: 16),

                  // 🔹 Tambahan info dalam container rapi
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_profile?.batchKe != null)
                          Text(
                            "Batch ke-${_profile!.batchKe}",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        if (_profile?.trainingTitle != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              "Pelatihan: ${_profile!.trainingTitle}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        if (_profile?.batch?.createdAt != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              "Dibuat pada: ${_profile!.batch!.createdAt!.toLocal().toString().substring(0, 19)}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        if (_profile?.batch?.updatedAt != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              "Diperbarui pada: ${_profile!.batch!.updatedAt!.toLocal().toString().substring(0, 19)}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                      ],
                    ),
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
