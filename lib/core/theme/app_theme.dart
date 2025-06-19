import 'package:flutter/material.dart';

/// Color palette for the app
class AppColors {
  // Primary colors - Enhanced green palette inspired by Islamic nature themes
  static const Color primary = Color(0xFF1B7F5A); // Deep emerald
  static const Color primaryLight = Color(0xFF52C93F); // Vibrant green
  static const Color primaryDark = Color(0xFF0D5D42); // Forest green
  static const Color primaryVariant = Color(0xFF2E8B57); // Sea green accent

  // Secondary colors - Refined gold palette
  static const Color secondary = Color(0xFFD4AF37); // Classic gold
  static const Color secondaryLight = Color(0xFFFFE082); // Light gold
  static const Color secondaryDark = Color(0xFFB8860B); // Dark goldenrod
  static const Color secondaryVariant = Color(0xFFF4A460); // Sandy brown accent

  // Tertiary colors - Spiritual purple with blue accents
  static const Color tertiary = Color(0xFF7986CB); // Soft indigo
  static const Color tertiaryLight = Color(0xFFB39DDB); // Light purple
  static const Color tertiaryDark = Color(0xFF5C6BC0); // Deep indigo

  // Neutral colors (Light mode) - Warmer, softer palette
  static const Color background = Color(0xFFFAFAFA); // Soft white
  static const Color surface = Color(0xFFFFFFFF); // Pure white
  static const Color surfaceVariant = Color(0xFFF5F5F5); // Light gray
  static const Color outline = Color(0xFFE0E0E0); // Subtle border
  static const Color shadow = Color(0x1A000000); // Subtle shadow

  // Status colors - More vibrant and accessible
  static const Color success = Color(0xFF2E7D32); // Success green
  static const Color warning = Color(0xFFFF8F00); // Warm orange
  static const Color error = Color(0xFFD32F2F); // Error red
  static const Color info = Color(0xFF1976D2); // Info blue

  // Text colors (Light mode) - Better contrast ratios
  static const Color textPrimary = Color(0xFF1A1A1A); // Near black
  static const Color textSecondary = Color(0xFF666666); // Medium gray
  static const Color textTertiary = Color(0xFF999999); // Light gray
  static const Color textHint = Color(0xFFBBBBBB); // Hint gray
  static const Color textDisabled = Color(0xFFCCCCCC); // Disabled gray

  // Dark mode colors - Refined dark palette
  static const Color darkBackground = Color(0xFF0D1B2A); // Deep navy
  static const Color darkSurface = Color(0xFF1B263B); // Dark blue-gray
  static const Color darkSurfaceVariant = Color(0xFF283545); // Medium blue-gray
  static const Color darkOutline = Color(0xFF415A77); // Dark outline
  static const Color darkShadow = Color(0x40000000); // Darker shadow

  // Dark mode primary colors - Optimized for dark backgrounds
  static const Color darkPrimary = Color(0xFF66BB6A); // Bright green
  static const Color darkPrimaryLight = Color(0xFF81C784); // Light green
  static const Color darkPrimaryDark = Color(0xFF4CAF50); // Medium green

  // Dark mode secondary colors
  static const Color darkSecondary = Color(0xFFFFD54F); // Bright gold
  static const Color darkSecondaryLight = Color(0xFFFFE082); // Light gold
  static const Color darkSecondaryDark = Color(0xFFFFC107); // Medium gold

  // Dark mode text colors - Enhanced readability
  static const Color darkTextPrimary = Color(0xFFFFFFFF); // Pure white
  static const Color darkTextSecondary = Color(0xFFE1E1E1); // Light gray
  static const Color darkTextTertiary = Color(0xFFBBBBBB); // Medium gray
  static const Color darkTextHint = Color(0xFF888888); // Dark hint
  static const Color darkTextDisabled = Color(0xFF555555); // Dark disabled

  // Prayer time colors - More distinctive and meaningful
  static const Color fajrColor = Color(0xFF64B5F6); // Dawn blue
  static const Color sunriseColor = Color(0xFFFFB74D); // Golden sunrise
  static const Color dhuhrColor = Color(0xFFFFD54F); // Noon yellow
  static const Color asrColor = Color(0xFFFF8A65); // Afternoon orange
  static const Color maghribColor = Color(0xFFE57373); // Sunset red
  static const Color ishaColor = Color(0xFF9575CD); // Night purple

  // Dark mode prayer time colors - Adjusted for dark theme
  static const Color darkFajrColor = Color(0xFF42A5F5); // Deep dawn
  static const Color darkSunriseColor = Color(0xFFFFB74D); // Bright sunrise
  static const Color darkDhuhrColor = Color(0xFFFFEB3B); // Bright noon
  static const Color darkAsrColor = Color(0xFFFF7043); // Warm afternoon
  static const Color darkMaghribColor = Color(0xFFEF5350); // Vibrant sunset
  static const Color darkIshaColor = Color(0xFFAB47BC); // Deep night

