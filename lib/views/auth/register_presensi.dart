// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:absensi_ppkdjp_b3/api/endpoint.dart';
import 'package:absensi_ppkdjp_b3/views/auth/login_presensi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class RegisterPresensi extends StatefulWidget {
  static const String id = '/register_presensi';
  const RegisterPresensi({super.key});

  @override
  State<RegisterPresensi> createState() => _RegisterPresensiState();
}

class _RegisterPresensiState extends State<RegisterPresensi> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  File? _avatarFile;

  // Dropdown data
  List<dynamic> _trainings = [];
  List<dynamic> _batches = [];
  int? _selectedTrainingId;
  int? _selectedBatchId;

  // Gender dropdown
  String? _gender; // "L" atau "P"

  @override
  void initState() {
    super.initState();
    _fetchTrainings();
    _fetchBatches();
  }

  Future<void> _fetchTrainings() async {
    try {
      final res = await http.get(Uri.parse(Endpoint.training));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() => _trainings = data["data"] ?? []);
      }
    } catch (e) {
      print("Error training: $e");
    }
  }

  Future<void> _fetchBatches() async {
    try {
      final res = await http.get(Uri.parse(Endpoint.batch));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        setState(() => _batches = data["data"] ?? []);
      }
    } catch (e) {
      print("Error batch: $e");
    }
  }

  // Pick image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _avatarFile = File(pickedFile.path));
    }
  }

  // Convert image ke base64
  Future<String?> _imageToBase64(File? file) async {
    if (file == null) return null;
    final bytes = await file.readAsBytes();
    return "data:image/png;base64,${base64Encode(bytes)}";
  }

  // Register action
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password dan konfirmasi tidak sama'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (_selectedTrainingId == null || _selectedBatchId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pilih Training dan Batch terlebih dahulu'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (_gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Pilih jenis kelamin terlebih dahulu'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final base64Image = await _imageToBase64(_avatarFile);

      final body = {
        "name": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "jenis_kelamin": _gender, // ✅ L / P
        "profile_photo": base64Image ?? "",
        "batch_id": _selectedBatchId,
        "training_id": _selectedTrainingId,
      };

      final response = await http.post(
        Uri.parse(Endpoint.register),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"] ?? "Registrasi berhasil!"),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        Navigator.pop(context); // kembali ke login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"] ?? "Registrasi gagal"),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    final scheme = Theme.of(context).colorScheme;
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: scheme.primary),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      'Daftar Presensi Kita',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: scheme.primary,
                          ),
                    ),
                    const SizedBox(height: 24),

                    // Avatar
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundColor: scheme.surfaceContainerHighest,
                          backgroundImage: _avatarFile != null
                              ? FileImage(_avatarFile!)
                              : null,
                          child: _avatarFile == null
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: scheme.onSurfaceVariant,
                                )
                              : null,
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _pickImage,
                            child: Container(
                              decoration: BoxDecoration(
                                color: scheme.primary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: scheme.onPrimary,
                                  width: 2,
                                ),
                              ),
                              padding: const EdgeInsets.all(6),
                              child: Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: scheme.onPrimary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    // Nama
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputStyle('Nama Lengkap', Icons.person),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Nama wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: _inputStyle('Surel', Icons.email),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Surel wajib diisi';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Format surel tidak valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Gender dropdown
                    DropdownButtonFormField<String>(
                      value: _gender,
                      items: const [
                        DropdownMenuItem(value: "L", child: Text("Laki-laki")),
                        DropdownMenuItem(value: "P", child: Text("Perempuan")),
                      ],
                      onChanged: (val) => setState(() => _gender = val),
                      decoration: _inputStyle(
                        "Jenis Kelamin",
                        Icons.person_outline,
                      ),
                      validator: (value) =>
                          value == null ? "Jenis kelamin wajib dipilih" : null,
                    ),
                    const SizedBox(height: 16),

                    // Dropdown Training (fix overflow)
                    DropdownButtonFormField<int>(
                      value: _selectedTrainingId,
                      items: _trainings.map<DropdownMenuItem<int>>((item) {
                        return DropdownMenuItem<int>(
                          value: item["id"],
                          child: SizedBox(
                            // ✅ kasih SizedBox biar Text bebas lebar
                            width: 200, // bisa disesuaikan sesuai layout
                            child: Text(
                              item["title"] ?? "Training",
                              softWrap: true,
                              overflow: TextOverflow.visible,
                              maxLines: 1, // ✅ bisa lebih kalau judul panjang
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _selectedTrainingId = val),
                      decoration: _inputStyle("Pilih Training", Icons.school),
                      validator: (value) =>
                          value == null ? "Training wajib dipilih" : null,
                    ),
                    const SizedBox(height: 16),

                    // Dropdown Batch
                    DropdownButtonFormField<int>(
                      value: _selectedBatchId,
                      items: _batches.map<DropdownMenuItem<int>>((item) {
                        return DropdownMenuItem<int>(
                          value: item["id"],
                          child: Text("Batch ${item["batch_ke"]}"),
                        );
                      }).toList(),
                      onChanged: (val) =>
                          setState(() => _selectedBatchId = val),
                      decoration: _inputStyle("Pilih Batch", Icons.group),
                      validator: (value) =>
                          value == null ? "Batch wajib dipilih" : null,
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: _inputStyle('Kata sandi', Icons.lock)
                          .copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: scheme.outline,
                              ),
                              onPressed: () => setState(
                                () => _obscurePassword = !_obscurePassword,
                              ),
                            ),
                          ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Kata sandi wajib diisi';
                        }
                        if (value.length < 6) return 'Minimal 6 karakter';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Confirm Password
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration:
                          _inputStyle(
                            'Konfirmasi sandi',
                            Icons.lock_outline,
                          ).copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: scheme.outline,
                              ),
                              onPressed: () => setState(
                                () => _obscureConfirmPassword =
                                    !_obscureConfirmPassword,
                              ),
                            ),
                          ),
                      validator: (value) => value == null || value.isEmpty
                          ? 'Konfirmasi wajib diisi'
                          : null,
                    ),
                    const SizedBox(height: 28),

                    // Tombol daftar + kembali
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Kembali"),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : FilledButton(
                                  onPressed: _register,
                                  child: const Text('Daftar'),
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Sudah punya akun? Login di sini
                    Text.rich(
                      TextSpan(
                        text: "Sudah punya akun? ",
                        children: [
                          WidgetSpan(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginPresensi(),
                                  ),
                                );
                              },
                              child: Text(
                                "Login di sini",
                                style: TextStyle(
                                  color: scheme.primary,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
