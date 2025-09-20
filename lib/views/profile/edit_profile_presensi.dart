// lib/views/profile/edit_profile_presensi.dart
import 'dart:convert';
import 'dart:io';

import 'package:absensi_ppkdjp_b3/api/endpoint.dart';
import 'package:absensi_ppkdjp_b3/api/profile_service.dart';
import 'package:absensi_ppkdjp_b3/preference/shared_preference.dart';
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
  final bool _isUploading = false;

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

    setState(() => _isLoading = true);

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
            backgroundColor: Colors.green,
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
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
            backgroundColor: Colors.green,
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
            backgroundColor: Colors.red,
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange[700],
        centerTitle: true,
      ),
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
                        alignment: Alignment.center,
                        children: [
                          // Avatar
                          CircleAvatar(
                            radius: 56,
                            backgroundImage: _currentPhotoUrl != null
                                ? NetworkImage(_currentPhotoUrl!)
                                : null,
                            backgroundColor: Colors.grey[300],
                            child: _currentPhotoUrl == null
                                ? const Icon(
                                    Icons.person,
                                    size: 48,
                                    color: Colors.white70,
                                  )
                                : null,
                          ),

                          // Loading spinner (muncul saat upload)
                          if (_isUploading)
                            const Positioned.fill(
                              child: Align(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.orange,
                                  ),
                                ),
                              ),
                            ),

                          // Tombol edit
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: _pickAndUploadImage,
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.orange[700],
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 18,
                                  color: Colors.white,
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
                        prefixIcon: const Icon(
                          Icons.person,
                          color: Colors.orange,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? "Nama tidak boleh kosong"
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Email readonly
                    TextFormField(
                      initialValue: _email ?? '',
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Surel",
                        prefixIcon: const Icon(Icons.email, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tombol simpan nama
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[700],
                        ),
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