  // Qibla and Islamic feature colors
  static const Color qiblaColor = Color(0xFF2E7D32); // Direction green
  static const Color dhikrColor = Color(0xFF7B1FA2); // Meditation purple
  static const Color quranColor = Color(0xFF1565C0); // Quran blue
  static const Color hadithColor = Color(0xFFD84315); // Hadith orange

  // Interactive colors
  static const Color buttonPrimary = Color(0xFF1B7F5A); // Primary button
  static const Color buttonSecondary = Color(0xFFE8F5E8); // Secondary button
  static const Color buttonDisabled = Color(0xFFE0E0E0); // Disabled button
  static const Color rippleLight = Color(0x1F1B7F5A); // Light ripple
  static const Color rippleDark = Color(0x1FFFFFFF); // Dark ripple

  // Card and container colors
  static const Color cardLight = Color(0xFFFFFFFF); // Light card
  static const Color cardDark = Color(0xFF1B263B); // Dark card
  static const Color darkCardBackground = Color(
    0xFF1B263B,
  ); // Dark card background
  static const Color containerLight = Color(0xFFF5F5F5); // Light container
  static const Color containerDark = Color(0xFF283545); // Dark container

  // Gradient colors for enhanced UI
  static const List<Color> primaryGradient = [
    Color(0xFF1B7F5A),
    Color(0xFF52C93F),
  ];

  static const List<Color> secondaryGradient = [
    Color(0xFFD4AF37),
    Color(0xFFFFE082),
  ];

  static const List<Color> prayerTimeGradient = [
    Color(0xFF64B5F6),
    Color(0xFF9575CD),
  ];

  static const lightGrey = Color(0xFFD9D9D9);

  // Divider color for dark mode
  static const Color darkDivider = Color(0xFF415A77);

  // Helper method to get color based on theme
  static Color getColor(Color lightColor, Color darkColor, bool isDark) {
    return isDark ? darkColor : lightColor;
  }

  // Method to get prayer time color by prayer name
  static Color getPrayerTimeColor(String prayerName, {bool isDark = false}) {
    final colorMap = {
      'fajr': isDark ? darkFajrColor : fajrColor,
      'sunrise': isDark ? darkSunriseColor : sunriseColor,
      'dhuhr': isDark ? darkDhuhrColor : dhuhrColor,
      'asr': isDark ? darkAsrColor : asrColor,
      'maghrib': isDark ? darkMaghribColor : maghribColor,
      'isha': isDark ? darkIshaColor : ishaColor,
    };

    return colorMap[prayerName.toLowerCase()] ??
        (isDark ? darkPrimary : primary);
  }
}

/// Text styles for the app
class AppTextStyles {
  // Define font families
  static const String latoFontFamily = 'Lato';
  static const String scheherazadeFontFamily = 'ScheherazadeNew';

  static TextStyle get headingLarge => TextStyle(
    fontFamily: latoFontFamily,
    fontSize: 32,
    fontWeight: FontWeight.bold,
    // color: AppColors.textPrimary,
  );

  static TextStyle get headingMedium => TextStyle(
    fontFamily: latoFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    // color: AppColors.textPrimary,
  );

  static TextStyle get headingSmall => TextStyle(
    fontFamily: latoFontFamily,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    // color: AppColors.textPrimary,
  );

  static TextStyle get bodyLarge => TextStyle(
    fontFamily: latoFontFamily,
    fontSize: 18,
    // color: AppColors.textPrimary,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: latoFontFamily,
    fontSize: 16,
    // color: AppColors.textPrimary,
  );

  static TextStyle get bodySmall => TextStyle(
    fontFamily: latoFontFamily,
    fontSize: 14,
    // color: AppColors.textSecondary,
  );

  static TextStyle get arabicText => TextStyle(
    fontFamily: scheherazadeFontFamily,
    fontSize: 22,
    // color: AppColors.textPrimary,
    height: 1.5,
  );

