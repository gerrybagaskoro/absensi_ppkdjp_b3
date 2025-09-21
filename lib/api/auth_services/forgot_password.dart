import 'dart:convert';

import 'package:absensi_ppkdjp_b3/api/endpoint.dart';
import 'package:absensi_ppkdjp_b3/model/auth/forgot_password.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordAPI {
  static Future<ForgotPasswordResponse?> sendOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse(Endpoint.forgotPassword),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email}),
      );

      if (response.statusCode == 200) {
        return ForgotPasswordResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception("Gagal kirim OTP: ${response.body}");
      }
    } catch (e) {
      rethrow;
    }
  }
}
