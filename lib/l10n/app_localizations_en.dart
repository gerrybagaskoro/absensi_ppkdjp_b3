// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get language => 'English';

  @override
  String get languageSettingsTitle => 'Language';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get exportHistory => 'Export Attendance History';

  @override
  String get aboutApp => 'About App';

  @override
  String get logout => 'Logout';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmLogout => 'Are you sure you want to log out?';

  @override
  String get yesLogout => 'Yes, Logout';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get theme => 'App Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System Default';

  @override
  String get notification => 'Notification';

  @override
  String get dailyReminder => 'Daily Reminder';

  @override
  String get dailyReminderDesc => 'Reminder to clock in daily';

  @override
  String get successSave => 'Settings saved successfully';

  @override
  String get onboardingTitle1 => 'Easy Attendance';

  @override
  String get onboardingDesc1 =>
      'Clock in and out easily directly from your smartphone.';

  @override
  String get onboardingTitle2 => 'Realtime History';

  @override
  String get onboardingDesc2 => 'Monitor your attendance history in realtime.';

  @override
  String get onboardingTitle3 => 'Detailed Reports';

  @override
  String get onboardingDesc3 => 'Get detailed attendance reports anytime.';

  @override
  String get onboardingDesc4 =>
      'Ready for digital attendance? Let\'s get started!';

  @override
  String get getStarted => 'Get Started';

  @override
  String get skip => 'Skip';

  @override
  String get loginTitle => 'Welcome Back!';

  @override
  String get loginSubtitle => 'Please login to continue';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Login';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get history => 'History';

  @override
  String get clockIn => 'Clock In';

  @override
  String get clockOut => 'Clock Out';

  @override
  String get greetingMorning => 'Good Morning';

  @override
  String get greetingAfternoon => 'Good Afternoon';

  @override
  String get greetingEvening => 'Good Evening';

  @override
  String get greetingNight => 'Good Night';

  @override
  String get loginTitleHeader => 'Login to Attendance';

  @override
  String get emailEmpty => 'Email cannot be empty';

  @override
  String get emailInvalid => 'Invalid E-mail format';

  @override
  String get passwordEmpty => 'Password cannot be empty';

  @override
  String get passwordMinLength => 'At least 6 characters';

  @override
  String get noAccount => 'Don\'t have an account? ';

  @override
  String get registerAction => 'Register here';

  @override
  String get forgotPasswordPrompt => 'Forgot password? ';

  @override
  String get resetAction => 'Reset here';

  @override
  String get loading => 'Loading';

  @override
  String get loginSuccess => 'Login successful!';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get loginInvalidData => 'Invalid login data from server';

  @override
  String loginError(String error) {
    return 'An error occurred: $error';
  }

  @override
  String get appName => 'Presensi Kita';

  @override
  String get statistic => 'Statistic';

  @override
  String get status => 'Status';

  @override
  String get excused => 'Excused';

  @override
  String get permission => 'Leave Request';

  @override
  String get todayStatus => 'Today\'s Status';

  @override
  String get notPresent => 'Not Present';

  @override
  String get checkIn => 'Check In';

  @override
  String get checkOut => 'Check Out';

  @override
  String get reasonPermission => 'Permission Reason: ';

  @override
  String get permissionToday => '📌 You have permission today';

  @override
  String get farLocation => '⚠️ You are far from PPKDJP location';

  @override
  String get alreadyPresent => '✅ You have clocked in & out today';

  @override
  String get locationNotAvailable => 'Location not available';

  @override
  String get checkInSuccess => 'Check In successful';

  @override
  String get checkInFailed => 'Check In failed';

  @override
  String get checkOutSuccess => 'Check Out successful';

  @override
  String get checkOutFailed => 'Check Out failed';

  @override
  String checkInError(String error) {
    return 'Error occurred: $error';
  }

  @override
  String get statusNotPresent => 'Not Present';

  @override
  String get statusPresent => 'Present';

  @override
  String get statusLate => 'Late';

  @override
  String get statusPermission => 'Excused';

  @override
  String get statusAbsent => 'Absent';

  @override
  String get dataTitle => 'Data';

  @override
  String get exportHistorySubtitle =>
      'Download attendance history in PDF format';

  @override
  String dailyReminderTime(Object time) {
    return 'Every day at $time';
  }

  @override
  String get confirm => 'Confirmation';

  @override
  String get logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get logoutSuccess => 'You have logged out.';

  @override
  String get noName => 'No name';

  @override
  String get noEmail => 'No email';

  @override
  String get batch => 'Batch';

  @override
  String get training => 'Training: ';

  @override
  String get historyTitle => 'Attendance History';

  @override
  String get holdToDelete => 'Long press to delete attendance';

  @override
  String get allDates => 'All Dates';

  @override
  String get pickDateRange => 'Pick date range';

  @override
  String get resetFilter => 'Reset filter';

  @override
  String get filterReset => 'Date filter reset';

  @override
  String get noHistory => 'No attendance data';

  @override
  String get deleteAttendance => 'Delete Attendance';

  @override
  String get deleteAttendanceConfirm =>
      'Are you sure you want to delete this attendance?';

  @override
  String get deleteSuccess => 'Attendance deleted successfully';

  @override
  String get deleteFailed => 'Failed to delete attendance';

  @override
  String get entryTime => 'Check In: ';

  @override
  String get exitTime => 'Check Out: ';

  @override
  String get statisticTitle => 'Attendance Statistic';

  @override
  String get totalAbsent => 'Total Absent';

  @override
  String get totalPresent => 'Total Present';

  @override
  String get totalPermission => 'Total Permission';

  @override
  String get attendanceToday => 'Attendance Today';

  @override
  String get yes => 'Yes';

  @override
  String get notYet => 'Not Yet';

  @override
  String get permissionTitle => 'Leave Request';

  @override
  String get permissionForm => 'Leave Form';

  @override
  String get date => 'Date';

  @override
  String get pickDate => 'Pick Date';

  @override
  String get reason => 'Reason';

  @override
  String get reasonHint => 'Enter leave reason';

  @override
  String get reasonRequired => 'Reason is required';

  @override
  String get submitPermission => 'Submit Request';

  @override
  String get submitting => 'Submitting...';

  @override
  String get myPermissionList => 'My Requests';

  @override
  String get noPermissionData => 'No leave data';

  @override
  String get reasonLabel => 'Reason: ';

  @override
  String get fillDateReason => 'Complete date & reason';

  @override
  String get permissionSuccess => 'Leave request submitted successfully';

  @override
  String get permissionFailed => 'Failed to submit request';

  @override
  String get loadingMessage => 'Loading...';

  @override
  String get appDescription =>
      'This application is made to facilitate the attendance process and recording presence with a modern Material You based interface.';

  @override
  String get developerInfo => 'Developer Info';

  @override
  String appVersion(Object version) {
    return 'Version $version';
  }

  @override
  String get editProfileTitle => 'Edit Profile';

  @override
  String get fullName => 'Full Name';

  @override
  String get nameRequired => 'Name cannot be empty';

  @override
  String get saveName => 'Save Name';

  @override
  String get photoUpdated => 'Profile photo updated successfully';

  @override
  String uploadFailed(Object error) {
    return 'Failed to upload photo: $error';
  }

  @override
  String get updateNameSuccess => 'Name updated successfully';

  @override
  String updateNameFailed(Object error) {
    return 'Failed to update name: $error';
  }

  @override
  String get registerTitle => 'Register Presensi Kita';

  @override
  String get passwordMismatch => 'Password and confirmation do not match';

  @override
  String get chooseTrainingBatch => 'Choose Training and Batch first';

  @override
  String get chooseGender => 'Choose gender first';

  @override
  String get registerSuccess => 'Registration successful!';

  @override
  String get registerFailed => 'Registration failed';

  @override
  String get emailRequired => 'E-mail is required';

  @override
  String get genderLabel => 'Gender';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderRequired => 'Gender must be chosen';

  @override
  String get trainingLabel => 'Choose Training';

  @override
  String get trainingRequired => 'Training must be chosen';

  @override
  String get batchLabel => 'Choose Batch';

  @override
  String get batchRequired => 'Batch must be chosen';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get confirmPasswordLabel => 'Confirm Password';

  @override
  String get confirmPasswordRequired => 'Confirmation is required';

  @override
  String get back => 'Back';

  @override
  String get register => 'Register';

  @override
  String get haveAccount => 'Already have an account? ';

  @override
  String get loginHere => 'Login here';

  @override
  String get statusNotYet => 'Not Present Yet';

  @override
  String get welcomeGreet => 'Welcome, ';

  @override
  String get attendanceLocation => 'Attendance Location';

  @override
  String get fetchingLocation => 'Fetching location...';

  @override
  String distanceTo(Object distance) {
    return 'Your distance to PPKDJP: $distance';
  }

  @override
  String get addressNotFound => 'Address not found';

  @override
  String get chooseDate => 'Choose Date';

  @override
  String get languageId => 'Indonesian';

  @override
  String get languageEn => 'English';

  @override
  String get forgotPasswordTitle => 'Reset Password';

  @override
  String get otpLabel => 'OTP Code';

  @override
  String get otpEmpty => 'OTP cannot be empty';

  @override
  String get newPasswordLabel => 'New Password';

  @override
  String get otpSuccess => 'OTP sent successfully';

  @override
  String otpFailed(Object error) {
    return 'Failed to send OTP: $error';
  }

  @override
  String get resetPasswordSuccess => 'Password updated successfully';

  @override
  String resetPasswordFailed(Object error) {
    return 'Failed to reset password: $error';
  }

  @override
  String get resetPasswordButton => 'Reset Password';

  @override
  String get sendOtpButton => 'Send OTP';
}
