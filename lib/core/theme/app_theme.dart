import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Color palette for the app
class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF1F7A5D);
  static const Color primaryLight = Color(0xFF4CAF8D);
  static const Color primaryDark = Color(0xFF005B3F);

  // Secondary colors
  static const Color secondary = Color(0xFFD4AF37);
  static const Color secondaryLight = Color(0xFFFFDF64);
  static const Color secondaryDark = Color(0xFFA08000);

  // Tertiary colors
  static const Color tertiary = Color(0xFF9575CD);

  // Neutral colors (Light mode)
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFB00020);

  // Text colors (Light mode)
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFF9E9E9E);
  static const Color textTertiary = Color(0xFFBDBDBD);
  static const Color lightGrey = Color(0xFFD3D3D3);

  // Dark mode colors
  static const Color darkBackground = Color(0xFF192734);
  static const Color darkSurface = Color(0xFF15202b);
  static const Color darkSurfaceVariant = Color(0xFF22303c);
  static const Color darkPrimary = Color(
    0xFF4CAF8D,
  ); // Using primaryLight for better visibility
  static const Color darkSecondary = Color(
    0xFFFFDF64,
  ); // Using secondaryLight for better visibility

  // Dark mode text colors - improved for better readability
  static const Color darkTextPrimary = Color(
    0xFFFFFFFF,
  ); // Pure white for primary text
  static const Color darkTextSecondary = Color(
    0xFFE0E0E0,
  ); // Lighter gray for better contrast
  static const Color darkTextTertiary = Color(
    0xFFBDBDBD,
  ); // Medium gray for less important text
  static const Color darkTextHint = Color(0xFF9E9E9E); // Brighter hint text
  static const Color darkTextDisabled = Color(0xFF757575); // For disabled text

  static const Color darkDivider = Color(0xFF2C2C2C);
  static const Color darkCardBackground = Color(0xFF15202b);

  // Status colors
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF2196F3);

  // Prayer time colors
  static const Color fajrColor = Color(0xFF81D4FA);
  static const Color dhuhrColor = Color(0xFFFFD54F);
  static const Color asrColor = Color(0xFFFFB74D);
  static const Color maghribColor = Color(0xFFFF8A65);
  static const Color ishaColor = Color(0xFF9575CD);

  // Dark mode prayer time colors (slightly adjusted for dark theme)
  static const Color darkFajrColor = Color(0xFF64B5F6);
  static const Color darkDhuhrColor = Color(0xFFFFD54F);
  static const Color darkAsrColor = Color(0xFFFFB74D);
  static const Color darkMaghribColor = Color(0xFFFF8A65);
  static const Color darkIshaColor = Color(0xFFA78BFA);
}

/// Text styles for the app
class AppTextStyles {
  static TextStyle get headingLarge => GoogleFonts.lato(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    // color: AppColors.textPrimary,
  );

  static TextStyle get headingMedium => GoogleFonts.lato(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    // color: AppColors.textPrimary,
  );

  static TextStyle get headingSmall => GoogleFonts.lato(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    // color: AppColors.textPrimary,
  );

  static TextStyle get bodyLarge => GoogleFonts.lato(
    fontSize: 18,
    // color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => GoogleFonts.lato(
    fontSize: 16,
    // color: AppColors.textPrimary,
  );

  static TextStyle get bodySmall => GoogleFonts.lato(
    fontSize: 14,
    // color: AppColors.textSecondary,
  );

  static TextStyle get arabicText => GoogleFonts.scheherazadeNew(
    fontSize: 22,
    // color: AppColors.textPrimary,
    height: 1.5,
  );

  // Arabic text style for dark mode
  static TextStyle get arabicTextDark => GoogleFonts.scheherazadeNew(
    fontSize: 22,
    // color: AppColors.darkTextPrimary,
    height: 1.5,
    letterSpacing: 0.5,
    fontWeight: FontWeight.w500,
  );
}

