import 'package:flutter/material.dart';

class Config {
  static String baseUrl = 'http://192.168.1.100:8000/api';
  static Color primaryColor = const Color.fromRGBO(37, 54, 117, 1);
  static Color secondaryColor = const Color.fromRGBO(70, 177, 229, 1);
  static MaterialColor primaryTheme = MaterialColor(
    primaryColor.value,
    <int, Color>{
      50: primaryColor.withOpacity(0.1),
      100: primaryColor.withOpacity(0.2),
      200: primaryColor.withOpacity(0.3),
      300: primaryColor.withOpacity(0.4),
      400: primaryColor.withOpacity(0.5),
      500: primaryColor.withOpacity(0.6),
      600: primaryColor.withOpacity(0.7),
      700: primaryColor.withOpacity(0.8),
      800: primaryColor.withOpacity(0.9),
      900: primaryColor.withOpacity(1),
    },
  );
}
