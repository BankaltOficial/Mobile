import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/WelcomeScreen.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

Color colorBlue = Color(0xFF353DAB);
Color colorWhite = Color(0xFFF0EFF4); 

class _SplashScreenState extends State<SplashScreen> {
  
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Welcomescreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedOpacity(
          duration: Duration(seconds: 2),
          opacity: _opacity,
        child: Image.asset("assets/images/LogoBANKALTsemfundo1.png", width: 1000),
      ),
      )
    );
  }
}