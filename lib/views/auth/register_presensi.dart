// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:absensi_ppkdjp_b3/api/endpoint.dart';
import 'package:absensi_ppkdjp_b3/l10n/app_localizations.dart';
import 'package:absensi_ppkdjp_b3/views/auth/login_presensi.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';

class RegisterPresensi extends StatefulWidget {
  static const String id = '/register_presensi';
  const RegisterPresensi({super.key});

  @override
  State<RegisterPresensi> createState() => _RegisterPresensiState();
}

class _RegisterPresensiState extends State<RegisterPresensi>
    with SingleTickerProviderStateMixin {
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

  // animasi loading teks
  late AnimationController _dotsController;
  late Animation<int> _dotsAnimation;

  @override
  void initState() {
    super.initState();
    _fetchTrainings();
    _fetchBatches();

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _dotsAnimation = StepTween(
      begin: 0,
      end: 3,
    ).animate(_dotsController); // titik animasi
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

  void _showSuccessOverlay(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset("assets/animations/success.json", repeat: false),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorOverlay(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // animasi gagal
                Lottie.asset(
                  "assets/animations/failed.json",
                  width: 200,
                  height: 200,
                  repeat: false,
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Register action
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      _showErrorOverlay(AppLocalizations.of(context)!.passwordMismatch);
      return;
    }

    if (_selectedTrainingId == null || _selectedBatchId == null) {
      _showErrorOverlay(AppLocalizations.of(context)!.chooseTrainingBatch);
      return;
    }

    if (_gender == null) {
      _showErrorOverlay(AppLocalizations.of(context)!.chooseGender);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final base64Image = await _imageToBase64(_avatarFile);

      final body = {
        "name": _nameController.text,
        "email": _emailController.text,
        "password": _passwordController.text,
        "jenis_kelamin": _gender,
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
        if (mounted) setState(() => _isLoading = false);

        _showSuccessOverlay(
          data["message"] ?? AppLocalizations.of(context)!.registerSuccess,
        );

        await Future.delayed(const Duration(seconds: 3));
        if (mounted) {
          Navigator.pop(context); // tutup dialog sukses
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const LoginPresensi()),
          );
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
        _showErrorOverlay(
          data["message"] ?? AppLocalizations.of(context)!.registerFailed,
        );
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      _showErrorOverlay("Error: $e");
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

    return Stack(
      children: [
        Scaffold(
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
                          AppLocalizations.of(context)!.registerTitle,
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
                          decoration: _inputStyle(
                            AppLocalizations.of(context)!.fullName,
                            Icons.person,
                          ),
                          validator: (value) => value == null || value.isEmpty
                              ? AppLocalizations.of(context)!.nameRequired
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Email
                        TextFormField(
                          controller: _emailController,
                          decoration: _inputStyle(
                            AppLocalizations.of(context)!.emailLabel,
                            Icons.email,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(
                                context,
                              )!.emailRequired;
                            }
                            if (!RegExp(
                              r'^[^@]+@[^@]+\.[^@]+',
                            ).hasMatch(value)) {
                              return AppLocalizations.of(context)!.emailInvalid;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Gender dropdown
                        DropdownButtonFormField<String>(
                          initialValue: _gender,
                          items: [
                            DropdownMenuItem(
                              value: "L",
                              child: Text(
                                AppLocalizations.of(context)!.genderMale,
                              ),
                            ),
                            DropdownMenuItem(
                              value: "P",
                              child: Text(
                                AppLocalizations.of(context)!.genderFemale,
                              ),
                            ),
                          ],
                          onChanged: (val) => setState(() => _gender = val),
                          decoration: _inputStyle(
                            AppLocalizations.of(context)!.genderLabel,
                            Icons.person_outline,
                          ),
                          validator: (value) => value == null
                              ? AppLocalizations.of(context)!.genderRequired
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Training
                        DropdownButtonFormField<int>(
                          initialValue: _selectedTrainingId,
                          items: _trainings.map<DropdownMenuItem<int>>((item) {
                            return DropdownMenuItem<int>(
                              value: item["id"],
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.5,
                                ),
                                child: Text(
                                  item["title"] ?? "Training",
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => _selectedTrainingId = val),
                          decoration: _inputStyle(
                            AppLocalizations.of(context)!.trainingLabel,
                            Icons.school,
                          ),
                          validator: (value) => value == null
                              ? AppLocalizations.of(context)!.trainingRequired
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Batch
                        DropdownButtonFormField<int>(
                          initialValue: _selectedBatchId,
                          items: _batches.map<DropdownMenuItem<int>>((item) {
                            return DropdownMenuItem<int>(
                              value: item["id"],
                              child: Text(
                                "${AppLocalizations.of(context)!.batch} ${item["batch_ke"]}",
                              ),
                            );
                          }).toList(),
                          onChanged: (val) =>
                              setState(() => _selectedBatchId = val),
                          decoration: _inputStyle(
                            AppLocalizations.of(context)!.batchLabel,
                            Icons.group,
                          ),
                          validator: (value) => value == null
                              ? AppLocalizations.of(context)!.batchRequired
                              : null,
                        ),
                        const SizedBox(height: 16),

                        // Password
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration:
                              _inputStyle(
                                AppLocalizations.of(context)!.passwordLabel,
                                Icons.lock,
                              ).copyWith(
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
                              return AppLocalizations.of(
                                context,
                              )!.passwordRequired;
                            }
                            if (value.length < 6) {
                              return AppLocalizations.of(
                                context,
                              )!.passwordMinLength;
                            }
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
                                AppLocalizations.of(
                                  context,
                                )!.confirmPasswordLabel,
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
                              ? AppLocalizations.of(
                                  context,
                                )!.confirmPasswordRequired
                              : null,
                        ),
                        const SizedBox(height: 28),

                        // Tombol daftar + kembali
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(AppLocalizations.of(context)!.back),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton(
                                onPressed: _register,
                                child: Text(
                                  AppLocalizations.of(context)!.register,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Sudah punya akun? Login
                        Text.rich(
                          TextSpan(
                            text: AppLocalizations.of(context)!.haveAccount,
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
                                    AppLocalizations.of(context)!.loginHere,
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
        ),

        // Overlay loading
        if (_isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: AnimatedBuilder(
                animation: _dotsAnimation,
                builder: (_, __) {
                  String dots = "." * _dotsAnimation.value;
                  return Text(
                    "${AppLocalizations.of(context)!.loading}$dots",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dotsController.dispose();
    super.dispose();
  }
}
