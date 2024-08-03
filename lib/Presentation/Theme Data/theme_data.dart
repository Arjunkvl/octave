import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Colors.white,
        fontSize: 25,
        fontFamily: 'cir',
        fontWeight: FontWeight.w600,
      ),
      bodySmall: TextStyle(
        color: Colors.white,
        fontSize: 12,
        fontWeight: FontWeight.w600,
        fontFamily: 'cir',
      ),
      bodyMedium: TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w600,
        fontFamily: 'cir',
      ),
      displayLarge: TextStyle(
        color: Color(0xff6C6868),
        fontWeight: FontWeight.w600,
        fontSize: 17,
        fontFamily: 'cir',
      ),
      displayMedium: TextStyle(
        color: Color(0xff838383),
        fontWeight: FontWeight.w300,
        fontSize: 12,
        fontFamily: 'cir',
      ),
    ),
  );
}
