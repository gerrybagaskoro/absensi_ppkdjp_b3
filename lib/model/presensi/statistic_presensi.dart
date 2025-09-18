// lib/models/absen_stats.dart
class AbsenStats {
  final int totalAbsen;
  final int totalMasuk;
  final int totalIzin;
  final bool sudahAbsenHariIni;

  AbsenStats({
    required this.totalAbsen,
    required this.totalMasuk,
    required this.totalIzin,
    required this.sudahAbsenHariIni,
  });

  factory AbsenStats.fromJson(Map<String, dynamic> json) {
    return AbsenStats(
      totalAbsen: json['total_absen'] ?? 0,
      totalMasuk: json['total_masuk'] ?? 0,
      totalIzin: json['total_izin'] ?? 0,
      sudahAbsenHariIni: json['sudah_absen_hari_ini'] ?? false,
    );
  }
}

class AbsenStatsResponse {
  final String message;
  final AbsenStats data;

  AbsenStatsResponse({required this.message, required this.data});

  factory AbsenStatsResponse.fromJson(Map<String, dynamic> json) {
    return AbsenStatsResponse(
      message: json['message'] ?? '',
      data: AbsenStats.fromJson(json['data']),
    );
  }
}
