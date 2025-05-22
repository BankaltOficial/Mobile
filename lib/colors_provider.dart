import 'package:flutter/material.dart';

class ColorProvider with ChangeNotifier {
  Color _main = const Color(0xFF353DAB);
  Color _secondary = const Color(0xFF027BD4);
  Color _tertiary = const Color(0xFF04A95C);

  Color get main => _main;
  Color get secondary => _secondary;
  Color get tertiary => _tertiary;

  void setColors(Color main, Color secondary, Color tertiary) {
    _main = main;
    _secondary = secondary;
    _tertiary = tertiary;
    notifyListeners(); // Notifica para reconstruir as telas
  }
}
