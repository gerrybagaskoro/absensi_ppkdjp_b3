// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:absensi_ppkdjp_b3/api/endpoint.dart';
import 'package:absensi_ppkdjp_b3/extension/navigation.dart';
import 'package:absensi_ppkdjp_b3/model/auth/user_model.dart';
import 'package:absensi_ppkdjp_b3/preference/shared_preference.dart';
import 'package:absensi_ppkdjp_b3/utils/app_logo.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';

class LoginPresensi extends StatefulWidget {
  static const String id = '/login_presensi';
  const LoginPresensi({super.key});

  @override
  State<LoginPresensi> createState() => _LoginPresensiState();
}

class _LoginPresensiState extends State<LoginPresensi> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _loginSuccess = false; // true jika login berhasil
  String _loginMessage = ''; // pesan animasi (success/failed)

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _loginMessage = '';
    });

    try {
      final response = await http.post(
        Uri.parse(Endpoint.login),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "email": _emailController.text.trim(),
          "password": _passwordController.text.trim(),
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final userModel = UserModel.fromJson(jsonResponse);

        final token = userModel.data?.token;
        final user = userModel.data?.user;

        if (token != null && user != null) {
          await PreferenceHandler.saveLogin(true);
          await PreferenceHandler.saveToken(token);
          await PreferenceHandler.saveUserData(jsonEncode(user.toJson()));

          setState(() {
            _loginSuccess = true;
            _loginMessage = 'Login berhasil!';
          });

          // Tampilkan animasi success selama 5 detik
          await Future.delayed(const Duration(seconds: 5));

          if (mounted) {
            setState(() => _isLoading = false);
            context.pushNamedAndRemoveAll('/dashboard_presensi');
          }
        } else {
          setState(() {
            _loginSuccess = false;
            _loginMessage = 'Data login tidak valid dari server';
            _isLoading = true; // tetap loading untuk menampilkan overlay
          });
        }
      } else {
        final errorResponse = jsonDecode(response.body);
        final String message = errorResponse['message'] ?? 'Login gagal';

        setState(() {
          _loginSuccess = false;
          _loginMessage = message;
          _isLoading = true; // overlay failed
        });
      }
    } catch (e) {
      setState(() {
        _loginSuccess = false;
        _loginMessage = 'Terjadi kesalahan: $e';
        _isLoading = true; // overlay failed
      });
    }
  }

  // Tap overlay untuk menutup failed animation
  void _dismissFailedOverlay() {
    if (!_loginSuccess) {
      setState(() {
        _isLoading = false;
        _loginMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: FadeInDown(
                delay: const Duration(milliseconds: 300),
                duration: const Duration(milliseconds: 700),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FadeIn(
                            delay: const Duration(milliseconds: 100),
                            child: const AppLogo(width: 200, height: 200),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            'Masuk untuk Presensi',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: scheme.primary,
                                ),
                          ),
                          const SizedBox(height: 30),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'E-mail',
                              prefixIcon: Icon(
                                Icons.email,
                                color: scheme.primary,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'E-mail tidak boleh kosong';
                              }
                              if (!value.contains('@')) {
                                return 'Format E-mail tidak valid';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Kata sandi',
                              prefixIcon: Icon(
                                Icons.lock,
                                color: scheme.primary,
                              ),
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
                                return 'Kata sandi tidak boleh kosong';
                              }
                              if (value.length < 6) {
                                return 'Minimal 6 karakter';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: FilledButton(
                              onPressed: _isLoading ? null : _login,
                              child: _isLoading && !_loginSuccess
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text('Masuk'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text.rich(
                            TextSpan(
                              text: 'Belum punya akun? ',
                              style: TextStyle(color: scheme.onSurfaceVariant),
                              children: [
                                TextSpan(
                                  text: 'Daftar di sini',
                                  style: TextStyle(
                                    color: scheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.pushNamed('/register_presensi');
                                    },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text.rich(
                            TextSpan(
                              text: 'Lupa kata sandi? ',
                              style: TextStyle(color: scheme.onSurfaceVariant),
                              children: [
                                TextSpan(
                                  text: 'Reset di sini',
                                  style: TextStyle(
                                    color: scheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      context.pushNamed(
                                        '/forgot_password_presensi',
                                      );
                                    },
                                ),
                              ],
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

          // Overlay Lottie
          if (_isLoading)
            GestureDetector(
              onTap: _dismissFailedOverlay,
              child: Container(
                color: Colors.black.withOpacity(_loginSuccess ? 0.5 : 0.7),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Lottie.asset(
                      _loginSuccess
                          ? 'assets/animations/success.json'
                          : 'assets/animations/failed.json',
                      width: 200,
                      height: 200,
                      repeat: true,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _loginMessage,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
