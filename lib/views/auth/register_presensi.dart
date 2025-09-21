// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:absensi_ppkdjp_b3/api/endpoint.dart';
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
        const SnackBar(content: Text('Password dan konfirmasi tidak sama')),
      );
      return;
    }

    if (_selectedTrainingId == null || _selectedBatchId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih Training dan Batch terlebih dahulu'),
        ),
      );
      return;
    }

    if (_gender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih jenis kelamin terlebih dahulu')),
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
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context); // kembali ke login
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data["message"] ?? "Registrasi gagal"),
            backgroundColor: Colors.red,
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
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.orange[700]),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: BorderSide(color: Colors.orange.shade700, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFA726), Color(0xFFF57C00)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 10,
              shadowColor: Colors.black26,
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
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[800],
                            ),
                      ),
                      const SizedBox(height: 24),

                      // Avatar
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 55,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: _avatarFile != null
                                ? FileImage(_avatarFile!)
                                : null,
                            child: _avatarFile == null
                                ? const Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.white,
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
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                padding: const EdgeInsets.all(6),
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 20,
                                  color: Colors.white,
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
                          if (value == null || value.isEmpty)
                            return 'Surel wajib diisi';
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
                          DropdownMenuItem(
                            value: "L",
                            child: Text("Laki-laki"),
                          ),
                          DropdownMenuItem(
                            value: "P",
                            child: Text("Perempuan"),
                          ),
                        ],
                        onChanged: (val) => setState(() => _gender = val),
                        decoration: _inputStyle(
                          "Jenis Kelamin",
                          Icons.person_outline,
                        ),
                        validator: (value) => value == null
                            ? "Jenis kelamin wajib dipilih"
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // Dropdown Training
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
                                  color: Colors.orange[700],
                                ),
                                onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword,
                                ),
                              ),
                            ),
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Kata sandi wajib diisi';
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
                                  color: Colors.orange[700],
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

                      // Tombol daftar
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: _isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ElevatedButton(
                                onPressed: _register,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange[700],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  elevation: 3,
                                ),
                                child: const Text(
                                  'Daftar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),

                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'Sudah punya akun? Login di sini',
                          style: TextStyle(
                            color: Colors.orange,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
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
