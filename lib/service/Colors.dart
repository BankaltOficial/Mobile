import 'package:flutter/material.dart';

class AppColors {
  // Cores fixas
  static const Color mainPurple = Color(0xFF353DAB);
  static const Color mainPurpleWeak = Color.fromARGB(51, 53, 61, 171);
  static const Color mainWhite = Color(0xFFFFFFFF);
  static const Color gray = Color(0xFF828282);
  static const Color grayBlue = Color(0xFF495057);
  static const Color mainBlue = Color(0xFF027BD4);
  static const Color mainYellow = Color(0xFFFFC700);
  static const Color mainLightPurple = Color(0xFFCBCBE5);
  static const Color mainGreen = Color(0xFF04A95C);

  // Cores personalizáveis (inicialmente padrão)
  static Color main = defaultMain;
  static Color secondary = defaultSecondary;
  static Color tertiary = defaultTertiary;

  // Padrões
  static const Color defaultMain = mainPurple;
  static const Color defaultSecondary = mainBlue;
  static const Color defaultTertiary = mainGreen;
}
