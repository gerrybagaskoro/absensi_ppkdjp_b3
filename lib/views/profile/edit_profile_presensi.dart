import 'dart:convert';
import 'dart:io';

import 'package:absensi_ppkdjp_b3/api/endpoint.dart';
import 'package:absensi_ppkdjp_b3/api/profile_service.dart';
import 'package:absensi_ppkdjp_b3/preference/shared_preference.dart';
import 'package:absensi_ppkdjp_b3/widgets/profile/avatar_hero.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  bool _isLoading = false;
  bool _isUploading = false;

  String? _currentPhotoUrl;
  String? _email;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);

    final profile = await ProfileService.fetchProfile();
    if (profile?.data != null) {
      _nameController.text = profile!.data!.name ?? '';
      _email = profile.data!.email ?? '';
      _currentPhotoUrl =
          profile.data!.profilePhotoUrl ??
          (profile.data!.profilePhoto != null
              ? "https://appabsensi.mobileprojp.com/storage/${profile.data!.profilePhoto}"
              : null);
    }

    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (picked == null) return;

    setState(() => _isUploading = true);

    try {
      final token = await PreferenceHandler.getToken();
      if (token == null) throw Exception("Token tidak ditemukan");

      final file = File(picked.path);
      final bytes = await file.readAsBytes();
      final mimeType = _lookupMimeType(file.path) ?? 'image/png';
      final base64Data = base64Encode(bytes);
      final dataUri = 'data:$mimeType;base64,$base64Data';

      final response = await http.put(
        Uri.parse(Endpoint.editFoto),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"profile_photo": dataUri}),
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        final updated = res['data'];

        if (updated != null) {
          String? newPhotoUrl;
          if (updated['profile_photo'] != null) {
            final val = updated['profile_photo'];
            if (val is String && val.startsWith('http')) {
              newPhotoUrl = val;
            } else {
              newPhotoUrl = "https://appabsensi.mobileprojp.com/storage/$val";
            }
          }

          if (newPhotoUrl != null) {
            setState(() => _currentPhotoUrl = newPhotoUrl);

            // update local cache
            final userJson = await PreferenceHandler.getUserData();
            Map<String, dynamic> currentData = {};
            if (userJson != null) {
              try {
                currentData = jsonDecode(userJson);
              } catch (_) {}
            }
            currentData['profile_photo_url'] = newPhotoUrl;
            await PreferenceHandler.saveUserData(jsonEncode(currentData));
          }
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Foto profil berhasil diperbarui"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      } else {
        throw Exception("Gagal upload foto: ${response.body}");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error upload foto: $e"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<void> _submitName() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final newName = _nameController.text.trim();

    try {
      final token = await PreferenceHandler.getToken();
      if (token == null) throw Exception("Token tidak ditemukan");

      final response = await http.put(
        Uri.parse(Endpoint.profile),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"name": newName}),
      );

      if (response.statusCode == 200) {
        final res = jsonDecode(response.body);
        final updated = res['data'];

        if (updated != null) {
          await PreferenceHandler.saveUserData(jsonEncode(updated));
        }

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Nama berhasil diperbarui"),
            behavior: SnackBarBehavior.floating,
          ),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception("Gagal update nama: ${response.body}");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error update nama: $e"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String? _lookupMimeType(String path) {
    final ext = path.split('.').last.toLowerCase();
    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'webp':
        return 'image/webp';
      default:
        return null;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text("Sunting Profil"), centerTitle: true),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Avatar dengan tombol edit
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: scheme.surfaceContainerHighest,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: AvatarHero(
                              tag: "profile-avatar",
                              radius: 56,
                              imageUrl: _currentPhotoUrl != null
                                  ? "${_currentPhotoUrl!}?v=${DateTime.now().millisecondsSinceEpoch}"
                                  : null,
                              showBorder: false,
                              isUploading: _isUploading,
                              onEdit: null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickAndUploadImage,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: scheme.primary,
                                  border: Border.all(
                                    color: scheme.onPrimary,
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.all(8),
                                child: Icon(
                                  Icons.edit,
                                  size: 24,
                                  color: scheme.onPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Input nama
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: "Nama Lengkap",
                        prefixIcon: const Icon(Icons.person),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? "Nama tidak boleh kosong"
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Tombol simpan nama
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: _submitName,
                        child: const Text("Simpan Nama"),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
