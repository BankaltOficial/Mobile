import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/service/Colors.dart';

class ColorService {
  static const _mainKey = 'mainColor';
  static const _secondaryKey = 'secondaryColor';
  static const _tertiaryKey = 'tertiaryColor';
  static const _isDarkModeKey = 'isDarkMode';
  static const _themeColorKey = 'themeColor';

  static Future<void> loadColors() async {
    final prefs = await SharedPreferences.getInstance();

    AppColors.main = _getColorFromHex(prefs.getString(_mainKey)) ?? AppColors.defaultMain;
    AppColors.secondary = _getColorFromHex(prefs.getString(_secondaryKey)) ?? AppColors.defaultSecondary;
    AppColors.tertiary = _getColorFromHex(prefs.getString(_tertiaryKey)) ?? AppColors.defaultTertiary;

    AppColors.isDarkMode = prefs.getBool(_isDarkModeKey) ?? false;
    AppColors.themeColor = AppColors.isDarkMode ? AppColors.darkMode : AppColors.lightMode;
  }

  static Future<void> saveColors(Color main, Color secondary, Color tertiary) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_mainKey, _colorToHex(main));
    await prefs.setString(_secondaryKey, _colorToHex(secondary));
    await prefs.setString(_tertiaryKey, _colorToHex(tertiary));
  }

  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isDarkModeKey, isDark);
  }

  static Future<void> toggleDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    AppColors.isDarkMode = !AppColors.isDarkMode;
    await prefs.setBool(_isDarkModeKey, AppColors.isDarkMode);
    AppColors.themeColor = AppColors.isDarkMode ? AppColors.darkMode : AppColors.lightMode;
    await prefs.setString(_themeColorKey, _colorToHex(AppColors.themeColor));
  }

  static Future<void> setTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    AppColors.isDarkMode = isDark;
    await prefs.setBool(_isDarkModeKey, isDark);
    AppColors.themeColor = isDark ? AppColors.darkMode : AppColors.lightMode;
    await prefs.setString(_themeColorKey, _colorToHex(AppColors.themeColor));
  }

  static String _colorToHex(Color color) => '#${color.value.toRadixString(16).padLeft(8, '0')}';

  static Color? _getColorFromHex(String? hex) {
    if (hex == null || !hex.startsWith('#')) return null;
    return Color(int.parse(hex.substring(1), radix: 16));
  }
}
