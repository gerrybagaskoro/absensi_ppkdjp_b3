// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get language => 'Indonesia';

  @override
  String get languageSettingsTitle => 'Bahasa';

  @override
  String get settings => 'Pengaturan';

  @override
  String get profile => 'Profil';

  @override
  String get editProfile => 'Sunting Profil';

  @override
  String get exportHistory => 'Ekspor Riwayat Absensi';

  @override
  String get aboutApp => 'Tentang Aplikasi';

  @override
  String get logout => 'Keluar';

  @override
  String get cancel => 'Batal';

  @override
  String get confirmLogout => 'Apakah Anda yakin ingin keluar dari aplikasi?';

  @override
  String get yesLogout => 'Ya, Keluar';

  @override
  String get save => 'Simpan';

  @override
  String get delete => 'Hapus';

  @override
  String get theme => 'Tema Aplikasi';

  @override
  String get themeLight => 'Terang';

  @override
  String get themeDark => 'Gelap';

  @override
  String get themeSystem => 'Mengikuti Sistem';

  @override
  String get notification => 'Notifikasi';

  @override
  String get dailyReminder => 'Atur Pengingat Harian';

  @override
  String get dailyReminderDesc => 'Pengingat untuk absen setiap hari';

  @override
  String get successSave => 'Pengaturan berhasil disimpan';

  @override
  String get onboardingTitle1 => 'Absensi Mudah';

  @override
  String get onboardingDesc1 =>
      'Lakukan absensi masuk dan pulang dengan mudah langsung dari smartphone Anda.';

  @override
  String get onboardingTitle2 => 'Riwayat Realtime';

  @override
  String get onboardingDesc2 =>
      'Pantau riwayat kehadiran Anda secara realtime.';

  @override
  String get onboardingTitle3 => 'Laporan Detail';

  @override
  String get onboardingDesc3 =>
      'Dapatkan laporan kehadiran terperinci kapan saja.';

  @override
  String get onboardingDesc4 => 'Siap untuk presensi digital? Yuk kita mulai!';

  @override
  String get getStarted => 'Mulai Sekarang';

  @override
  String get skip => 'Lewati';

  @override
  String get loginTitle => 'Selamat Datang!';

  @override
  String get loginSubtitle => 'Silakan masuk untuk melanjutkan';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Kata sandi';

  @override
  String get loginButton => 'Masuk';

  @override
  String get dashboard => 'Beranda';

  @override
  String get history => 'Riwayat';

  @override
  String get clockIn => 'Absen Masuk';

  @override
  String get clockOut => 'Absen Pulang';

  @override
  String get greetingMorning => 'Selamat Pagi';

  @override
  String get greetingAfternoon => 'Selamat Siang';

  @override
  String get greetingEvening => 'Selamat Sore';

  @override
  String get greetingNight => 'Selamat Malam';

  @override
  String get loginTitleHeader => 'Masuk untuk Presensi';

  @override
  String get emailEmpty => 'E-mail tidak boleh kosong';

  @override
  String get emailInvalid => 'Format E-mail tidak valid';

  @override
  String get passwordEmpty => 'Kata sandi tidak boleh kosong';

  @override
  String get passwordMinLength => 'Minimal 6 karakter';

  @override
  String get noAccount => 'Belum punya akun? ';

  @override
  String get registerAction => 'Daftar di sini';

  @override
  String get forgotPasswordPrompt => 'Lupa kata sandi? ';

  @override
  String get resetAction => 'Reset di sini';

  @override
  String get loading => 'Sedang memuat';

  @override
  String get loginSuccess => 'Login berhasil!';

  @override
  String get loginFailed => 'Login gagal';

  @override
  String get loginInvalidData => 'Data login tidak valid dari server';

  @override
  String loginError(String error) {
    return 'Terjadi kesalahan: $error';
  }

  @override
  String get appName => 'Presensi Kita';

  @override
  String get statistic => 'Statistik';

  @override
  String get status => 'Status';

  @override
  String get excused => 'Excused';

  @override
  String get permission => 'Izin';

  @override
  String get todayStatus => 'Status Absen Hari Ini';

  @override
  String get notPresent => 'Belum Absen';

  @override
  String get checkIn => 'Masuk';

  @override
  String get checkOut => 'Pulang';

  @override
  String get reasonPermission => 'Alasan Izin: ';

  @override
  String get permissionToday => '📌 Anda sedang izin hari ini';

  @override
  String get farLocation => '⚠️ Anda jauh dari lokasi PPKDJP';

  @override
  String get alreadyPresent => '✅ Anda sudah absen masuk & pulang hari ini';

  @override
  String get locationNotAvailable => 'Lokasi belum tersedia';

  @override
  String get checkInSuccess => 'Absen masuk berhasil';

  @override
  String get checkInFailed => 'Gagal absen masuk';

  @override
  String get checkOutSuccess => 'Absen pulang berhasil';

  @override
  String get checkOutFailed => 'Gagal absen pulang';

  @override
  String checkInError(String error) {
    return 'Terjadi error saat absen: $error';
  }

  @override
  String get statusNotPresent => 'Belum Absen';

  @override
  String get statusPresent => 'Hadir';

  @override
  String get statusLate => 'Telat';

  @override
  String get statusPermission => 'Izin';

  @override
  String get statusAbsent => 'Alpha';

  @override
  String get dataTitle => 'Data';

  @override
  String get exportHistorySubtitle => 'Unduh riwayat absensi dalam format PDF';

  @override
  String dailyReminderTime(Object time) {
    return 'Setiap hari jam $time';
  }

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get logoutConfirm => 'Apakah Anda yakin ingin keluar dari aplikasi?';

  @override
  String get logoutSuccess => 'Anda telah keluar.';

  @override
  String get noName => 'Tidak ada nama';

  @override
  String get noEmail => 'Tidak ada email';

  @override
  String get batch => 'Batch ke-';

  @override
  String get training => 'Pelatihan: ';

  @override
  String get historyTitle => 'Riwayat Presensi';

  @override
  String get holdToDelete => 'Tekan lama untuk menghapus absensi';

  @override
  String get allDates => 'Semua Tanggal';

  @override
  String get pickDateRange => 'Pilih rentang tanggal';

  @override
  String get resetFilter => 'Reset filter';

  @override
  String get filterReset => 'Filter tanggal direset';

  @override
  String get noHistory => 'Belum ada data presensi';

  @override
  String get deleteAttendance => 'Hapus Presensi';

  @override
  String get deleteAttendanceConfirm =>
      'Apakah Anda yakin ingin menghapus presensi ini?';

  @override
  String get deleteSuccess => 'Presensi berhasil dihapus';

  @override
  String get deleteFailed => 'Gagal menghapus presensi';

  @override
  String get entryTime => 'Masuk: ';

  @override
  String get exitTime => 'Pulang: ';

  @override
  String get statisticTitle => 'Statistik Presensi';

  @override
  String get totalAbsent => 'Total Absen';

  @override
  String get totalPresent => 'Total Masuk';

  @override
  String get totalPermission => 'Total Izin';

  @override
  String get attendanceToday => 'Absen Hari Ini';

  @override
  String get yes => 'Ya';

  @override
  String get notYet => 'Belum';

  @override
  String get permissionTitle => 'Izin Presensi';

  @override
  String get permissionForm => 'Formulir Izin';

  @override
  String get date => 'Tanggal';

  @override
  String get pickDate => 'Pilih Tanggal';

  @override
  String get reason => 'Alasan';

  @override
  String get reasonHint => 'Tuliskan alasan izin';

  @override
  String get reasonRequired => 'Alasan wajib diisi';

  @override
  String get submitPermission => 'Ajukan Izin';

  @override
  String get submitting => 'Mengajukan...';

  @override
  String get myPermissionList => 'Daftar Izin Saya';

  @override
  String get noPermissionData => 'Belum ada data izin';

  @override
  String get reasonLabel => 'Alasan: ';

  @override
  String get fillDateReason => 'Lengkapi tanggal & alasan izin';

  @override
  String get permissionSuccess => 'Izin berhasil diajukan';

  @override
  String get permissionFailed => 'Gagal mengajukan izin';

  @override
  String get loadingMessage => 'Sedang memuat';

  @override
  String get appDescription =>
      'Aplikasi Presensi ini dibuat untuk mempermudah proses absensi dan pencatatan kehadiran dengan tampilan modern berbasis Material You.';

  @override
  String get developerInfo => 'Informasi Pengembang';

  @override
  String appVersion(Object version) {
    return 'Versi $version';
  }

  @override
  String get editProfileTitle => 'Sunting Profil';

  @override
  String get fullName => 'Nama Lengkap';

  @override
  String get nameRequired => 'Nama tidak boleh kosong';

  @override
  String get saveName => 'Simpan Nama';

  @override
  String get photoUpdated => 'Foto profil berhasil diperbarui';

  @override
  String uploadFailed(Object error) {
    return 'Gagal upload foto: $error';
  }

  @override
  String get updateNameSuccess => 'Nama berhasil diperbarui';

  @override
  String updateNameFailed(Object error) {
    return 'Gagal update nama: $error';
  }

  @override
  String get registerTitle => 'Daftar Presensi Kita';

  @override
  String get passwordMismatch => 'Password dan konfirmasi tidak sama';

  @override
  String get chooseTrainingBatch => 'Pilih Training dan Batch terlebih dahulu';

  @override
  String get chooseGender => 'Pilih jenis kelamin terlebih dahulu';

  @override
  String get registerSuccess => 'Registrasi berhasil!';

  @override
  String get registerFailed => 'Registrasi gagal';

  @override
  String get emailRequired => 'E-mail wajib diisi';

  @override
  String get genderLabel => 'Jenis Kelamin';

  @override
  String get genderMale => 'Laki-laki';

  @override
  String get genderFemale => 'Perempuan';

  @override
  String get genderRequired => 'Jenis kelamin wajib dipilih';

  @override
  String get trainingLabel => 'Pilih Training';

  @override
  String get trainingRequired => 'Training wajib dipilih';

  @override
  String get batchLabel => 'Pilih Batch';

  @override
  String get batchRequired => 'Batch wajib dipilih';

  @override
  String get passwordRequired => 'Kata sandi wajib diisi';

  @override
  String get confirmPasswordLabel => 'Konfirmasi sandi';

  @override
  String get confirmPasswordRequired => 'Konfirmasi wajib diisi';

  @override
  String get back => 'Kembali';

  @override
  String get register => 'Daftar';

  @override
  String get haveAccount => 'Sudah punya akun? ';

  @override
  String get loginHere => 'Login di sini';

  @override
  String get statusNotYet => 'Belum Absen';

  @override
  String get welcomeGreet => 'Selamat Datang, ';

  @override
  String get attendanceLocation => 'Lokasi Presensi';

  @override
  String get fetchingLocation => 'Sedang mengambil lokasi...';

  @override
  String distanceTo(Object distance) {
    return 'Jarak anda ke PPKDJP: $distance';
  }

  @override
  String get addressNotFound => 'Alamat tidak ditemukan';

  @override
  String get chooseDate => 'Pilih Tanggal';

  @override
  String get languageId => 'Bahasa Indonesia';

  @override
  String get languageEn => 'Bahasa Inggris';

  @override
  String get forgotPasswordTitle => 'Reset Kata Sandi';

  @override
  String get otpLabel => 'Kode OTP';

  @override
  String get otpEmpty => 'OTP tidak boleh kosong';

  @override
  String get newPasswordLabel => 'Password Baru';

  @override
  String get otpSuccess => 'OTP berhasil dikirim';

  @override
  String otpFailed(Object error) {
    return 'Gagal kirim OTP: $error';
  }

  @override
  String get resetPasswordSuccess => 'Password berhasil diperbarui';

  @override
  String resetPasswordFailed(Object error) {
    return 'Gagal reset password: $error';
  }

  @override
  String get resetPasswordButton => 'Reset Password';

  @override
  String get sendOtpButton => 'Kirim OTP';
}
