import 'package:flutter/material.dart';

/// Warm paper, ink, and one copper accent. Screens share this theme.
ThemeData shelfTheme() {
  const ink = Color(0xFF141210);
  const paper = Color(0xFFF7F4EF);
  const card = Color(0xFFFFFCF8);
  const line = Color(0xFFE7E0D6);
  const accent = Color(0xFF8C3A2F);
  const muted = Color(0xFF6F655C);

  final scheme = ColorScheme.light(
    primary: accent,
    onPrimary: Colors.white,
    secondary: const Color(0xFF3D5A4C),
    surface: card,
    onSurface: ink,
    error: const Color(0xFF9B2C2C),
    outline: line,
  );

  final outline = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: line),
  );

  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: paper,
    dividerColor: line,
    progressIndicatorTheme: const ProgressIndicatorThemeData(color: accent),
    dialogTheme: DialogThemeData(
      backgroundColor: card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: line),
      ),
      titleTextStyle: const TextStyle(
        color: ink,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.3,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: paper,
      labelStyle: const TextStyle(color: muted),
      border: outline,
      enabledBorder: outline,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: accent, width: 1.4),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        color: ink,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.6,
      ),
      titleMedium: TextStyle(
        color: ink,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.2,
      ),
      bodyMedium: TextStyle(color: ink, fontSize: 14, height: 1.35),
      bodySmall: TextStyle(color: muted, fontSize: 13),
    ),
  );
}
