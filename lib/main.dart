import 'package:flutter/material.dart';
import 'package:flutter_application_1/FormScreen.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/colors_provider.dart';
import 'package:flutter_application_1/colors_service.dart';
import 'package:flutter_application_1/inicialScreen.dart';
import 'package:flutter_application_1/splashScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ColorService.loadColors();

  runApp(
    ChangeNotifierProvider(
      create: (_) => ColorProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ColorProvider>(
      builder: (context, colors, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bankalt',
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.mainWhite,
            primaryColor: colors.main,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: colors.main,
              secondary: colors.secondary,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: colors.main,
              foregroundColor: Colors.white,
            ),
          ),
          home: FormScreen(),
        );
      },
    );
  }
}

