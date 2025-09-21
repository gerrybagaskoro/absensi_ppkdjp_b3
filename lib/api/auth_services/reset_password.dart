import 'dart:convert';

import 'package:absensi_ppkdjp_b3/api/endpoint.dart';
import 'package:absensi_ppkdjp_b3/model/auth/reset_password.dart';
import 'package:http/http.dart' as http;

class ResetPasswordAPI {
  static Future<ResetPasswordResponse?> resetPassword({
    required String email,
    required String otp,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoint.resetPassword),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "otp": otp, "password": password}),
      );

      if (response.statusCode == 200) {
        return ResetPasswordResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Gagal reset password: ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
