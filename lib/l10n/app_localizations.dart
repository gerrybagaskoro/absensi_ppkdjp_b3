import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get language;

  /// No description provided for @languageSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettingsTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @exportHistory.
  ///
  /// In en, this message translates to:
  /// **'Export Attendance History'**
  String get exportHistory;

  /// No description provided for @aboutApp.
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get confirmLogout;

  /// No description provided for @yesLogout.
  ///
  /// In en, this message translates to:
  /// **'Yes, Logout'**
  String get yesLogout;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'App Theme'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystem;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @dailyReminder.
  ///
  /// In en, this message translates to:
  /// **'Daily Reminder'**
  String get dailyReminder;

  /// No description provided for @dailyReminderDesc.
  ///
  /// In en, this message translates to:
  /// **'Reminder to clock in daily'**
  String get dailyReminderDesc;

  /// No description provided for @successSave.
  ///
  /// In en, this message translates to:
  /// **'Settings saved successfully'**
  String get successSave;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Easy Attendance'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Clock in and out easily directly from your smartphone.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Realtime History'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Monitor your attendance history in realtime.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Detailed Reports'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Get detailed attendance reports anytime.'**
  String get onboardingDesc3;

  /// No description provided for @onboardingDesc4.
  ///
  /// In en, this message translates to:
  /// **'Ready for digital attendance? Let\'s get started!'**
  String get onboardingDesc4;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back!'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Please login to continue'**
  String get loginSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get loginButton;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @clockIn.
  ///
  /// In en, this message translates to:
  /// **'Clock In'**
  String get clockIn;

  /// No description provided for @clockOut.
  ///
  /// In en, this message translates to:
  /// **'Clock Out'**
  String get clockOut;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get greetingEvening;

  /// No description provided for @greetingNight.
  ///
  /// In en, this message translates to:
  /// **'Good Night'**
  String get greetingNight;

  /// No description provided for @loginTitleHeader.
  ///
  /// In en, this message translates to:
  /// **'Login to Attendance'**
  String get loginTitleHeader;

  /// No description provided for @emailEmpty.
  ///
  /// In en, this message translates to:
  /// **'Email cannot be empty'**
  String get emailEmpty;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid E-mail format'**
  String get emailInvalid;

  /// No description provided for @passwordEmpty.
  ///
  /// In en, this message translates to:
  /// **'Password cannot be empty'**
  String get passwordEmpty;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'At least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @noAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get noAccount;

  /// No description provided for @registerAction.
  ///
  /// In en, this message translates to:
  /// **'Register here'**
  String get registerAction;

  /// No description provided for @forgotPasswordPrompt.
  ///
  /// In en, this message translates to:
  /// **'Forgot password? '**
  String get forgotPasswordPrompt;

  /// No description provided for @resetAction.
  ///
  /// In en, this message translates to:
  /// **'Reset here'**
  String get resetAction;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading'**
  String get loading;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful!'**
  String get loginSuccess;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @loginInvalidData.
  ///
  /// In en, this message translates to:
  /// **'Invalid login data from server'**
  String get loginInvalidData;

  /// No description provided for @loginError.
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String loginError(String error);

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Presensi Kita'**
  String get appName;

  /// No description provided for @statistic.
  ///
  /// In en, this message translates to:
  /// **'Statistic'**
  String get statistic;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @excused.
  ///
  /// In en, this message translates to:
  /// **'Excused'**
  String get excused;

  /// No description provided for @permission.
  ///
  /// In en, this message translates to:
  /// **'Leave Request'**
  String get permission;

  /// No description provided for @todayStatus.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Status'**
  String get todayStatus;

  /// No description provided for @notPresent.
  ///
  /// In en, this message translates to:
  /// **'Not Present'**
  String get notPresent;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check In'**
  String get checkIn;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get checkOut;

  /// No description provided for @reasonPermission.
  ///
  /// In en, this message translates to:
  /// **'Permission Reason: '**
  String get reasonPermission;

  /// No description provided for @permissionToday.
  ///
  /// In en, this message translates to:
  /// **'📌 You have permission today'**
  String get permissionToday;

  /// No description provided for @farLocation.
  ///
  /// In en, this message translates to:
  /// **'⚠️ You are far from PPKDJP location'**
  String get farLocation;

  /// No description provided for @alreadyPresent.
  ///
  /// In en, this message translates to:
  /// **'✅ You have clocked in & out today'**
  String get alreadyPresent;

  /// No description provided for @locationNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Location not available'**
  String get locationNotAvailable;

  /// No description provided for @checkInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Check In successful'**
  String get checkInSuccess;

  /// No description provided for @checkInFailed.
  ///
  /// In en, this message translates to:
  /// **'Check In failed'**
  String get checkInFailed;

  /// No description provided for @checkOutSuccess.
  ///
  /// In en, this message translates to:
  /// **'Check Out successful'**
  String get checkOutSuccess;

  /// No description provided for @checkOutFailed.
  ///
  /// In en, this message translates to:
  /// **'Check Out failed'**
  String get checkOutFailed;

  /// No description provided for @checkInError.
  ///
  /// In en, this message translates to:
  /// **'Error occurred: {error}'**
  String checkInError(String error);

  /// No description provided for @statusNotPresent.
  ///
  /// In en, this message translates to:
  /// **'Not Present'**
  String get statusNotPresent;

  /// No description provided for @statusPresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get statusPresent;

  /// No description provided for @statusLate.
  ///
  /// In en, this message translates to:
  /// **'Late'**
  String get statusLate;

  /// No description provided for @statusPermission.
  ///
  /// In en, this message translates to:
  /// **'Excused'**
  String get statusPermission;

  /// No description provided for @statusAbsent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get statusAbsent;

  /// No description provided for @dataTitle.
  ///
  /// In en, this message translates to:
  /// **'Data'**
  String get dataTitle;

  /// No description provided for @exportHistorySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Download attendance history in PDF format'**
  String get exportHistorySubtitle;

  /// No description provided for @dailyReminderTime.
  ///
  /// In en, this message translates to:
  /// **'Every day at {time}'**
  String dailyReminderTime(Object time);

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirm;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirm;

  /// No description provided for @logoutSuccess.
  ///
  /// In en, this message translates to:
  /// **'You have logged out.'**
  String get logoutSuccess;

  /// No description provided for @noName.
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get noName;

  /// No description provided for @noEmail.
  ///
  /// In en, this message translates to:
  /// **'No email'**
  String get noEmail;

  /// No description provided for @batch.
  ///
  /// In en, this message translates to:
  /// **'Batch'**
  String get batch;

  /// No description provided for @training.
  ///
  /// In en, this message translates to:
  /// **'Training: '**
  String get training;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance History'**
  String get historyTitle;

  /// No description provided for @holdToDelete.
  ///
  /// In en, this message translates to:
  /// **'Long press to delete attendance'**
  String get holdToDelete;

  /// No description provided for @allDates.
  ///
  /// In en, this message translates to:
  /// **'All Dates'**
  String get allDates;

  /// No description provided for @pickDateRange.
  ///
  /// In en, this message translates to:
  /// **'Pick date range'**
  String get pickDateRange;

  /// No description provided for @resetFilter.
  ///
  /// In en, this message translates to:
  /// **'Reset filter'**
  String get resetFilter;

  /// No description provided for @filterReset.
  ///
  /// In en, this message translates to:
  /// **'Date filter reset'**
  String get filterReset;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No attendance data'**
  String get noHistory;

  /// No description provided for @deleteAttendance.
  ///
  /// In en, this message translates to:
  /// **'Delete Attendance'**
  String get deleteAttendance;

  /// No description provided for @deleteAttendanceConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this attendance?'**
  String get deleteAttendanceConfirm;

  /// No description provided for @deleteSuccess.
  ///
  /// In en, this message translates to:
  /// **'Attendance deleted successfully'**
  String get deleteSuccess;

  /// No description provided for @deleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete attendance'**
  String get deleteFailed;

  /// No description provided for @entryTime.
  ///
  /// In en, this message translates to:
  /// **'Check In: '**
  String get entryTime;

  /// No description provided for @exitTime.
  ///
  /// In en, this message translates to:
  /// **'Check Out: '**
  String get exitTime;

  /// No description provided for @statisticTitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance Statistic'**
  String get statisticTitle;

  /// No description provided for @totalAbsent.
  ///
  /// In en, this message translates to:
  /// **'Total Absent'**
  String get totalAbsent;

  /// No description provided for @totalPresent.
  ///
  /// In en, this message translates to:
  /// **'Total Present'**
  String get totalPresent;

  /// No description provided for @totalPermission.
  ///
  /// In en, this message translates to:
  /// **'Total Permission'**
  String get totalPermission;

  /// No description provided for @attendanceToday.
  ///
  /// In en, this message translates to:
  /// **'Attendance Today'**
  String get attendanceToday;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @notYet.
  ///
  /// In en, this message translates to:
  /// **'Not Yet'**
  String get notYet;

  /// No description provided for @permissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave Request'**
  String get permissionTitle;

  /// No description provided for @permissionForm.
  ///
  /// In en, this message translates to:
  /// **'Leave Form'**
  String get permissionForm;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @pickDate.
  ///
  /// In en, this message translates to:
  /// **'Pick Date'**
  String get pickDate;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Reason'**
  String get reason;

  /// No description provided for @reasonHint.
  ///
  /// In en, this message translates to:
  /// **'Enter leave reason'**
  String get reasonHint;

  /// No description provided for @reasonRequired.
  ///
  /// In en, this message translates to:
  /// **'Reason is required'**
  String get reasonRequired;

  /// No description provided for @submitPermission.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitPermission;

  /// No description provided for @submitting.
  ///
  /// In en, this message translates to:
  /// **'Submitting...'**
  String get submitting;

  /// No description provided for @myPermissionList.
  ///
  /// In en, this message translates to:
  /// **'My Requests'**
  String get myPermissionList;

  /// No description provided for @noPermissionData.
  ///
  /// In en, this message translates to:
  /// **'No leave data'**
  String get noPermissionData;

  /// No description provided for @reasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Reason: '**
  String get reasonLabel;

  /// No description provided for @fillDateReason.
  ///
  /// In en, this message translates to:
  /// **'Complete date & reason'**
  String get fillDateReason;

  /// No description provided for @permissionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Leave request submitted successfully'**
  String get permissionSuccess;

  /// No description provided for @permissionFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit request'**
  String get permissionFailed;

  /// No description provided for @loadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingMessage;

  /// No description provided for @appDescription.
  ///
  /// In en, this message translates to:
  /// **'This application is made to facilitate the attendance process and recording presence with a modern Material You based interface.'**
  String get appDescription;

  /// No description provided for @developerInfo.
  ///
  /// In en, this message translates to:
  /// **'Developer Info'**
  String get developerInfo;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersion(Object version);

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfileTitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name cannot be empty'**
  String get nameRequired;

  /// No description provided for @saveName.
  ///
  /// In en, this message translates to:
  /// **'Save Name'**
  String get saveName;

  /// No description provided for @photoUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile photo updated successfully'**
  String get photoUpdated;

  /// No description provided for @uploadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload photo: {error}'**
  String uploadFailed(Object error);

  /// No description provided for @updateNameSuccess.
  ///
  /// In en, this message translates to:
  /// **'Name updated successfully'**
  String get updateNameSuccess;

  /// No description provided for @updateNameFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to update name: {error}'**
  String updateNameFailed(Object error);

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Register Presensi Kita'**
  String get registerTitle;

  /// No description provided for @passwordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Password and confirmation do not match'**
  String get passwordMismatch;

  /// No description provided for @chooseTrainingBatch.
  ///
  /// In en, this message translates to:
  /// **'Choose Training and Batch first'**
  String get chooseTrainingBatch;

  /// No description provided for @chooseGender.
  ///
  /// In en, this message translates to:
  /// **'Choose gender first'**
  String get chooseGender;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Registration successful!'**
  String get registerSuccess;

  /// No description provided for @registerFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registerFailed;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'E-mail is required'**
  String get emailRequired;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderLabel;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderRequired.
  ///
  /// In en, this message translates to:
  /// **'Gender must be chosen'**
  String get genderRequired;

  /// No description provided for @trainingLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose Training'**
  String get trainingLabel;

  /// No description provided for @trainingRequired.
  ///
  /// In en, this message translates to:
  /// **'Training must be chosen'**
  String get trainingRequired;

  /// No description provided for @batchLabel.
  ///
  /// In en, this message translates to:
  /// **'Choose Batch'**
  String get batchLabel;

  /// No description provided for @batchRequired.
  ///
  /// In en, this message translates to:
  /// **'Batch must be chosen'**
  String get batchRequired;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirmation is required'**
  String get confirmPasswordRequired;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @haveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get haveAccount;

  /// No description provided for @loginHere.
  ///
  /// In en, this message translates to:
  /// **'Login here'**
  String get loginHere;

  /// No description provided for @statusNotYet.
  ///
  /// In en, this message translates to:
  /// **'Not Present Yet'**
  String get statusNotYet;

  /// No description provided for @welcomeGreet.
  ///
  /// In en, this message translates to:
  /// **'Welcome, '**
  String get welcomeGreet;

  /// No description provided for @attendanceLocation.
  ///
  /// In en, this message translates to:
  /// **'Attendance Location'**
  String get attendanceLocation;

  /// No description provided for @fetchingLocation.
  ///
  /// In en, this message translates to:
  /// **'Fetching location...'**
  String get fetchingLocation;

  /// No description provided for @distanceTo.
  ///
  /// In en, this message translates to:
  /// **'Your distance to PPKDJP: {distance}'**
  String distanceTo(Object distance);

  /// No description provided for @addressNotFound.
  ///
  /// In en, this message translates to:
  /// **'Address not found'**
  String get addressNotFound;

  /// No description provided for @chooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose Date'**
  String get chooseDate;

  /// No description provided for @languageId.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get languageId;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @forgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get forgotPasswordTitle;

  /// No description provided for @otpLabel.
  ///
  /// In en, this message translates to:
  /// **'OTP Code'**
  String get otpLabel;

  /// No description provided for @otpEmpty.
  ///
  /// In en, this message translates to:
  /// **'OTP cannot be empty'**
  String get otpEmpty;

  /// No description provided for @newPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordLabel;

  /// No description provided for @otpSuccess.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully'**
  String get otpSuccess;

  /// No description provided for @otpFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to send OTP: {error}'**
  String otpFailed(Object error);

  /// No description provided for @resetPasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get resetPasswordSuccess;

  /// No description provided for @resetPasswordFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to reset password: {error}'**
  String resetPasswordFailed(Object error);

  /// No description provided for @resetPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordButton;

  /// No description provided for @sendOtpButton.
  ///
  /// In en, this message translates to:
  /// **'Send OTP'**
  String get sendOtpButton;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
