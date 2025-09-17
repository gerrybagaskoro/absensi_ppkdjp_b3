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
}

class AbsenTodayData {
  int? id;
  String? attendanceDate;
  String? checkInTime;
  String? checkOutTime;
  String? status;

  AbsenTodayData({
    this.id,
    this.attendanceDate,
    this.checkInTime,
    this.checkOutTime,
    this.status,
  });

  factory AbsenTodayData.fromJson(Map<String, dynamic> json) => AbsenTodayData(
    id: json["id"],
    attendanceDate: json["attendance_date"],
    checkInTime: json["check_in_time"],
    checkOutTime: json["check_out_time"],
    status: json["status"],
  );
}
