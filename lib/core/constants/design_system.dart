import 'package:flutter/material.dart';

/// Design system constants based on the design reference PDFs
class DesignSystem {
  // Colors from Foundations.pdf
  static const Color primaryText = Color(0xFF191F25);
  static const Color backgroundPrimary = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFEDF1F5);
  static const Color backgroundTertiary = Color(0xFFF4F8FC);
  
  // Blue colors
  static const Color bluePrimary600 = Color(0xFF2D67B2);
  static const Color bluePrimary800 = Color(0xFF022C63);
  static const Color bluePrimary900 = Color(0xFF011B3D);
  
  // Grey colors
  static const Color grey50 = Color(0xFFF4F8FC);
  static const Color grey100 = Color(0xFFEDF1F5);
  static const Color grey300 = Color(0xFFC5CFDB);
  static const Color grey500 = Color(0xFF7B8694);
  static const Color grey600 = Color(0xFF666F7A);
  static const Color grey800 = Color(0xFF3A3F45);
  
  // Red colors
  static const Color red600 = Color(0xFFDD3728);
  static const Color red700 = Color(0xFFC73224);
  static const Color red800 = Color(0xFFB12C20);

  // Status Colors
  static const Color statusGreen = Color(0xFF006400); // Dark Green
  static const Color statusGreenBg = Color(0xFFE8F5E9); // Light Green
  static const Color statusRed = Color(0xFFC73224); // Dark Red
  static const Color statusRedBg = Color(0xFFFCE8E6); // Light Red
  
  // Input field background
  static const Color inputBackground = Color(0xFFDADADA);
  
  // Spacing values
  static const double spacing2 = 2.0;
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  
  // Border radius
  static const double borderRadius28 = 28.0;
  
  // Typography - using Inter font family
  static const String fontFamily = 'Inter';
  
  // Text styles based on design specifications
  static const TextStyle displayLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 40,
    height: 48 / 40,
    fontWeight: FontWeight.w600, // Semi Bold
    color: primaryText,
  );
  
  static const TextStyle headlineLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    height: 32 / 28,
    fontWeight: FontWeight.w600, // Semi Bold
    color: primaryText,
  );
  
  static const TextStyle titleLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    height: 28 / 24,
    fontWeight: FontWeight.w500, // Medium
    color: primaryText,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    height: 24 / 16,
    fontWeight: FontWeight.w400, // Regular
    color: primaryText,
  );
  
  static const TextStyle labelLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    height: 20 / 14,
    fontWeight: FontWeight.w600, // Semi Bold
    color: primaryText,
  );
  
  // Component dimensions
  static const double searchBarHeight = 48.0;
  static const double listItemHeight = 72.0;
  static const double topAppBarHeight = 64.0;
  static const double statusBarHeight = 59.0;
  
  // Transport mode colors (approximate based on common BVG colors)
  static const Color subwayBlue = Color(0xFF0033A0);
  static const Color suburbanGreen = Color(0xFF009639);
  static const Color tramRed = Color(0xFFCC0000);
  static const Color busRed = Color(0xFFAA0000);
  static const Color ferryBlue = Color(0xFF0066CC);
  static const Color expressRed = Color(0xFFDC143C);
}

/// Material theme configuration based on design system
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: DesignSystem.fontFamily,
      colorScheme: ColorScheme.fromSeed(
        seedColor: DesignSystem.bluePrimary600,
        brightness: Brightness.light,
        primary: DesignSystem.bluePrimary600,
        onPrimary: DesignSystem.backgroundPrimary,
        surface: DesignSystem.backgroundPrimary,
        onSurface: DesignSystem.primaryText,
        secondary: DesignSystem.grey600,
        onSecondary: DesignSystem.backgroundPrimary,
      ),
      scaffoldBackgroundColor: DesignSystem.backgroundPrimary,
      appBarTheme: const AppBarTheme(
        backgroundColor: DesignSystem.backgroundPrimary,
        foregroundColor: DesignSystem.primaryText,
        elevation: 0,
        centerTitle: false,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: DesignSystem.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignSystem.borderRadius28),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignSystem.borderRadius28),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(DesignSystem.borderRadius28),
          borderSide: const BorderSide(color: DesignSystem.bluePrimary600),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: DesignSystem.spacing16,
          vertical: DesignSystem.spacing12,
        ),
        hintStyle: const TextStyle(
          color: DesignSystem.grey600,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: DesignSystem.bluePrimary600,
          foregroundColor: DesignSystem.backgroundPrimary,
          textStyle: DesignSystem.labelLarge,
          padding: const EdgeInsets.symmetric(
            horizontal: DesignSystem.spacing16,
            vertical: DesignSystem.spacing12,
          ),
        ),
      ),
    );
  }
}
