// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:absensi_ppkdjp_b3/api/auth_services/forgot_password.dart';
import 'package:absensi_ppkdjp_b3/api/auth_services/reset_password.dart';
import 'package:flutter/material.dart';

class ForgotResetPasswordScreen extends StatefulWidget {
  static const String id = '/forgot_password_presensi';
  const ForgotResetPasswordScreen({super.key});

  @override
  State<ForgotResetPasswordScreen> createState() =>
      _ForgotResetPasswordScreenState();
}

class _ForgotResetPasswordScreenState extends State<ForgotResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _showResetFields = false;
  bool _obscurePassword = true; // ✅ untuk toggle password baru

  Future<void> _sendOtp() async {
    if (_emailController.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final res = await ForgotPasswordAPI.sendOtp(_emailController.text.trim());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(res?.message ?? "OTP terkirim")));

      setState(() => _showResetFields = true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal kirim OTP: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final res = await ResetPasswordAPI.resetPassword(
        email: _emailController.text.trim(),
        otp: _otpController.text.trim(),
        password: _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res?.message ?? "Password berhasil diperbarui")),
      );

      Navigator.pop(context); // kembali ke login
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal reset password: $e")));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lupa Kata Sandi")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Reset Kata Sandi",
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[800],
                          ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        prefixIcon: Icon(Icons.email, color: Colors.orange),
                      ),
                      validator: (v) => v == null || v.isEmpty
                          ? "Email tidak boleh kosong"
                          : null,
                    ),
                    const SizedBox(height: 16),
                    if (_showResetFields) ...[
                      TextFormField(
                        controller: _otpController,
                        decoration: const InputDecoration(
                          labelText: "Kode OTP",
                          prefixIcon: Icon(
                            Icons.confirmation_number,
                            color: Colors.orange,
                          ),
                        ),
                        validator: (v) => v == null || v.isEmpty
                            ? "OTP tidak boleh kosong"
                            : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: "Password Baru",
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Colors.orange,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (v) => v == null || v.length < 6
                            ? "Minimal 6 karakter"
                            : null,
                      ),
                      const SizedBox(height: 24),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : _showResetFields
                            ? _resetPassword
                            : _sendOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange[700],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text(
                                _showResetFields
                                    ? "Reset Password"
                                    : "Kirim OTP",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
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
    );
  }
}
