import 'package:flutter/material.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  Color mainBlue = const Color(0xFF353DAB);
  Color mainBlueWeak = const Color.fromARGB(51, 53, 61, 171);
  Color mainWhite = const Color(0xFFFFFFFF);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: mainBlue,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  'Vem ser BankAlt',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: mainWhite,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Alertamos que ao criar uma nova conta  você obrigatoriamente irá concordar com nossos Termos e documentos de relacionados com a Privacidade",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: mainWhite,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.check_circle, color: mainWhite),
                    const SizedBox(width: 8),
                    Text(
                      "Li, estou ciente e concordo",
                      style: TextStyle(
                        fontSize: 16,
                        color: mainWhite,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Text(
                  "Ainda não li os documentos",
                  style: TextStyle(
                    fontSize: 15,
                    color: mainWhite,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Ação do botão "Li, estou ciente e concordo"
                    Navigator.pushNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainBlueWeak,
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
    );
  }
}
