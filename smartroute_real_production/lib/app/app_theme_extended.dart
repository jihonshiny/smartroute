import 'package:flutter/material.dart';

class AppThemeExtended {
  // Colors
  static const Color primary = Color(0xFF3A86FF);
  static const Color accent = Color(0xFF06D6A0);
  static const Color text = Color(0xFF111111);
  static const Color subtext = Color(0xFF6B7280);
  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFAFAFA);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(colors: [primary, Color(0xFF2666CC)]);
  static const LinearGradient accentGradient = LinearGradient(colors: [accent, Color(0xFF04A675)]);
  static const LinearGradient successGradient = LinearGradient(colors: [success, Color(0xFF059669)]);

  // Shadows
  static List<BoxShadow> get cardShadow => [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 4))];
  static List<BoxShadow> get buttonShadow => [BoxShadow(color: primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))];

  // Border Radius
  static const BorderRadius smallRadius = BorderRadius.all(Radius.circular(8));
  static const BorderRadius mediumRadius = BorderRadius.all(Radius.circular(12));
  static const BorderRadius largeRadius = BorderRadius.all(Radius.circular(16));
  static const BorderRadius xlRadius = BorderRadius.all(Radius.circular(20));

  // Padding
  static const EdgeInsets smallPadding = EdgeInsets.all(8);
  static const EdgeInsets mediumPadding = EdgeInsets.all(16);
  static const EdgeInsets largePadding = EdgeInsets.all(24);

  // Text Styles
  static const TextStyle headline1 = TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: text);
  static const TextStyle headline2 = TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: text);
  static const TextStyle headline3 = TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: text);
  static const TextStyle body1 = TextStyle(fontSize: 16, color: text);
  static const TextStyle body2 = TextStyle(fontSize: 14, color: subtext);
  static const TextStyle caption = TextStyle(fontSize: 12, color: subtext);

  static ThemeData get lightTheme => ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme.fromSeed(seedColor: primary, brightness: Brightness.light),
    appBarTheme: const AppBarTheme(backgroundColor: background, foregroundColor: text, elevation: 0),
  );
}
