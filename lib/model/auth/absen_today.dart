// lib/model/auth/absen_today.dart
class AbsenTodayResponse {
  String? message;
  AbsenTodayData? data;

  AbsenTodayResponse({this.message, this.data});

  factory AbsenTodayResponse.fromJson(Map<String, dynamic> json) =>
      AbsenTodayResponse(
        message: json["message"],
        data: json["data"] == null
            ? null
            : AbsenTodayData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class AbsenTodayData {
  String? attendanceDate;
  String? checkInTime;
  String? checkOutTime;
  String? checkInAddress;
  String? checkOutAddress;
  String? status;
  String? alasanIzin;

  AbsenTodayData({
    this.attendanceDate,
    this.checkInTime,
    this.checkOutTime,
    this.checkInAddress,
    this.checkOutAddress,
    this.status,
    this.alasanIzin,
  });

  factory AbsenTodayData.fromJson(Map<String, dynamic> json) => AbsenTodayData(
    attendanceDate: json["attendance_date"],
    checkInTime: json["check_in_time"],
    checkOutTime: json["check_out_time"],
    checkInAddress: json["check_in_address"],
    checkOutAddress: json["check_out_address"],
    status: json["status"],
    alasanIzin: json["alasan_izin"],
  );

  Map<String, dynamic> toJson() => {
    "attendance_date": attendanceDate,
    "check_in_time": checkInTime,
    "check_out_time": checkOutTime,
    "check_in_address": checkInAddress,
    "check_out_address": checkOutAddress,
    "status": status,
    "alasan_izin": alasanIzin,
  };
}
