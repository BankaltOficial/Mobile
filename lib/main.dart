import 'package:flutter/material.dart';
import 'package:flutter_application_1/inicialScreen.dart';
import 'package:flutter_application_1/splashScreen.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/colors_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ColorService.loadColors(); // Para carregar as cores personalizadas
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bankalt',
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.mainWhite,
        primaryColor: AppColors.main,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.main,
          secondary: AppColors.secondary,
        ),
      ),
      home: InicialScreen(),
    );
  }
}
