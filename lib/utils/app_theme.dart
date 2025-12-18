import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData get lightTheme {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: Colors.orange,
      brightness: Brightness.light,
    );

    final colorScheme = baseScheme.copyWith(
      primary: Colors.orange.shade500, // tombol & fokus utama
      secondary: Colors.amber.shade400, // aksen berbeda
      primaryContainer: Colors.orange.shade200, // AppBar soft tapi tetap hangat
      surface: Colors.grey[50]!, // background lebih netral
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.poppinsTextTheme(),

      // Background aplikasi
      scaffoldBackgroundColor: colorScheme.surface,

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),

      // BottomNav
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
      ),

      // Card biar kontras dengan background
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // Input field
      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: colorScheme.onSurface),
        floatingLabelStyle: TextStyle(color: colorScheme.primary),
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: colorScheme.outline, width: 1.5),
        ),
        filled: true,
        fillColor: Colors.white, // biar beda dengan scaffold bg
      ),
    );
  }

  static ThemeData get darkTheme {
    final baseScheme = ColorScheme.fromSeed(
      seedColor: Colors.orange,
      brightness: Brightness.dark,
    );

    final colorScheme = baseScheme.copyWith(
      primary: Colors.orange.shade300, // tombol & fokus utama
      secondary: Colors.amber.shade300, // aksen berbeda
      primaryContainer: Colors.orange.shade600, // AppBar dark tapi tidak berat
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),

      scaffoldBackgroundColor: colorScheme.surface,

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 0,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
        ),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
      ),

      inputDecorationTheme: InputDecorationTheme(
        labelStyle: TextStyle(color: colorScheme.onSurface),
        floatingLabelStyle: TextStyle(color: colorScheme.primary),
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: colorScheme.outline, width: 1.5),
        ),
        filled: true,
        fillColor: colorScheme.surfaceContainerHighest,
      ),
    );
  }
}
