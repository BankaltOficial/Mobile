// ignore_for_file: unused_import, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/BoletoScreen.dart';
import 'package:flutter_application_1/pages/ConfiguracaoScreen.dart';
import 'package:flutter_application_1/pages/DadosPessoaisScreen.dart';
import 'package:flutter_application_1/pages/EmprestimoScreen.dart';
import 'package:flutter_application_1/pages/CardsScreen.dart';
import 'package:flutter_application_1/pages/DescricaoScreen.dart';
import 'package:flutter_application_1/pages/EducationScreen.dart';
import 'package:flutter_application_1/pages/FormScreen.dart';
import 'package:flutter_application_1/pages/InvestimentoScreen.dart';
import 'package:flutter_application_1/pages/InvestirScreen.dart';
import 'package:flutter_application_1/pages/MinhasChaves.dart';
import 'package:flutter_application_1/pages/PerfilInvestidorScreen.dart';
import 'package:flutter_application_1/pages/PerfilScreen.dart';
import 'package:flutter_application_1/pages/PixPagarScreen.dart';
import 'package:flutter_application_1/pages/PoupancaScreen.dart';
import 'package:flutter_application_1/pages/ReceberPixScreen.dart';
import 'package:flutter_application_1/pages/RendaFixaScreen.dart';
import 'package:flutter_application_1/pages/RendavariavelScreen.dart';
import 'package:flutter_application_1/pages/ResgateScreen.dart';
import 'package:flutter_application_1/pages/SplashScreen.dart';
import 'package:flutter_application_1/pages/TermsScreen.dart';
import 'package:flutter_application_1/pages/TransferenciaScreen.dart';
import 'package:flutter_application_1/pages/WelcomeScreen.dart';
import 'package:flutter_application_1/pages/InicialScreen.dart';
import 'package:flutter_application_1/pages/PixScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/ColorsProvider.dart';
import 'package:flutter_application_1/service/ColorsService.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
    final colorProvider = Provider.of<ColorProvider>(context);

    return Consumer<ColorProvider>(
      builder: (context, colors, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Bankalt',
          theme: ThemeData(
            fontFamily: 'Poppins',
            scaffoldBackgroundColor: colorProvider.theme,
            primaryColor: colors.main,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: colors.main,
              secondary: colors.secondary,
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: colors.main,
              foregroundColor: AppColors.mainWhite,
            ),
          ),
          home: SplashScreen(),
        );
      },
    );
  }
}
