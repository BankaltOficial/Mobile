// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/CardsScreen.dart';
import 'package:flutter_application_1/pages/PerfilInvestidorScreen.dart';
import 'package:flutter_application_1/pages/PixScreen.dart';
import 'package:flutter_application_1/pages/ResgateScreen.dart';
import 'package:flutter_application_1/pages/WelcomeScreen.dart';
import 'InicialScreen.dart';
import 'InvestirScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/ColorsProvider.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:provider/provider.dart';

class InvestimentoScreen extends StatefulWidget {
  const InvestimentoScreen({super.key});

  @override
  State<InvestimentoScreen> createState() => _InvestimentoScreenState();
}

class _InvestimentoScreenState extends State<InvestimentoScreen> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final colors = Provider.of<ColorProvider>(context);

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
                        'Pagina inicial',
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
                  color: colors.main,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: mainPurpleWeak,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total investido',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'R\$ 350,90',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InvestirScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: mainPurple,
                        radius: 45,
                        child: Image.asset("assets/icons/Investir.png",
                            height: 50, width: 50)),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Investir",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Aplique seu dinheiro de forma segura e prática,\npara alcançar seus objetivos financeiros.",
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const PerfilInvestidorScreen()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: mainPurple,
                      radius: 45,
                      child: Icon(
                        Icons.person,
                        color: mainWhite,
                        size: 50,
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Perfil de investidor",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Identifique seu perfil financeiro, recomendando \ninvestimentos alinhados ao seu nível de \nexperiência e tolerância ao risco.",
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ResgateScreen()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                    CircleAvatar(
                        backgroundColor: mainPurple,
                        radius: 45,
                        child: Image.asset("assets/icons/Resgate.png",
                            height: 50, width: 50)),
                    SizedBox(width: 20),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Resgate",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Retirar o valor investido de forma rápida e \nfácil, diretamente para a sua conta.",
                          style: TextStyle(fontSize: 14),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
