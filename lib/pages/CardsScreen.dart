// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/InicialScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/components/Card.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/Sessao.dart';

class CardsScreen extends StatefulWidget {
  const CardsScreen({super.key});

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {
  @override
  Widget build(BuildContext context) {
    Usuario usuario = Sessao.getUsuario() ??
        Usuario('Usuário', 'CPF não encontrado', '', '', '', '', '');
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
          title: 'Cartões Virtuais',
          scaffoldKey: scaffoldKey,
          onBackPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const InicialScreen()));
          }),
      drawer: const CustomDrawer(),
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Text(
              "Escolha o cartão",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.invertModeGray),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                const SizedBox(height: 20),
                CreditCardWidget(
                  cardNumber: usuario.numeroCartao,
                  holderName: usuario.nome,
                  expiryDate: usuario.validadeCartao,
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: AppColors.invertModeGray,
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: AppColors.invertModeGray,
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        color: AppColors.invertModeGray,
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
                                      color: AppColors.main, size: 50)),
                              Text("Apagar",
                                  style: TextStyle(
                                      color: AppColors.main,
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
                                      color: AppColors.main, size: 50)),
                              Text("Bloquear",
                                  style: TextStyle(
                                      color: AppColors.main,
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
