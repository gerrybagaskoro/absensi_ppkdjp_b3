class Endpoint {
  static const String baseURL = 'https://appabsensi.mobileprojp.com/api';

  // Auth Endpoints
  static const String login = '$baseURL/login'; // Sudah
  static const String register = '$baseURL/register'; // Sudah
  static const String profile = "$baseURL/profile"; // Sudah
  static const String editFoto = "$baseURL/profile/photo"; // Sudah
  static const String checkIn = "$baseURL/absen/check-in"; // Sudah
  static const String checkOut = "$baseURL/absen/check-out"; // Sudah
  static const String izin = "$baseURL/izin"; // Sudah
  static const String absenToday = "$baseURL/absen/today"; // Sudah
  static const String absenStats = "$baseURL/absen/stats";
  static const String historyAbsen = "$baseURL/absen/history"; // Sudah
  static const String allUsers = "$baseURL/users";
  static const String training = "$baseURL/trainings"; // Sudah
  static const String batch = "$baseURL/batches"; // Sudah
}
