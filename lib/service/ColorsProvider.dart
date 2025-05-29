import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/ColorsService.dart';

class ColorProvider with ChangeNotifier {
  Color _main = AppColors.main;
  Color _secondary = AppColors.secondary;
  Color _tertiary = AppColors.tertiary;

  Color get main => _main;
  Color get secondary => _secondary;
  Color get tertiary => _tertiary;

  void setColors(Color main, Color secondary, Color tertiary) {
    _main = main;
    _secondary = secondary;
    _tertiary = tertiary;
    notifyListeners();
  }
}
