import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppTheme {
  static bool isDarkModeEnabled = false;
  static Color? appColor = Colors.deepOrange[100];

  static Future<void> getThemeValues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    isDarkModeEnabled = prefs.getBool('isDarkMode') ?? false;
  }
}
