import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _timeKey = 'daily_reminder_time';
  static const String _enabledKey = 'daily_reminder_enabled';
  // V3: New channel ID to ensure fresh settings (Importance.max, Alarm Category)
  static const String _channelId = 'daily_reminder_v3';

  Future<void> init() async {
    // 1. Initialize Timezone Database
    tz.initializeTimeZones();

    // 2. Set Location using REAL device timezone
    try {
      final timeZoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timeZoneName.toString()));
      debugPrint("Timezone initialized: $timeZoneName");
    } catch (e) {
      debugPrint("Failed to set timezone: $e");
      // Fallback to Jakarta if detection fails
      try {
        tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
      } catch (_) {}
    }

    // 3. Android Initialize
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // 4. iOS Initialize
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: true,
          requestAlertPermission: true,
        );

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) async {
        debugPrint('Notification clicked: ${response.payload}');
      },
    );
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid) {
      final androidImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();

      final bool? result = await androidImplementation
          ?.requestNotificationsPermission();
      debugPrint('Notification permission granted: $result');
    } else if (Platform.isIOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >()
          ?.requestPermissions(alert: true, badge: true, sound: true);
    }
  }

  // Returns a diagnostic message to display to the user
  Future<String> scheduleDailyNotification({TimeOfDay? time}) async {
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool(_enabledKey) ?? false;

    // 1. If disabled, just cancel and return
    if (!isEnabled && time == null) {
      await flutterLocalNotificationsPlugin.cancel(0);
      return "Pengingat dinonaktifkan";
    }

    // 2. Handle Permission for Exact Alarms (Android 12+)
    if (Platform.isAndroid) {
      final androidImplementation = flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      await androidImplementation?.requestExactAlarmsPermission();
    }

    // 3. Persist Time
    if (time != null) {
      final timeString = '${time.hour}:${time.minute}';
      await prefs.setString(_timeKey, timeString);
      // Automatically enable if time is picked? Usually yes, or at least ensure it's on if we want it to work.
      await prefs.setBool(_enabledKey, true);
    }

    // Double check if enabled again after potential time pick
    final finalEnabled = prefs.getBool(_enabledKey) ?? false;
    if (!finalEnabled) {
      await flutterLocalNotificationsPlugin.cancel(0);
      return "Pengingat dinonaktifkan";
    }

    // 4. Load Time (default 07:00)
    final savedTimeStr = prefs.getString(_timeKey) ?? "7:0";
    final parts = savedTimeStr.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    // 5. Cancel Old
    await flutterLocalNotificationsPlugin.cancel(0);

    // 6. Calculate Next Data
    final scheduledDate = _nextInstanceOfTime(hour, minute);

    // 7. Schedule
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0, // ID
        'Ayo Absen!',
        'Jangan lupa absen sebelum jam 08:00 pagi agar tidak terlambat.',
        scheduledDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            'Daily Reminder',
            channelDescription: 'Reminder to clock in every morning',
            importance: Importance.max,
            priority: Priority.high,
            category: AndroidNotificationCategory.alarm,
            ticker: 'Waktunya Absen!',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            interruptionLevel: InterruptionLevel.critical,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      final logMsg =
          "Jadwal: ${scheduledDate.hour.toString().padLeft(2, '0')}:${scheduledDate.minute.toString().padLeft(2, '0')}";
      debugPrint("Scheduled for: $logMsg");
      return "Berhasil diatur untuk jam $logMsg";
    } catch (e) {
      debugPrint("Error scheduling: $e");
      return "Gagal mengatur notifikasi: $e";
    }
  }

  Future<void> showTestNotification() async {
    // 1. Request permissions first
    await requestPermissions();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          _channelId,
          'Test Notifications',
          channelDescription: 'Used to verify notification functionality',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'Tes Notifikasi',
          category: AndroidNotificationCategory.status,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      999,
      'Tes Notifikasi Berhasil! ✅',
      'Ini adalah contoh notifikasi dari Presensi Kita.',
      platformChannelSpecifics,
    );
  }

  Future<bool> isReminderEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_enabledKey) ?? false;
  }

  Future<void> setReminderEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, enabled);
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    // Current time in configured location
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    // If schedule is in the past for today, move to tomorrow
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<TimeOfDay> getScheduledTime() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTimeStr = prefs.getString(_timeKey) ?? "7:0";
    final parts = savedTimeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
