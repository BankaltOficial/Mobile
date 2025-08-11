import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/EducationScreen.dart';
import 'package:flutter_application_1/pages/SplashScreen.dart';
import 'package:flutter_application_1/pages/education/divida-credito/FinanciamentoScreen.dart';
import 'package:flutter_application_1/pages/education/fundamentos/AnaliseDespesasScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/ColorsProvider.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/components/PageEducation.dart'; // Ensure this import matches your project structure
import 'package:flutter_application_1/pages/education/fundamentos/ReduzirDespesas.dart';
import 'package:flutter_application_1/service/ColorsService.dart'; // Adjust import based on your file structure
import 'package:flutter_application_1/service/ColorsService.dart'; // Adjust import based on your file structure

void main() async {
  // Ensure WidgetsFlutterBinding is initialized before any async operations
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize WebView platform for Android
  if (defaultTargetPlatform == TargetPlatform.android) {
    WebViewPlatform.instance = AndroidWebViewPlatform(); // Corrected class name
  }

  // Load colors asynchronously
  await ColorService.loadColors();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ColorProvider()..toggleDarkMode(AppColors.isDarkMode),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorProvider>(
      builder: (context, colorProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bankalt',
          theme: ThemeData(
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: colorProvider.theme,
            primaryColor: colorProvider.main, // Use colorProvider instead of colors
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: colorProvider.main,
              secondary: colorProvider.secondary,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: colorProvider.main,
              foregroundColor: AppColors.mainWhite,
            ),
          ),
          home: SplashScreen(), // Ensure const constructor is valid
        );
      },
    );
  }
}