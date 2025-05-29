// ignore: file_name
// ignore_for_file: use_key_in_widget_constructors, file_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/WelcomeScreen.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

Color colorWhite = const Color(0xFFF0EFF4);
Color lightPurple = const Color(0xFFCBCBE5);
Color colorPurple = const Color(0xFF353DAB);
Color colorBlue = const Color(0xFF027BD4);

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

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
