// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_application_1/colors.dart';

class ColorService {
  static const _mainKey = 'mainColor';
  static const _secondaryKey = 'secondaryColor';
  static const _tertiaryKey = 'tertiaryColor';

  static Future<void> loadColors() async {
    final prefs = await SharedPreferences.getInstance();

    AppColors.main = _getColorFromHex(prefs.getString(_mainKey)) ?? AppColors.defaultMain;
    AppColors.secondary = _getColorFromHex(prefs.getString(_secondaryKey)) ?? AppColors.defaultSecondary;
    AppColors.tertiary = _getColorFromHex(prefs.getString(_tertiaryKey)) ?? AppColors.defaultTertiary;
  }

  static Future<void> saveColors(Color main, Color secondary, Color tertiary) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_mainKey, _colorToHex(main));
    await prefs.setString(_secondaryKey, _colorToHex(secondary));
    await prefs.setString(_tertiaryKey, _colorToHex(tertiary));
  }

  static String _colorToHex(Color color) => '#${color.value.toRadixString(16).padLeft(8, '0')}';

  static Color? _getColorFromHex(String? hex) {
    if (hex == null || !hex.startsWith('#')) return null;
    return Color(int.parse(hex.substring(1), radix: 16));
  }
}
