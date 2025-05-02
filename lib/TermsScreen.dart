import 'package:flutter/material.dart';
import 'package:flutter_application_1/FormScreen.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  Color mainBlue = const Color(0xFF353DAB);
  Color mainBlue1 = const Color(0xFF027BD4);
  Color mainBlueWeak = const Color.fromARGB(51, 53, 61, 171);
  Color mainWhite = const Color(0xFFFFFFFF);

  bool isChecked = false;
  Icon icon = const Icon(Icons.check_circle, color: Colors.white);

  @override
  Widget build(BuildContext context) {
    var mainYellow = const Color(0xFFFFC700);
    return Scaffold(
      body: Container(
        color: mainBlue,
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
                                backgroundColor: mainBlue1,
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
                    Text(
                      "Baixe aqui!",
                      style: TextStyle(
                        fontSize: 15,
                        color: mainWhite,
                      ),
                    ),
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
                              backgroundColor: mainBlue1,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainBlue1,
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
