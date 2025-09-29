import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/ColorsService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorProvider with ChangeNotifier {
  bool _isDarkMode = AppColors.isDarkMode;
  Color _main = AppColors.main;
  Color _secondary = AppColors.secondary;
  Color _tertiary = AppColors.tertiary;
  Color _theme = AppColors.themeColor;

  Color get main => _main;
  Color get secondary => _secondary;
  Color get tertiary => _tertiary;
  Color get theme => _theme;
  bool get isDarkMode => _isDarkMode;

  void setColors(Color main, Color secondary, Color tertiary) {
    _main = main;
    _secondary = secondary;
    _tertiary = tertiary;
    AppColors.main = main;
    AppColors.secondary = secondary;
    AppColors.tertiary = tertiary;

    ColorService.saveColors(main, secondary, tertiary);

    notifyListeners();
  }

  Future<void> setTheme(bool isDark) async {
    _isDarkMode = isDark;
    _theme = isDark ? AppColors.darkMode : AppColors.lightMode;

    AppColors.isDarkMode = isDark;
    AppColors.themeColor = _theme;
    await ColorService.setTheme(isDark);

    notifyListeners();
  }

  Future<void> resetColors() async {
    _main = AppColors.defaultMain;
    _secondary = AppColors.defaultSecondary;
    _tertiary = AppColors.defaultTertiary;
    _isDarkMode = false;
    _theme = AppColors.lightMode;

    AppColors.main = AppColors.defaultMain;
    AppColors.secondary = AppColors.defaultSecondary;
    AppColors.tertiary = AppColors.defaultTertiary;
    AppColors.isDarkMode = false;
    AppColors.themeColor = AppColors.lightMode;

    // salvar cores e tema
    await ColorService.saveColors(_main, _secondary, _tertiary);
    await ColorService.setTheme(false);

    // também salvar no SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', false);

    notifyListeners();
  }

  Future<void> toggleDarkMode(bool isDark) async {
    _isDarkMode = isDark;
    _theme = isDark ? AppColors.darkMode : AppColors.lightMode;

    AppColors.isDarkMode = isDark;
    AppColors.themeColor = _theme;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);

    notifyListeners();
  }
}