/// Theme data for the app
class AppTheme {
  // Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: false,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.black,
        error: AppColors.error,
        onError: Colors.white,
        background: AppColors.background,
        onBackground: AppColors.textPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headingMedium.copyWith(
          color: Colors.white,
        ),
      ),
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.bodyMedium,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextStyles.bodyMedium,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.headingLarge,
        displayMedium: AppTextStyles.headingMedium,
        displaySmall: AppTextStyles.headingSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
      ),
    );
  }

  // Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: false,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.darkPrimary,
        onPrimary: Colors.black,
        secondary: AppColors.darkSecondary,
        onSecondary: Colors.black,
        error: AppColors.error,
        onError: Colors.white,
        background: AppColors.darkBackground,
        onBackground: AppColors.darkTextPrimary,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        surfaceTint: AppColors.darkPrimary.withOpacity(0.05),
        surfaceVariant: AppColors.darkSurfaceVariant,
        outline: AppColors.darkTextSecondary.withOpacity(0.3),
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headingMedium.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        iconTheme: IconThemeData(color: AppColors.darkPrimary),
      ),
      cardTheme: CardTheme(
        color: AppColors.darkCardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        shadowColor: Colors.black.withOpacity(0.3),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
          elevation: 2,
          shadowColor: AppColors.darkPrimary.withOpacity(0.3),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          textStyle: AppTextStyles.bodyMedium,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          side: BorderSide(color: AppColors.darkPrimary),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: AppTextStyles.bodyMedium,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.darkPrimary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.darkPrimary.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        hintStyle: GoogleFonts.lato(
          fontSize: 16,
          color: AppColors.darkTextHint,
        ),
        labelStyle: GoogleFonts.lato(
          fontSize: 16,
          color: AppColors.darkTextSecondary,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: GoogleFonts.lato(
          fontSize: 16,
          color: AppColors.darkPrimary,
          fontWeight: FontWeight.w500,
        ),
        helperStyle: GoogleFonts.lato(
          fontSize: 12,
          color: AppColors.darkTextTertiary,
        ),
        errorStyle: GoogleFonts.lato(
          fontSize: 12,
          color: AppColors.error,
          fontWeight: FontWeight.w500,
        ),
        prefixStyle: GoogleFonts.lato(
          fontSize: 16,
          color: AppColors.darkTextSecondary,
        ),
        suffixStyle: GoogleFonts.lato(
          fontSize: 16,
          color: AppColors.darkTextSecondary,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.headingLarge.copyWith(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w700,
        ),
        displayMedium: AppTextStyles.headingMedium.copyWith(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w700,
        ),
        displaySmall: AppTextStyles.headingSmall.copyWith(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
        ),
        titleLarge: GoogleFonts.lato(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
        ),
        titleMedium: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.darkTextPrimary,
        ),
        titleSmall: GoogleFonts.lato(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.darkTextSecondary,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.darkTextSecondary,
          height: 1.5,
        ),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.darkTextSecondary,
          height: 1.5,
        ),
        bodySmall: AppTextStyles.bodySmall.copyWith(
          color: AppColors.darkTextTertiary,
          height: 1.5,
        ),
        labelLarge: GoogleFonts.lato(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.darkTextPrimary,
        ),
        labelMedium: GoogleFonts.lato(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.darkTextSecondary,
        ),
        labelSmall: GoogleFonts.lato(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppColors.darkTextTertiary,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 1,
        space: 1,
      ),
      iconTheme: IconThemeData(color: AppColors.darkTextPrimary, size: 24),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.darkPrimary;
          }
          return AppColors.darkTextSecondary;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.darkPrimary.withOpacity(0.5);
          }
          return AppColors.darkTextSecondary.withOpacity(0.3);
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.darkPrimary;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(Colors.black),
      ),
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.darkPrimary;
          }
          return AppColors.darkTextSecondary;
        }),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.darkPrimary,
        unselectedItemColor: AppColors.darkTextSecondary,
        selectedIconTheme: IconThemeData(
          color: AppColors.darkPrimary,
          size: 24,
        ),
        unselectedIconTheme: IconThemeData(
          color: AppColors.darkTextSecondary,
          size: 24,
        ),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
      dialogTheme: DialogTheme(
        backgroundColor: AppColors.darkCardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle: GoogleFonts.lato(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
          letterSpacing: 0.15,
        ),
        contentTextStyle: GoogleFonts.lato(
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.darkTextSecondary,
          height: 1.5,
          letterSpacing: 0.25,
        ),
        elevation: 8,
        shadowColor: Colors.black.withOpacity(0.4),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurfaceVariant,
        contentTextStyle: GoogleFonts.lato(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.darkTextPrimary,
          letterSpacing: 0.25,
        ),
        actionTextColor: AppColors.darkPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
        elevation: 6,
      ),
    );
  }
}
