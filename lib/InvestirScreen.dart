// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/CardsScreen.dart';
import 'package:flutter_application_1/InvestimentoScreen.dart';
import 'package:flutter_application_1/PixScreen.dart';
import 'package:flutter_application_1/PoupancaScreen.dart';
import 'package:flutter_application_1/RendafixaScreen.dart';
import 'inicialScreen.dart';

class InvestirScreen extends StatefulWidget {
  const InvestirScreen({super.key});

  @override
  State<InvestirScreen> createState() => _InvestirScreenState();
}

class _InvestirScreenState extends State<InvestirScreen> {
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
                      MaterialPageRoute(builder: (context) => const InvestimentoScreen()),
                    );
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Investir',
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
                color: mainPurple,
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
                  MaterialPageRoute(builder: (context) => const InicialScreen()),
                );
              },
            ),
            ListTile(
              leading: Image.asset("assets/icons/pixColorido.png", width: 20, height: 20),
              title: Text('PIX'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const PixScreen()),
                );
              },
            ),
            ListTile(
              leading:Icon(Icons.bar_chart),
              title: Text('Investimentos'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const InvestimentoScreen()),
                );
              },
            ),
            ListTile(
              leading:Image.asset("assets/icons/cartoesColorido.png", height: 30, width: 30),
              title: Text('Cartões'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const CardsScreen()),
                );
              },
            ),
            Divider(),
            ListTile(
              leading:Icon(Icons.settings),
              title: Text('Configurações'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const CardsScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const PoupancaScreen()),
                  );
                },
                child: 
                Container(
                  decoration: BoxDecoration(
                    color: mainPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Poupança",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: mainWhite),
                      ),
                      Divider(),
                      Text(
                        "É um investimento seguro, de fácil acesso e com resgate imediato, ideal para guardar dinheiro no curto prazo.",
                        style: TextStyle(fontSize: 16, color: mainWhite),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const RendafixaScreen()),
                );
              },
              child: 
              Container(
                  decoration: BoxDecoration(
                    color: mainPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Renda fixa",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: mainWhite),
                      ),
                      Divider(),
                      Text(
                        "Oferece investimentos com baixo risco e retorno previsível, como CDBs e Tesouro Direto, ideais para quem busca segurança e estabilidade.",
                        style: TextStyle(fontSize: 16, color: mainWhite),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  
                },
                child:
                Container(
                  decoration: BoxDecoration(
                    color: mainPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Renda variável",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: mainWhite),
                      ),
                      Divider(),
                      Text(
                        "A renda variável inclui investimentos como ações e fundos imobiliários, com maior risco, mas potencial de ganhos superiores no longo prazo.",
                        style: TextStyle(fontSize: 16, color: mainWhite),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                
              },
              child: 
                Container(
                  decoration: BoxDecoration(
                    color: mainPurple,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        "Fundo de investimentos",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: mainWhite),
                      ),
                      Divider(),
                      Text(
                        "Os fundos de investimento juntam o dinheiro de várias pessoas e um gestor decide onde investir, facilitando a diversificação.",
                        style: TextStyle(fontSize: 16, color: mainWhite),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}