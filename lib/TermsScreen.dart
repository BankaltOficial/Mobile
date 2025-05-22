// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/FormScreen.dart';
import 'package:flutter_application_1/WelcomeScreen.dart';
import 'package:flutter_application_1/inicialScreen.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {

  bool isChecked = false;
  Icon icon = const Icon(Icons.check_circle, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: mainWhite),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const WelcomeScreen(),
              ),
            );
          },
        ),
        title: Text(
          'bankalt',
          style: TextStyle(color: mainWhite, fontWeight: FontWeight.bold),
        ),
        backgroundColor: mainPurple,
        centerTitle: true,
      ),
      body: Container(
        color: mainPurple,
        child: SizedBox.expand(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/Logo.png',
                      height: 200,
                      width: 200,
                    ),
                    Text(
                      'Vem ser BankAlt',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: mainWhite,
                      ),
                    ),
                    const SizedBox(height: 80),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16,
                          color: mainWhite,
                        ),
                        children: [
                          const TextSpan(
                            text:
                                "Alertamos que ao criar uma nova conta você obrigatoriamente irá concordar com nossos ",
                          ),
                          TextSpan(
                            text: "Termos",
                            style: TextStyle(
                                color: mainYellow, fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(
                            text: " e documentos relacionados com a ",
                          ),
                          TextSpan(
                            text: "Privacidade",
                            style: TextStyle(
                                color: mainYellow, fontWeight: FontWeight.bold),
                          ),
                          const TextSpan(
                            text: " de forma confidencial.",
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              SnackBar(
                                content: Text(
                                  "Você deve ler os documentos antes de continuar.",
                                  style: TextStyle(color: mainWhite),
                                ),
                                backgroundColor: mainPurple,
                              );
                              isChecked = !isChecked;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: mainWhite,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.all(0),
                            minimumSize: Size(35, 35),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Icon(
                            isChecked
                                ? Icons.check_circle
                                : Icons.check_box_outline_blank,
                            color: mainBlue,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Li, estou ciente e concordo",
                          style: TextStyle(
                            fontSize: 16,
                            color: mainWhite,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                    Text(
                      "Ainda não leu os documentos?",
                      style: TextStyle(
                        fontSize: 15,
                        color: mainWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        
                      },
                      child: Text(
                      "Baixe aqui!",
                      style: TextStyle(
                        fontSize: 15,
                        color: mainWhite,
                      ),
                    ),),
                    const SizedBox(height: 50),
                    ElevatedButton(
                      onPressed: () {
                        if (isChecked) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const FormScreen(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Você deve concordar com os documentos antes de continuar.",
                                style: TextStyle(color: mainWhite),
                              ),
                              backgroundColor: mainPurple,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainBlue,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "CONTINUAR",
                        style: TextStyle(
                          fontSize: 16,
                          color: mainWhite,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
