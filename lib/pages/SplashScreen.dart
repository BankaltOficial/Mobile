// ignore: file_name
// ignore_for_file: use_key_in_widget_constructors, file_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/WelcomeScreen.dart';
import 'package:flutter_application_1/service/Sessao.dart';
import 'package:flutter_application_1/service/ColorsProvider.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;
  Usuario? usuario;
  late Color mainColor;
  late Color secondaryColor;
  late Color tertiaryColor;
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();
    /*usuario = Sessao.getUsuario();
    final provider = Provider.of<ColorProvider>(context, listen: false);
    if (usuario == null || usuario!.nome == "Usuário") {
      provider.resetColors();
    print("Usuário não encontrado, resetando cores.");
    }*/
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: AnimatedOpacity(
        duration: const Duration(seconds: 2),
        opacity: _opacity,
        child:
            Image.asset("assets/images/LogoBANKALTsemfundo1.png", width: 1000),
      ),
    ));
  }
}
