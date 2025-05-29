// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/inicialScreen.dart';

class PixScreen extends StatefulWidget {
  const PixScreen({super.key});

  @override
  State<PixScreen> createState() => _PixScreenState();
}

class _PixScreenState extends State<PixScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "PIX",
            style: TextStyle(color: mainWhite),
          ),
          centerTitle: true,
          backgroundColor: mainPurple,
        ),
        body: ListView(
          children: [
            Container(
              padding: EdgeInsets.all(40),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                  side: BorderSide(color: mainPurple, width: 2),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.account_balance_wallet_outlined,
                                      size: 60, color: mainPurple),
                                  SizedBox(height: 10),
                                  Text("Pagar",
                                      style: TextStyle(
                                          fontSize: 20, color: mainPurple)),
                                ],
                              )),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                            flex: 1,
                            child: ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    side:
                                        BorderSide(color: mainPurple, width: 2),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.qr_code,
                                        size: 60, color: mainPurple),
                                    SizedBox(height: 10),
                                    Text("Receber",
                                        style: TextStyle(
                                            fontSize: 20, color: mainPurple)),
                                  ],
                                )))
                      ]),
                  SizedBox(height: 10),
                  ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          side: BorderSide(color: mainPurple, width: 2),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Minhas chaves",
                              style:
                                  TextStyle(fontSize: 20, color: mainPurple)),
                          Icon(Icons.key_rounded, size: 60, color: mainPurple),
                        ],
                      )),
                  SizedBox(
                    height: 30,
                  ),
                  Text("Registre sua chave",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                  Text("Não tem uma chave ainda?"),
                  Text("Cadastre agora!"),
                  SizedBox(height: 30),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                                backgroundColor: mainPurple),
                            child: Text(
                              "Cadastrar",
                              style: TextStyle(color: mainWhite),
                            )),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const InicialScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 32),
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          child: const Text(
                            "Cancelar",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ])
                ],
              ),
            )
          ],
        ));
  }
}
