import 'package:absensi_ppkdjp_b3/api/profile_service.dart';
import 'package:absensi_ppkdjp_b3/extension/navigation.dart';
import 'package:absensi_ppkdjp_b3/model/auth/get_profile_model.dart';
import 'package:absensi_ppkdjp_b3/preference/shared_preference.dart';
import 'package:absensi_ppkdjp_b3/views/auth/login_presensi.dart';
import 'package:absensi_ppkdjp_b3/views/profile/about_app.dart';
import 'package:absensi_ppkdjp_b3/views/profile/edit_profile_presensi.dart';
import 'package:absensi_ppkdjp_b3/views/profile/settings_presensi.dart';
import 'package:absensi_ppkdjp_b3/widgets/profile/avatar_hero.dart';
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
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Konfirmasi"),
        content: const Text("Apakah Anda yakin ingin keluar dari aplikasi?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: theme.colorScheme.onError,
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
      SnackBar(
        content: const Text("Anda telah keluar."),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );

    context.pushReplacement(LoginPresensi());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProfile,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),

                      // 🔹 Avatar with gradient ring
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              scheme.primary.withOpacity(0.6),
                              scheme.primaryContainer.withOpacity(0.6),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(4),
                        child: AvatarHero(
                          tag: "profile-avatar",
                          radius: 90,
                          imageUrl: _profile?.profilePhotoUrl != null
                              ? "${_profile!.profilePhotoUrl!}?v=${DateTime.now().millisecondsSinceEpoch}"
                              : _profile?.profilePhoto != null
                              ? "https://appabsensi.mobileprojp.com/storage/${_profile!.profilePhoto}?v=${DateTime.now().millisecondsSinceEpoch}"
                              : null,
                          showBorder: false,
                          isUploading: false,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔹 Name & Email
                      Text(
                        _profile?.name ?? "Tidak ada nama",
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: scheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _profile?.email ?? "Tidak ada email",
                        style: textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // 🔹 Info Batch & Training with gradient
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [
                              scheme.secondaryContainer.withOpacity(0.8),
                              scheme.secondaryContainer.withOpacity(0.5),
                            ],
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_profile?.batchKe != null)
                              Text(
                                "Batch ke-${_profile!.batchKe}",
                                style: textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w500,
                                  color: scheme.onSecondaryContainer,
                                ),
                              ),
                            if (_profile?.trainingTitle != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  "Pelatihan: ${_profile!.trainingTitle}",
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: scheme.onSecondaryContainer,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // 🔹 Menu List
                      ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.zero,
                        children: [
                          _buildMenuCard(
                            icon: Icons.edit,
                            text: "Sunting Profil",
                            onTap: () async {
                              final updated = await context.push(
                                const EditProfilePage(),
                              );
                              if (updated == true) _loadProfile();
                            },
                          ),
                          _buildMenuCard(
                            icon: Icons.settings,
                            text: "Pengaturan",
                            onTap: () => context.push(const SettingsPresensi()),
                          ),
                          _buildMenuCard(
                            icon: Icons.info,
                            text: "Tentang Aplikasi",
                            onTap: () => context.push(const AboutApp()),
                          ),
                          _buildMenuCard(
                            icon: Icons.logout,
                            text: "Keluar",
                            color: scheme.error,
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

  Widget _buildMenuCard({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
    Color? color,
  }) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          child: Row(
            children: [
              Icon(icon, color: color ?? scheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    color: color ?? scheme.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: scheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
