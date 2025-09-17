// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:absensi_ppkdjp_b3/api/absen_today.dart';
import 'package:absensi_ppkdjp_b3/api/endpoint.dart';
import 'package:absensi_ppkdjp_b3/model/auth/absen_checkin.dart';
import 'package:absensi_ppkdjp_b3/model/auth/absen_checkout.dart';
import 'package:absensi_ppkdjp_b3/preference/shared_preference.dart';
import 'package:http/http.dart' as http;

class AbsenAPI {
  static Future<CheckInResponse?> checkIn({
    required String attendanceDate,
    required String checkIn,
    required double lat,
    required double lng,
    required String address,
  }) async {
    final token = await PreferenceHandler.getToken();
    if (token == null) return null;

    final response = await http.post(
      Uri.parse(Endpoint.checkIn),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "attendance_date": attendanceDate,
        "check_in": checkIn,
        "check_in_lat": lat,
        "check_in_lng": lng,
        "check_in_location": "$lat,$lng",
        "check_in_address": address,
      }),
    );

    print("CheckIn response: ${response.statusCode} ${response.body}");

    if (response.statusCode == 200) {
      return checkInResponseFromJson(response.body);
    }
    return null;
  }

  static Future<CheckOutResponse?> checkOut({
    required String attendanceDate,
    required String checkOut,
    required double lat,
    required double lng,
    required String address,
  }) async {
    final token = await PreferenceHandler.getToken();
    if (token == null) return null;

    final response = await http.post(
      Uri.parse(Endpoint.checkOut),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "attendance_date": attendanceDate,
        "check_out": checkOut,
        "check_out_lat": lat,
        "check_out_lng": lng,
        "check_out_location": "$lat,$lng",
        "check_out_address": address,
      }),
    );

    print("CheckOut response: ${response.statusCode} ${response.body}");

    if (response.statusCode == 200) {
      return checkOutResponseFromJson(response.body);
    }
    return null;
  }

  static Future<AbsenTodayResponse?> getToday() async {
    final token = await PreferenceHandler.getToken(); // jangan lupa await

    final response = await http.get(
      Uri.parse(Endpoint.absenToday),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      return AbsenTodayResponse.fromJson(jsonDecode(response.body));
    }
    return null;
  }
}
