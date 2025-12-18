import 'package:absensi_ppkdjp_b3/extension/navigation.dart';
import 'package:absensi_ppkdjp_b3/l10n/app_localizations.dart';
import 'package:absensi_ppkdjp_b3/services/history_pdf_export_service.dart';
import 'package:absensi_ppkdjp_b3/services/notification_service.dart';
import 'package:absensi_ppkdjp_b3/utils/locale_provider.dart';
import 'package:absensi_ppkdjp_b3/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPresensi extends StatefulWidget {
  const SettingsPresensi({super.key});

  @override
  State<SettingsPresensi> createState() => _SettingsPresensiState();
}

class _SettingsPresensiState extends State<SettingsPresensi> {
  TimeOfDay? _scheduledTime;
  bool _isReminderEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadScheduledTime();
  }

  Future<void> _loadScheduledTime() async {
    final service = NotificationService();
    final time = await service.getScheduledTime();
    final enabled = await service.isReminderEnabled();
    setState(() {
      _scheduledTime = time;
      _isReminderEnabled = enabled;
    });
  }

  Future<void> _pickTime() async {
    if (!_isReminderEnabled) return;

    final picked = await showTimePicker(
      context: context,
      initialTime: _scheduledTime ?? const TimeOfDay(hour: 6, minute: 0),
    );

    if (picked != null) {
      final msg = await NotificationService().scheduleDailyNotification(
        time: picked,
      );

      setState(() {
        _scheduledTime = picked;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), duration: const Duration(seconds: 4)),
        );
      }
    }
  }

  Future<void> _toggleReminder(bool value) async {
    final service = NotificationService();

    // Optimistic UI Update: change state immediately
    setState(() {
      _isReminderEnabled = value;
    });

    try {
      if (value) {
        await service.requestPermissions();
      }
      await service.setReminderEnabled(value);
      final msg = await service.scheduleDailyNotification();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), duration: const Duration(seconds: 2)),
        );
      }
    } catch (e) {
      // Revert if failed
      setState(() {
        _isReminderEnabled = !value;
      });
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Gagal: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final localeProvider = Provider.of<LocaleProvider>(context);
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: scheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: scheme.primaryContainer,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: scheme.onPrimaryContainer),
        surfaceTintColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // 🔹 Tema
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 1,
            child: ListTile(
              leading: Icon(Icons.color_lens, color: scheme.primary),
              title: Text(AppLocalizations.of(context)!.theme),
              subtitle: Text(
                _getThemeText(
                  themeProvider.themeMode,
                  AppLocalizations.of(context)!,
                ),
              ),
              trailing: DropdownButton<ThemeMode>(
                value: themeProvider.themeMode,
                underline: const SizedBox(),
                onChanged: (mode) {
                  if (mode != null) themeProvider.setThemeMode(mode);
                },
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text(AppLocalizations.of(context)!.themeSystem),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text(AppLocalizations.of(context)!.themeLight),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text(AppLocalizations.of(context)!.themeDark),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 🔹 Bahasa / Language
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 1,
            child: ListTile(
              leading: Icon(Icons.g_translate, color: scheme.primary),
              title: Text(AppLocalizations.of(context)!.languageSettingsTitle),
              subtitle: Text(
                _getLanguageText(
                  localeProvider.locale,
                  AppLocalizations.of(context)!,
                ),
              ),
              trailing: DropdownButton<Locale>(
                value: localeProvider.locale, // null is System
                underline: const SizedBox(),
                onChanged: (locale) {
                  localeProvider.setLocale(locale);
                },
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text(AppLocalizations.of(context)!.themeSystem),
                  ),
                  DropdownMenuItem(
                    value: Locale('id'),
                    child: Text(AppLocalizations.of(context)!.languageId),
                  ),
                  DropdownMenuItem(
                    value: Locale('en'),
                    child: Text(AppLocalizations.of(context)!.languageEn),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 🔹 Notifikasi Section
          Text(
            AppLocalizations.of(context)!.notification,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 8),

          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 1,
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.alarm,
                    color: _isReminderEnabled ? scheme.primary : Colors.grey,
                  ),
                  title: Text(AppLocalizations.of(context)!.dailyReminder),
                  subtitle: Text(
                    _isReminderEnabled
                        ? (_scheduledTime != null
                              ? AppLocalizations.of(context)!.dailyReminderTime(
                                  _scheduledTime!.format(context),
                                )
                              : AppLocalizations.of(context)!.loading)
                        : AppLocalizations.of(context)!.reminderOff,
                  ),
                  onTap: _isReminderEnabled ? _pickTime : null,
                  trailing: Switch(
                    value: _isReminderEnabled,
                    onChanged: _toggleReminder,
                    activeThumbColor: scheme.primary,
                  ),
                ),
                if (_isReminderEnabled)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          NotificationService().showTestNotification(),
                      icon: const Icon(Icons.notifications_active, size: 18),
                      label: Text(
                        AppLocalizations.of(context)!.testNotificationButton,
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 40),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // 🔹 Ekspor Data
          Text(
            AppLocalizations.of(context)!.dataTitle,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: scheme.primary,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 1,
            child: ListTile(
              leading: Icon(Icons.picture_as_pdf, color: scheme.primary),
              title: Text(AppLocalizations.of(context)!.exportHistory),
              subtitle: Text(
                AppLocalizations.of(context)!.exportHistorySubtitle,
              ),
              onTap: () => HistoryPdfExportService.exportHistory(context),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: scheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 30),

          // 🔹 Tombol simpan
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: scheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context)!.successSave),
                  ),
                );
                context.pop();
              },
              child: Text(
                AppLocalizations.of(context)!.save,
                style: TextStyle(
                  color: scheme.onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getLanguageText(Locale? locale, AppLocalizations l10n) {
    if (locale == null) return l10n.themeSystem;
    if (locale.languageCode == 'id') return l10n.languageId;
    if (locale.languageCode == 'en') return l10n.languageEn;
    return l10n.themeSystem;
  }

  String _getThemeText(ThemeMode mode, AppLocalizations l10n) {
    switch (mode) {
      case ThemeMode.light:
        return l10n.themeLight;
      case ThemeMode.dark:
        return l10n.themeDark;
      case ThemeMode.system:
        return l10n.themeSystem;
    }
  }
}
