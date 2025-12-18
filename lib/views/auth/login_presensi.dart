// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:convert';

import 'package:absensi_ppkdjp_b3/api/endpoint.dart';
import 'package:absensi_ppkdjp_b3/extension/navigation.dart';
import 'package:absensi_ppkdjp_b3/l10n/app_localizations.dart';
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

class _LoginPresensiState extends State<LoginPresensi>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  bool? _loginSuccess; // null = loading, true = success, false = gagal
  String _loginMessage = '';

  // animasi titik "sedang memuat..."
  late AnimationController _dotsController;
  late Animation<int> _dotsAnimation;

  @override
  void initState() {
    super.initState();
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    _dotsAnimation = StepTween(begin: 0, end: 3).animate(_dotsController);
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _isLoading = true;
      _loginSuccess = null;
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
            _loginMessage = l10n.loginSuccess;
          });

          await Future.delayed(const Duration(seconds: 3));

          if (mounted) {
            setState(() => _isLoading = false);
            context.pushNamedAndRemoveAll('/dashboard_presensi');
          }
        } else {
          setState(() {
            _loginSuccess = false;
            _loginMessage = l10n.loginInvalidData;
          });
        }
      } else {
        final errorResponse = jsonDecode(response.body);
        final String message = errorResponse['message'] ?? l10n.loginFailed;

        setState(() {
          _loginSuccess = false;
          _loginMessage = message;
        });
      }
    } catch (e) {
      setState(() {
        _loginSuccess = false;
        _loginMessage = l10n.loginError(e.toString());
      });
    }
  }

  void _dismissFailedOverlay() {
    if (_loginSuccess == false) {
      setState(() {
        _isLoading = false;
        _loginMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

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
                            l10n.loginTitleHeader,
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
                              labelText: l10n.emailLabel,
                              prefixIcon: Icon(
                                Icons.email,
                                color: scheme.primary,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.emailEmpty;
                              }
                              if (!value.contains('@')) {
                                return l10n.emailInvalid;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: l10n.passwordLabel,
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
                                return l10n.passwordEmpty;
                              }
                              if (value.length < 6) {
                                return l10n.passwordMinLength;
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
                              child: Text(l10n.loginButton),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text.rich(
                            TextSpan(
                              text: l10n.noAccount,
                              style: TextStyle(color: scheme.onSurfaceVariant),
                              children: [
                                TextSpan(
                                  text: l10n.registerAction,
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
                              text: l10n.forgotPasswordPrompt,
                              style: TextStyle(color: scheme.onSurfaceVariant),
                              children: [
                                TextSpan(
                                  text: l10n.resetAction,
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

          // Overlay animasi loading + hasil login
          if (_isLoading)
            GestureDetector(
              onTap: _loginSuccess == false ? _dismissFailedOverlay : null,
              child: Container(
                color: Colors.black.withOpacity(0.7),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_loginSuccess == null) ...[
                      AnimatedBuilder(
                        animation: _dotsAnimation,
                        builder: (_, __) {
                          String dots = "." * _dotsAnimation.value;
                          return Text(
                            "${l10n.loading}$dots",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          );
                        },
                      ),
                    ] else ...[
                      Lottie.asset(
                        _loginSuccess == true
                            ? 'assets/animations/success.json'
                            : 'assets/animations/failed.json',
                        width: 200,
                        height: 200,
                        repeat: false,
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
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _dotsController.dispose();
    super.dispose();
  }
}
