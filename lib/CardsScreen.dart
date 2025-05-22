import 'package:flutter/material.dart';
import 'package:flutter_application_1/inicialScreen.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/colors_service.dart';
import 'package:flutter_application_1/colors_provider.dart';
import 'package:provider/provider.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<ColorProvider>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: mainWhite),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const InicialScreen(),
              ),
            );
          },
        ),
        title: Text(
          'bankalt',
          style: TextStyle(color: mainWhite, fontWeight: FontWeight.bold),
        ),
        backgroundColor: colors.main,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Text(
              "Escolha o cartão",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: grayBlue),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  height: 200,
                  width: 300,
                  decoration: BoxDecoration(
                    color: mainBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: grayBlue,
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: grayBlue,
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: grayBlue,
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.delete,
                                      color: colors.main, size: 50)),
                              Text("Apagar",
                                  style: TextStyle(
                                      color: colors.main,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 50),
                    const SizedBox(width: 50),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.lock,
                                      color: colors.main, size: 50)),
                              Text("Bloquear",
                                  style: TextStyle(
                                      color: colors.main,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
