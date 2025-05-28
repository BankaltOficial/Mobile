// ignore_for_file: file_names, prefer_const_constructors, duplicate_ignore, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/CardsScreen.dart';
import 'package:flutter_application_1/InvestimentoScreen.dart';
import 'package:flutter_application_1/InvestirScreen.dart';
import 'package:flutter_application_1/PixScreen.dart';
import 'package:flutter_application_1/inicialScreen.dart';

class PerfilInvestidorScreen extends StatefulWidget {
  const PerfilInvestidorScreen({super.key});

  @override
  State<PerfilInvestidorScreen> createState() => _PerfilInvestidorScreenState();
}

class _PerfilInvestidorScreenState extends State<PerfilInvestidorScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> perfis = ['CONSERVADOR', 'MODERADO', 'ARROJADO'];
  int perfilIndex = 2;

  void _mostrarSeletorPerfil() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: perfis.asMap().entries.map((entry) {
            int index = entry.key;
            String perfil = entry.value;
            return ListTile(
              leading: Icon(
                perfilIndex == index ? Icons.check_circle : Icons.circle_outlined,
                color: perfilIndex == index ? Colors.green : Colors.grey,
              ),
              title: Text(perfil),
              onTap: () {
                setState(() {
                  perfilIndex = index;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

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
                      'Perfil de Investidor',
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
              leading: Icon(Icons.bar_chart),
              title: Text('Investimentos'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const InvestimentoScreen()),
                );
              },
            ),
            ListTile(
              leading: Image.asset("assets/icons/cartoesColorido.png", height: 30, width: 30),
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
              leading: Icon(Icons.settings),
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
          padding: EdgeInsets.all(25),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Descubra o seu perfil de investidor",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 10),
                Text(
                  "O seu perfil atualmente está ativo como ${perfis[perfilIndex].toLowerCase()}. Você pode mudar o tipo de investidor abaixo:",
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: gray,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.person, color: mainPurple, size: 40,),
                      SizedBox(width: 8),
                      Text.rich(
                        TextSpan(
                          text: 'O seu perfil é ',
                          style: TextStyle(fontSize: 19),
                          children: [
                            TextSpan(
                              text: perfis[perfilIndex],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 30),
                      GestureDetector(
                        onTap: _mostrarSeletorPerfil,
                        child: Text(
                          'Alterar',
                          style: TextStyle(
                            color: mainPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ],
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
