import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/Colors.dart';
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

  void setColors(Color main, Color secondary, Color tertiary) {
    _main = main;
    _secondary = secondary;
    _tertiary = tertiary;
    notifyListeners();
  }

  void setTheme(bool isDark) {
    _isDarkMode = isDark;
    notifyListeners();
  }

  void resetColors() {
    _main = AppColors.defaultMain;
    _secondary = AppColors.defaultSecondary;
    _tertiary = AppColors.defaultTertiary;
    notifyListeners();
  }

  void toggleDarkMode(bool isDark) async {
    _isDarkMode = isDark;
    _theme = isDark ? AppColors.darkMode : AppColors.lightMode;

    AppColors.isDarkMode = isDark;
    AppColors.themeColor = _theme;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);

    notifyListeners();
  }
}
