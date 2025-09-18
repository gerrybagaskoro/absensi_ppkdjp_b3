// ignore_for_file: avoid_print

import 'package:absensi_ppkdjp_b3/api/endpoint.dart';
import 'package:absensi_ppkdjp_b3/model/presensi/history_absensi.dart';
import 'package:absensi_ppkdjp_b3/preference/shared_preference.dart';
import 'package:http/http.dart' as http;

class AbsenApiHistory {
  static Future<HistoryAbsen?> getHistory() async {
    try {
      final token = await PreferenceHandler.getToken(); // ✅ tambahkan await
      if (token == null) {
        print("Token tidak tersedia");
        return null;
      }

      final response = await http.get(
        Uri.parse(Endpoint.historyAbsen),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      print("STATUS CODE: ${response.statusCode}");
      print("RAW RESPONSE: ${response.body}");

      if (response.statusCode == 200) {
        return historyAbsenFromJson(response.body);
      } else {
        print("Gagal fetch history: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error getHistory: $e");
      return null;
    }
  }
}
