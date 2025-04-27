import 'package:flutter/material.dart';
import 'package:flutter_application_1/inicialScreen.dart';

class PersonalizedScreen extends StatefulWidget {
  const PersonalizedScreen({super.key});

  @override
  State<PersonalizedScreen> createState() => _PersonalizedScreenState();
}

class _PersonalizedScreenState extends State<PersonalizedScreen> {


  Color grayBlue = const Color(0xFF495057);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'bankalt',
          style: TextStyle(color: mainWhite, fontWeight: FontWeight.bold),
        ),
        backgroundColor: mainBlue,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Text(
              "Escolha as cores do seu aplicativo",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: grayBlue),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                      Container(
                        decoration: BoxDecoration(
                        border: Border.all(color: grayBlue, width: 2),
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Cor do botão",
                            style:
                              TextStyle(color: grayBlue, fontSize: 18)),
                          const SizedBox(height: 10),
                          Text("#234765",
                            style: TextStyle(
                              color: mainBlue,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                        ],
                        ),
                      ),
                      ],
                    ),
                    const SizedBox(width: 50),
                    Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                      color: mainBlue,
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainBlue,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                      textStyle: const TextStyle(fontSize: 20),
                    ),
                    child: const Text(
                      "Continuar",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  ColorPicker(
      {required Color pickerColor,
      required Null Function(dynamic color) onColorChanged}) {}
}