  // Arabic text style for dark mode
  static TextStyle get arabicTextDark => TextStyle(
    fontFamily: scheherazadeFontFamily,
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
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.black,
        error: AppColors.error,
        onError: Colors.white,
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
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        shadowColor: AppColors.primary.withAlpha(102),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.black.withAlpha(26),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          elevation: 2,
          shadowColor: AppColors.primary.withAlpha(77),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withAlpha(128)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
        prefixIconColor: AppColors.primary,
        suffixIconColor: AppColors.textSecondary,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.headingLarge.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        displayMedium: AppTextStyles.headingMedium.copyWith(
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        displaySmall: AppTextStyles.headingSmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          fontFamily: AppTextStyles.latoFontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontFamily: AppTextStyles.latoFontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontFamily: AppTextStyles.latoFontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        bodyLarge: AppTextStyles.bodyLarge.copyWith(height: 1.5),
        bodyMedium: AppTextStyles.bodyMedium.copyWith(height: 1.5),
        bodySmall: AppTextStyles.bodySmall.copyWith(height: 1.5),
      ),
      iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 24),
      dividerTheme: DividerThemeData(
        color: AppColors.lightGrey.withAlpha(128),
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textPrimary,
        contentTextStyle: TextStyle(
          fontFamily: AppTextStyles.latoFontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.white,
          letterSpacing: 0.25,
        ),
        actionTextColor: AppColors.secondary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        behavior: SnackBarBehavior.floating,
        elevation: 6,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        extendedPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
      ),
    );
  }

  // Dark theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: AppColors.darkPrimary,
        onPrimary: Colors.black,
        secondary: AppColors.darkSecondary,
        onSecondary: Colors.black,
        error: AppColors.error,
        onError: Colors.white,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        surfaceContainerHighest: AppColors.darkSurfaceVariant,
        outline: Colors.white.withAlpha(77),
      ),
      scaffoldBackgroundColor: AppColors.darkBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkSurface,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.headingMedium.copyWith(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: AppColors.darkPrimary),
        shadowColor: Colors.black.withAlpha(102),
      ),
      cardTheme: CardThemeData(
        color: AppColors.darkCardBackground,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        shadowColor: Colors.black.withAlpha(77),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
          elevation: 2,
          shadowColor: AppColors.darkPrimary.withAlpha(77),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          textStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.darkPrimary,
          side: BorderSide(color: AppColors.darkPrimary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.darkPrimary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.darkPrimary.withAlpha(128)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.darkPrimary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        hintStyle: TextStyle(
          fontFamily: AppTextStyles.latoFontFamily,
          fontSize: 16,
          color: AppColors.darkTextHint,
        ),
        labelStyle: TextStyle(
          fontFamily: AppTextStyles.latoFontFamily,
          fontSize: 16,
          color: AppColors.darkTextSecondary,
          fontWeight: FontWeight.w500,
        ),
        floatingLabelStyle: TextStyle(
          fontFamily: AppTextStyles.latoFontFamily,
          fontSize: 16,
          color: AppColors.darkPrimary,
          fontWeight: FontWeight.w600,
        ),
        helperStyle: TextStyle(
          fontFamily: AppTextStyles.latoFontFamily,
          fontSize: 12,
          color: AppColors.darkTextTertiary,
        ),
        errorStyle: TextStyle(
          fontFamily: AppTextStyles.latoFontFamily,
          fontSize: 12,
          color: AppColors.error,
          fontWeight: FontWeight.w500,
        ),
        prefixIconColor: AppColors.darkPrimary,
        suffixIconColor: AppColors.darkTextSecondary,
      ),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.headingLarge.copyWith(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        displayMedium: AppTextStyles.headingMedium.copyWith(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        displaySmall: AppTextStyles.headingSmall.copyWith(
          color: AppColors.darkTextPrimary,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          fontFamily: AppTextStyles.latoFontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
        ),
        titleLarge: TextStyle(
          fontFamily: AppTextStyles.latoFontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
        ),
        titleMedium: TextStyle(
          fontFamily: AppTextStyles.latoFontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.darkTextPrimary,
        ),
        titleSmall: TextStyle(
          fontFamily: AppTextStyles.latoFontFamily,
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
        labelLarge: TextStyle(
          fontFamily: AppTextStyles.latoFontFamily,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.darkTextPrimary,
        ),
        labelMedium: TextStyle(
          fontFamily: AppTextStyles.latoFontFamily,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.darkTextSecondary,
        ),
        labelSmall: TextStyle(
          fontFamily: AppTextStyles.latoFontFamily,
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
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.darkPrimary;
          }
          return AppColors.darkTextSecondary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.darkPrimary.withAlpha(128);
          }
          return AppColors.darkTextSecondary.withAlpha(77);
        }),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.darkPrimary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.black),
      ),
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
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
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkCardBackground,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: TextStyle(
          fontFamily: AppTextStyles.latoFontFamily,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.darkTextPrimary,
          letterSpacing: 0.15,
        ),
        contentTextStyle: TextStyle(
          fontFamily: AppTextStyles.latoFontFamily,
          fontSize: 16,
          fontWeight: FontWeight.normal,
          color: AppColors.darkTextSecondary,
          height: 1.5,
          letterSpacing: 0.25,
        ),
        elevation: 8,
        shadowColor: Colors.black.withAlpha(102),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurfaceVariant,
        contentTextStyle: TextStyle(
          fontFamily: AppTextStyles.latoFontFamily,

          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.darkTextPrimary,
          letterSpacing: 0.25,
        ),
        actionTextColor: AppColors.darkPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        elevation: 6,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.darkPrimary,
        foregroundColor: Colors.black,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        extendedPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
      ),
    );
  }
}
