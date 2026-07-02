import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── Brand Colors ────────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF0D7377);
  static const Color primaryDark = Color(0xFF0A5C60);
  static const Color primaryLight = Color(0xFF14A085);
  static const Color accent = Color(0xFF32E0C4);
  static const Color accentLight = Color(0xFFB2EDE7);

  static const Color backgroundLight = Color(0xFFF8FFFE);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF0FAF9);
  static const Color cardBackground = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF1A2E35);
  static const Color textSecondary = Color(0xFF4A6572);
  static const Color textMuted = Color(0xFF8EAAB3);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static const Color divider = Color(0xFFE2F0EF);
  static const Color shadow = Color(0x1A0D7377);

  // ─── Gradients ───────────────────────────────────────────────────────────────
  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0D7377), Color(0xFF14A085), Color(0xFF1DBF73)],
    stops: [0.0, 0.55, 1.0],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFFFFF), Color(0xFFF0FAF9)],
  );

  static const LinearGradient adminGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0A5C60), Color(0xFF0D7377)],
  );

  // ─── ThemeData ───────────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: accent,
        surface: surface,
        error: error,
        onPrimary: textOnPrimary,
        onSurface: textPrimary,
      ),
      scaffoldBackgroundColor: backgroundLight,
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 56,
          fontWeight: FontWeight.w800,
          color: textOnPrimary,
          letterSpacing: -1.5,
          height: 1.1,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 40,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -1.0,
          height: 1.2,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          color: textSecondary,
          height: 1.6,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          color: textSecondary,
          height: 1.5,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          color: textMuted,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: shadow,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
        iconTheme: const IconThemeData(color: textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: textOnPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: GoogleFonts.inter(color: textSecondary, fontSize: 14),
        hintStyle: GoogleFonts.inter(color: textMuted, fontSize: 14),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: cardBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: divider),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: accentLight,
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: primaryDark,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
