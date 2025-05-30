// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/CardsScreen.dart';
import 'package:flutter_application_1/pages/InvestimentoScreen.dart';
import 'package:flutter_application_1/pages/WelcomeScreen.dart';
import 'package:flutter_application_1/pages/inicialScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';

class PixScreen extends StatefulWidget {
  const PixScreen({super.key});

  @override
  State<PixScreen> createState() => _PixScreenState();
}

class _PixScreenState extends State<PixScreen> {
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: mainPurple,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.menu, color: mainWhite),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'bankalt',
                        style: TextStyle(
                          color: mainWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: mainWhite),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InicialScreen()),
                      );
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'PIX',
                        style: TextStyle(
                          color: mainWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: AppColors.main,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: mainWhite,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home_filled),
                title: Text('Página inicial'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InicialScreen()),
                  );
                },
              ),
              ListTile(
                leading: Image.asset("assets/icons/pixColorido.png",
                    width: 20, height: 20),
                title: Text('PIX'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PixScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.bar_chart),
                title: Text('Investimentos'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InvestimentoScreen()),
                  );
                },
              ),
              ListTile(
                leading: Image.asset("assets/icons/cartoesColorido.png",
                    height: 30, width: 30),
                title: Text('Cartões'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CardsScreen()),
                  );
                },
              ),
              Divider(
                color: Colors.grey,
                height: 1,
                thickness: 1,
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Configurações'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CardsScreen()),
                  );
                },
              ),
            ],
          ),
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
