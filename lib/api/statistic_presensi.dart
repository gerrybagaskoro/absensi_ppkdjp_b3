// lib/api/absen_stats_api.dart
// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:absensi_ppkdjp_b3/model/presensi/statistic_presensi.dart';
import 'package:absensi_ppkdjp_b3/preference/shared_preference.dart';
import 'package:http/http.dart' as http;

import 'endpoint.dart';

class AbsenStatsAPI {
  static Future<AbsenStats?> fetchAbsenStats({
    required String start,
    required String end,
  }) async {
    try {
      final token = await PreferenceHandler.getToken(); // ambil token
      if (token == null) {
        print('Token tidak ditemukan!');
        return null;
      }

      final uri = Uri.parse('${Endpoint.absenStats}?start=$start&end=$end');
      final response = await http.get(
        uri,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return AbsenStatsResponse.fromJson(jsonData).data;
      } else {
        print('Error fetching absen stats: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
