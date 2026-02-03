import 'package:flutter/material.dart';

class AppTheme {
  // 메인 컬러
  static const Color primary = Color(0xFF1E88E5);
  static const Color secondary = Color(0xFF42A5F5);
  static const Color accent = Color(0xFFFF6F00);
  
  // 다크 모드 컬러
  static const Color darkPrimary = Color(0xFF1976D2);
  static const Color darkSecondary = Color(0xFF1E88E5);
  static const Color darkAccent = Color(0xFFFF8A65);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);

  // 라이트 테마
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
      ),
      
      appBarTheme: const AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 26,
        ),
      ),
      
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.grey[100],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: TextStyle(
          color: Colors.grey[400],
          fontSize: 16,
        ),
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 58, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(fontSize: 47, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        headlineSmall: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        bodyLarge: TextStyle(fontSize: 18),
        bodyMedium: TextStyle(fontSize: 16),
        bodySmall: TextStyle(fontSize: 14),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        labelSmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      ),
      
      iconTheme: const IconThemeData(
        size: 26,
        color: Colors.black87,
      ),
      
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        minLeadingWidth: 45,
        iconColor: primary,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 15,
          color: Colors.black54,
        ),
      ),
      
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 13,
        ),
        selectedIconTheme: IconThemeData(
          size: 30,
        ),
        unselectedIconTheme: IconThemeData(
          size: 26,
        ),
      ),
    );
  }

  // 다크 테마
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: darkPrimary,
        brightness: Brightness.dark,
        background: darkBackground,
        surface: darkSurface,
      ),
      scaffoldBackgroundColor: darkBackground,
      
      appBarTheme: const AppBarTheme(
        backgroundColor: darkSurface,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
          size: 26,
        ),
      ),
      
      cardTheme: CardThemeData(
        elevation: 2,
        color: darkCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkPrimary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkAccent,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[700]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkPrimary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: TextStyle(
          color: Colors.grey[600],
          fontSize: 16,
        ),
        labelStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.white70,
        ),
      ),
      
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 58, fontWeight: FontWeight.bold, color: Colors.white),
        displayMedium: TextStyle(fontSize: 47, fontWeight: FontWeight.bold, color: Colors.white),
        displaySmall: TextStyle(fontSize: 38, fontWeight: FontWeight.bold, color: Colors.white),
        headlineLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: Colors.white),
        headlineMedium: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
        headlineSmall: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: Colors.white),
        titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
        titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
        titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white70),
        bodyLarge: TextStyle(fontSize: 18, color: Colors.white),
        bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
        bodySmall: TextStyle(fontSize: 14, color: Colors.white60),
        labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white70),
        labelSmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white60),
      ),
      
      iconTheme: const IconThemeData(
        size: 26,
        color: Colors.white70,
      ),
      
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        minLeadingWidth: 45,
        iconColor: darkPrimary,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 15,
          color: Colors.white60,
        ),
      ),
      
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: darkSurface,
        selectedItemColor: darkPrimary,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13,
        ),
        selectedIconTheme: const IconThemeData(
          size: 30,
        ),
        unselectedIconTheme: const IconThemeData(
          size: 26,
        ),
      ),
    );
  }
}
