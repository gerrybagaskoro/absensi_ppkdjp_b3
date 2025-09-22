// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:absensi_ppkdjp_b3/api/auth_services/forgot_password.dart';
import 'package:absensi_ppkdjp_b3/api/auth_services/reset_password.dart';
import 'package:animate_do/animate_do.dart';
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
  bool _obscurePassword = true;

  Future<void> _sendOtp() async {
    if (_emailController.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final res = await ForgotPasswordAPI.sendOtp(_emailController.text.trim());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res?.message ?? "OTP berhasil dikirim")),
      );
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

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffix,
    Color? color,
  }) {
    final theme = Theme.of(context);
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: color ?? theme.colorScheme.primary),
      suffixIcon: suffix,
      filled: true,
      fillColor: theme.colorScheme.surfaceContainerHighest,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: theme.colorScheme.primary, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.primary,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: FadeInDown(
              delay: const Duration(milliseconds: 300),
              duration: const Duration(milliseconds: 800),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 6,
                color: theme.colorScheme.surface,
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  splashColor: theme.colorScheme.primary.withOpacity(0.1),
                  onTap: () {}, // ripple di card
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Reset Kata Sandi",
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 20),

                          TextFormField(
                            controller: _emailController,
                            decoration: _inputDecoration(
                              label: "Email",
                              icon: Icons.email,
                            ),
                            validator: (v) => v == null || v.isEmpty
                                ? "Email tidak boleh kosong"
                                : null,
                          ),
                          const SizedBox(height: 16),

                          if (_showResetFields) ...[
                            TextFormField(
                              controller: _otpController,
                              decoration: _inputDecoration(
                                label: "Kode OTP",
                                icon: Icons.confirmation_number,
                              ),
                              validator: (v) => v == null || v.isEmpty
                                  ? "OTP tidak boleh kosong"
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: _inputDecoration(
                                label: "Password Baru",
                                icon: Icons.lock,
                                suffix: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                  onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword,
                                  ),
                                ),
                              ),
                              validator: (v) => v == null || v.length < 6
                                  ? "Minimal 6 karakter"
                                  : null,
                            ),
                            const SizedBox(height: 24),
                          ],

                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: OutlinedButton(
                                    onPressed: () => Navigator.pop(context),
                                    style: ButtonStyle(
                                      foregroundColor:
                                          WidgetStateProperty.resolveWith(
                                            (states) =>
                                                states.contains(
                                                  WidgetState.pressed,
                                                )
                                                ? theme
                                                      .colorScheme
                                                      .primaryContainer
                                                : theme.colorScheme.primary,
                                          ),
                                      side: WidgetStateProperty.all(
                                        BorderSide(
                                          color: theme.colorScheme.primary,
                                          width: 2,
                                        ),
                                      ),
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: const Text(
                                      "Kembali",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: SizedBox(
                                  height: 48,
                                  child: ElevatedButton(
                                    onPressed: _isLoading
                                        ? null
                                        : _showResetFields
                                        ? _resetPassword
                                        : _sendOtp,
                                    style: ButtonStyle(
                                      backgroundColor:
                                          WidgetStateProperty.resolveWith((
                                            states,
                                          ) {
                                            if (states.contains(
                                              WidgetState.pressed,
                                            )) {
                                              return theme
                                                  .colorScheme
                                                  .primaryContainer;
                                            }
                                            return theme.colorScheme.primary;
                                          }),
                                      foregroundColor: WidgetStateProperty.all(
                                        theme.colorScheme.onPrimary,
                                      ),
                                      shape: WidgetStateProperty.all(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                        ),
                                      ),
                                      overlayColor: WidgetStateProperty.all(
                                        theme.colorScheme.onPrimary.withOpacity(
                                          0.1,
                                        ),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color:
                                                  theme.colorScheme.onPrimary,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            _showResetFields
                                                ? "Reset Password"
                                                : "Kirim OTP",
                                            style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
