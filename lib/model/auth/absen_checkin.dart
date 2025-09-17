// To parse this JSON data, do
//
//     final checkInResponse = checkInResponseFromJson(jsonString);

import 'dart:convert';

CheckInResponse checkInResponseFromJson(String str) =>
    CheckInResponse.fromJson(json.decode(str));

String checkInResponseToJson(CheckInResponse data) =>
    json.encode(data.toJson());

class CheckInResponse {
  String? message;
  CheckInData? data;

  CheckInResponse({this.message, this.data});

  factory CheckInResponse.fromJson(Map<String, dynamic> json) =>
      CheckInResponse(
        message: json["message"],
        data: json["data"] == null ? null : CheckInData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {"message": message, "data": data?.toJson()};
}

class CheckInData {
  int? id;
  String? attendanceDate;
  String? checkInTime;
  double? checkInLat;
  double? checkInLng;
  String? checkInLocation;
  String? checkInAddress;
  String? status;
  dynamic alasanIzin;

  CheckInData({
    this.id,
    this.attendanceDate,
    this.checkInTime,
    this.checkInLat,
    this.checkInLng,
    this.checkInLocation,
    this.checkInAddress,
    this.status,
    this.alasanIzin,
  });

  factory CheckInData.fromJson(Map<String, dynamic> json) => CheckInData(
    id: json["id"],
    attendanceDate: json["attendance_date"],
    checkInTime: json["check_in_time"],
    checkInLat: (json["check_in_lat"] as num?)?.toDouble(),
    checkInLng: (json["check_in_lng"] as num?)?.toDouble(),
    checkInLocation: json["check_in_location"],
    checkInAddress: json["check_in_address"],
    status: json["status"],
    alasanIzin: json["alasan_izin"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "attendance_date": attendanceDate,
    "check_in_time": checkInTime,
    "check_in_lat": checkInLat,
    "check_in_lng": checkInLng,
    "check_in_location": checkInLocation,
    "check_in_address": checkInAddress,
    "status": status,
    "alasan_izin": alasanIzin,
  };
}
