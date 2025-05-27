// ignore_for_file: unused_import, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/FormScreen.dart';
import 'package:flutter_application_1/InvestimentoScreen.dart';
import 'package:flutter_application_1/InvestirScreen.dart';
import 'package:flutter_application_1/PoupancaScreen.dart';
import 'package:flutter_application_1/RendaFixaScreen.dart';
import 'package:flutter_application_1/RendavariavelScreen.dart';
import 'package:flutter_application_1/SplashScreen.dart';
import 'package:flutter_application_1/TermsScreen.dart';
import 'package:flutter_application_1/WelcomeScreen.dart';
import 'package:flutter_application_1/inicialScreen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BankAlt',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:RendavariavelScreen(),
    );
  }
}