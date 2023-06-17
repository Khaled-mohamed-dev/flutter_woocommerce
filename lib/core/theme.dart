import 'package:flutter/material.dart';

import 'colors.dart';

// extension SizerExt on num {
//   /// Calculates the sp (Scalable Pixel) depending on the device's screen size
//   double get sp =>
//       this *
//       ((MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width) /
//           3.5) /
//       100;
// }

class ThemeConfig {
// Light Theme
  static ThemeData lightTheme = ThemeData(
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: kcPrimaryLightThemeColor,
          secondary: kcPrimaryLightThemeColor,
        ),
    unselectedWidgetColor: kcPrimaryLightThemeColor,
    scaffoldBackgroundColor: const Color(0xffFDFDFD),
    brightness: Brightness.light,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xffFDFDFD),
      foregroundColor: kcLightBodyTextColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontSize: 18,
        color: kcLightHeadersColor,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomAppBarTheme:
        const BottomAppBarTheme(color: Color(0xffFDFDFD), elevation: 0),
    iconTheme: const IconThemeData(
      color: kcLightHeadersColor,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        color: kcLightHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontSize: 40,
        color: kcLightHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        fontSize: 32,
        color: kcLightHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        fontSize: 24,
        color: kcLightHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        color: kcLightHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        color: kcLightHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: kcLightBodyTextColor,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: kcLightBodyTextColor,
        fontWeight: FontWeight.bold,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: kcLightBodyTextColor,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        color: kcLightSubtitleTextColor,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        color: kcLightSubtitleTextColor,
        fontWeight: FontWeight.normal,
      ),
      titleSmall: TextStyle(
        fontSize: 12,
        color: kcLightSubtitleTextColor,
        fontWeight: FontWeight.normal,
      ),
      // Used for Buttons
      labelLarge: TextStyle(
        fontSize: 16,
        color: kcPrimaryDarkThemeColor,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  // Dark Theme

  static ThemeData darkTheme = ThemeData(
    colorScheme: ThemeData().colorScheme.copyWith(
          primary: kcPrimaryDarkThemeColor,
          secondary: kcPrimaryDarkThemeColor,
        ),
    scaffoldBackgroundColor: const Color(0xff181A20),
    unselectedWidgetColor: kcPrimaryDarkThemeColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xff181A20),
      foregroundColor: kcDarkHeadersColor,
      centerTitle: true,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 18,
        color: kcDarkHeadersColor,
        fontWeight: FontWeight.bold,
      ),
    ),
    bottomAppBarTheme:
        const BottomAppBarTheme(color: Color(0xff181A20), elevation: 0),
    iconTheme: const IconThemeData(
      color: kcDarkHeadersColor,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        color: kcDarkHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        fontSize: 40,
        color: kcDarkHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        fontSize: 32,
        color: kcDarkHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      headlineLarge: TextStyle(
        fontSize: 24,
        color: kcDarkHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      headlineMedium: TextStyle(
        fontSize: 20,
        color: kcDarkHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        color: kcDarkHeadersColor,
        fontWeight: FontWeight.bold,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        color: kcDarkBodyTextColor,
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        color: kcDarkBodyTextColor,
        fontWeight: FontWeight.bold,
      ),
      bodySmall: TextStyle(
        fontSize: 14,
        color: kcDarkBodyTextColor,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: TextStyle(
        fontSize: 16,
        color: kcDarkSubtitleTextColor,
        fontWeight: FontWeight.normal,
      ),
      titleMedium: TextStyle(
        fontSize: 14,
        color: kcDarkSubtitleTextColor,
        fontWeight: FontWeight.normal,
      ),
      titleSmall: TextStyle(
        fontSize: 12,
        color: kcDarkSubtitleTextColor,
        fontWeight: FontWeight.normal,
      ),
      // Used for Buttons
      labelLarge: TextStyle(
        fontSize: 16,
        color: kcPrimaryLightThemeColor,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
