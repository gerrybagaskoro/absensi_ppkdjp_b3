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
          : RefreshIndicator(
              onRefresh: _loadProfile, // ✅ tarik ke bawah untuk refresh profil
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),

                      // 🔹 Avatar
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.orange, width: 5),
                        ),
                        child: CircleAvatar(
                          radius: 92,
                          backgroundImage: _profile?.profilePhotoUrl != null
                              ? NetworkImage(
                                  "${_profile!.profilePhotoUrl!}?v=${DateTime.now().millisecondsSinceEpoch}",
                                )
                              : _profile?.profilePhoto != null
                              ? NetworkImage(
                                  "https://appabsensi.mobileprojp.com/storage/${_profile!.profilePhoto}"
                                  "?v=${DateTime.now().millisecondsSinceEpoch}",
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

                      // 🔹 Nama & email
                      Text(
                        _profile?.name ?? "Tidak ada nama",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Text(
                        _profile?.email ?? "Tidak ada email",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // 🔹 Info batch & training
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

                      // 🔹 Menu list
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        children: [
                          _buildMenuCard(
                            icon: Icons.edit,
                            text: "Edit Profil",
                            onTap: () async {
                              final updated = await context.push(
                                const EditProfilePage(),
                              );
                              if (updated == true) {
                                _loadProfile();
                              }
                            },
                          ),
                          _buildMenuCard(
                            icon: Icons.settings,
                            text: "Pengaturan",
                            onTap: () => context.push(SettingsPresensi()),
                          ),
                          _buildMenuCard(
                            icon: Icons.info,
                            text: "Tentang Aplikasi",
                            onTap: () => context.push(AboutApp()),
                          ),
                          _buildMenuCard(
                            icon: Icons.logout,
                            text: "Keluar",
                            color: Colors.red,
                            onTap: _showLogoutDialog,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // 🔹 Helper untuk menu card
  Widget _buildMenuCard({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color color = Colors.orange,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 0,
      ), // ⬅️ full width
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: color == Colors.red ? Colors.red : Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
