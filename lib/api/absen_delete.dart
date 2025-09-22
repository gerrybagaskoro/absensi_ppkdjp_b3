// ignore_for_file: avoid_print
import 'package:absensi_ppkdjp_b3/preference/shared_preference.dart';
import 'package:http/http.dart' as http;

import 'endpoint.dart';

class AbsenApiDelete {
  /// Menghapus presensi berdasarkan ID
  static Future<bool> deleteHistory(String id) async {
    try {
      final token = await PreferenceHandler.getToken();
      if (token == null || token.isEmpty) {
        print("Token tidak tersedia");
        return false;
      }

      final url = Uri.parse("${Endpoint.deleteAbsen}/$id");
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // Berhasil dihapus
        return true;
      } else {
        print(
          "Gagal hapus presensi: ${response.statusCode} - ${response.body}",
        );
        return false;
      }
    } catch (e) {
      print("Error deleteHistory: $e");
      return false;
    }
  }
}
