import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/PersonalizedScreen.dart';

class AppColors {
  // Cores fixas
  static const Color mainPurple = Color(0xFF353DAB);
  static const Color mainPurpleWeak = Color.fromARGB(51, 53, 61, 171);
  static const Color mainWhite = Color(0xFFFFFFFF);
  static const Color mainBlack = Color(0xFF000000);
  static const Color mainGray = Color(0xFF828282);
  static const Color mainGrayBlue = Color(0xFF495057);
  static const Color mainBlue = Color(0xFF027BD4);
  static const Color mainYellow = Color(0xFFFFC700);
  static const Color mainLightPurple = Color(0xFFCBCBE5);
  static const Color mainGreen = Color(0xFF04A95C);
  static const Color mainRed = Color(0xFFEB5757);

  static const Color darkMode = Color(0xFF332E46);
  static const Color lightMode = Color(0xFFFFFFFF);

  static const bool isDarkModeDefault = false;
  static bool isDarkMode = isDarkModeDefault;

  // Cores personalizáveis (inicialmente padrão)
  static Color main = defaultMain;
  static Color get mainLight => getColorWithOpacity(main, 0.3);
  static Color get mainWeak => getColorWithOpacity(main, 0.4);

  static Color secondary = defaultSecondary;
  static Color get secondaryLight => getColorWithOpacity(secondary, 0.3);

  static Color tertiary = defaultTertiary;
  static Color get tertiaryLight => getColorWithOpacity(tertiary, 0.3);

  // Tema atual
  static Color get theme => isDarkMode ? darkMode : lightMode;
  static Color themeColor = lightMode;

  // Padrões
  static const Color defaultMain = mainPurple;
  static const Color defaultSecondary = mainBlue;
  static const Color defaultTertiary = mainGreen;

  static Color _getLighterColor(Color color, [double factor = 0.3]) {
    return Color.lerp(color, Colors.white, factor)!;
  }

  static Color getColorWithOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
}
