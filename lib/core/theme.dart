import 'package:flutter/material.dart';

import 'colors.dart';

extension SizerExt on num {
  /// Calculates the sp (Scalable Pixel) depending on the device's screen size
  double get sp =>
      this *
      ((MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width) /
          3.5) /
      100;
}

class ThemeConfig {
// Light Theme
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'Urbanist',
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: kcDarkColor,
          secondary: kcDarkColor,
        ),
    unselectedWidgetColor: kcDarkColor,
    scaffoldBackgroundColor: kcLightColor,
    brightness: Brightness.light,
    appBarTheme: AppBarTheme(
      backgroundColor: kcLightColor,
      foregroundColor: kcLightBodyTextColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18.sp,
        color: kcLightHeadersColor,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomAppBarTheme:
        const BottomAppBarTheme(color: kcLightColor, elevation: 0),
    iconTheme: const IconThemeData(
      color: kcLightSubtitleTextColor,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 48.sp,
        color: kcLightHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontSize: 40.sp,
        color: kcLightHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        fontSize: 32.sp,
        color: kcLightHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        fontSize: 24.sp,
        color: kcLightHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontSize: 20.sp,
        color: kcLightHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        fontSize: 18.sp,
        color: kcLightHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        fontSize: 18.sp,
        color: kcLightBodyTextColor,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        fontSize: 16.sp,
        color: kcLightBodyTextColor,
        fontWeight: FontWeight.bold,
      ),
      bodySmall: TextStyle(
        fontSize: 14.sp,
        color: kcLightBodyTextColor,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontSize: 16.sp,
        color: kcLightSubtitleTextColor,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: TextStyle(
        fontSize: 14.sp,
        color: kcLightSubtitleTextColor,
        fontWeight: FontWeight.normal,
      ),
      titleSmall: TextStyle(
        fontSize: 12.sp,
        color: kcLightSubtitleTextColor,
        fontWeight: FontWeight.normal,
      ),
      // Used for Buttons
      labelLarge: TextStyle(
        fontSize: 16.sp,
        color: kcLightColor,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  // Dark Theme

  static ThemeData darkTheme = ThemeData(
    fontFamily: 'Urbanist',
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: kcLightColor,
          secondary: kcLightColor,
        ),
    scaffoldBackgroundColor: kcDarkColor,
    unselectedWidgetColor: kcLightColor,
    appBarTheme: AppBarTheme(
      backgroundColor: kcDarkColor,
      foregroundColor: kcDarkHeadersColor,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 18.sp,
        color: kcDarkHeadersColor,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomAppBarTheme:
        const BottomAppBarTheme(color: kcDarkColor, elevation: 0),
    iconTheme: const IconThemeData(
      color: kcDarkHeadersColor,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
        fontSize: 48.sp,
        color: kcDarkHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontSize: 40.sp,
        color: kcDarkHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        fontSize: 32.sp,
        color: kcDarkHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        fontSize: 24.sp,
        color: kcDarkHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontSize: 20.sp,
        color: kcDarkHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        fontSize: 18.sp,
        color: kcDarkHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        fontSize: 18.sp,
        color: kcDarkBodyTextColor,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        fontSize: 16.sp,
        color: kcDarkBodyTextColor,
        fontWeight: FontWeight.bold,
      ),
      bodySmall: TextStyle(
        fontSize: 14.sp,
        color: kcDarkBodyTextColor,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontSize: 16.sp,
        color: kcDarkSubtitleTextColor,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: TextStyle(
        fontSize: 14.sp,
        color: kcDarkSubtitleTextColor,
        fontWeight: FontWeight.normal,
      ),
      titleSmall: TextStyle(
        fontSize: 12.sp,
        color: kcDarkSubtitleTextColor,
        fontWeight: FontWeight.normal,
      ),
      // Used for Buttons
      labelLarge: TextStyle(
        fontSize: 16.sp,
        color: kcDarkColor,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
