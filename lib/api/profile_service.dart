// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:absensi_ppkdjp_b3/api/endpoint.dart';
import 'package:absensi_ppkdjp_b3/model/auth/get_profile_model.dart';
import 'package:absensi_ppkdjp_b3/preference/shared_preference.dart';
import 'package:http/http.dart' as http;

class ProfileService {
  static Future<GetProfile?> fetchProfile() async {
    try {
      final token = await PreferenceHandler.getToken();
      if (token == null) return null;

      final response = await http.get(
        Uri.parse(Endpoint.profile),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        return getProfileFromJson(response.body);
      } else {
        print("Fetch profile failed: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetch profile: $e");
      return null;
    }
  }

  static Future<Map<String, dynamic>?> getProfileFromCache() async {
    final userJson = await PreferenceHandler.getUserData();
    if (userJson != null) {
      try {
        return jsonDecode(userJson);
      } catch (_) {
        return null;
      }
    }
    return null;
  }
}
