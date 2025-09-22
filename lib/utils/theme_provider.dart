import 'package:absensi_ppkdjp_b3/preference/shared_preference.dart';
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider();

  // Digunakan untuk mengatur tema sebelum runApp
  void setInitialTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }

  void toggleTheme(bool isDark) {
    _isDarkMode = isDark;
    PreferenceHandler.saveThemeMode(_isDarkMode);
    notifyListeners();
  }
}
