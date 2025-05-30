// ignore_for_file: file_names, library_private_types_in_public_api, prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/CardsScreen.dart';
import 'package:flutter_application_1/components/FilterButton.dart';
import 'package:flutter_application_1/pages/InvestimentoScreen.dart';
import 'package:flutter_application_1/pages/InvestirScreen.dart';
import 'package:flutter_application_1/pages/PixScreen.dart';
import 'package:flutter_application_1/components/SubFilterButton.dart';
import 'package:flutter_application_1/components/InvestCard.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'inicialScreen.dart';

class RendavariavelScreen extends StatefulWidget {
  const RendavariavelScreen({super.key});

  @override
  State<RendavariavelScreen> createState() => _RendavariavelScreenState();
}

class _RendavariavelScreenState extends State<RendavariavelScreen> {
  String selectedFilter = 'Ações';
  String selectedSubFilter = 'Todos';

  List<Map<String, String>> allItems = [
    {
      'tipo': 'Ações',
      'title': 'Ação PETR4',
      'invMin': 'R\$ 35,00',
      'resgate': 'D+2',
      'ir': 'Isento (até 20 mil)',
    },
    {
      'tipo': 'Ações',
      'title': 'Ação ITUB4',
      'invMin': 'R\$ 30,00',
      'resgate': 'D+2',
      'ir': 'Isento (até 20 mil)',
    },
    {
      'tipo': 'FII',
      'title': 'FII HGLG11',
      'invMin': 'R\$ 120,00',
      'resgate': 'D+2',
      'ir': 'Isento',
    },
    {
      'tipo': 'FII',
      'title': 'FII KNRI11',
      'invMin': 'R\$ 140,00',
      'resgate': 'D+2',
      'ir': 'Isento',
    },
    {
      'tipo': 'ETF',
      'title': 'ETF BOVA11',
      'invMin': 'R\$ 110,00',
      'resgate': 'D+2',
      'ir': '15% sobre lucro',
    },
    {
      'tipo': 'ETF',
      'title': 'ETF IVVB11',
      'invMin': 'R\$ 130,00',
      'resgate': 'D+2',
      'ir': '15% sobre lucro',
    },
    {
      'tipo': 'BDR',
      'title': 'BDR AAPL34',
      'invMin': 'R\$ 50,00',
      'resgate': 'D+2',
      'ir': '15% sobre lucro',
    },
    {
      'tipo': 'BDR',
      'title': 'BDR TSLA34',
      'invMin': 'R\$ 60,00',
      'resgate': 'D+2',
      'ir': '15% sobre lucro',
    },
  ];

  bool isResgateRapido(String resgate) {
    if (resgate.toLowerCase().contains('imediato')) return true;
    final regex = RegExp(r'(\d+)\s*dias');
    final match = regex.firstMatch(resgate);
    if (match != null) {
      final dias = int.tryParse(match.group(1) ?? '');
      return dias != null && dias <= 30;
    }
    return false;
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    var filteredItems = allItems.where((item) {
      final tipoOk = item['tipo'] == selectedFilter;

      if (selectedSubFilter == 'Todos') {
        return tipoOk;
      } else if (selectedSubFilter == 'Resgate rápido') {
        return tipoOk && isResgateRapido(item['resgate'] ?? '');
      }

      return false;
    }).toList();

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
                          builder: (context) => const InvestirScreen()),
                    );
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'Renda variável',
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
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterButton(
                  text: 'Ações',
                  isSelected: selectedFilter == 'Ações',
                  onTap: () => setState(() => selectedFilter = 'Ações'),
                ),
                FilterButton(
                  text: 'ETF',
                  isSelected: selectedFilter == 'ETF',
                  onTap: () => setState(() => selectedFilter = 'ETF'),
                ),
                FilterButton(
                  text: 'BDR',
                  isSelected: selectedFilter == 'BDR',
                  onTap: () => setState(() => selectedFilter = 'BDR'),
                ),
                FilterButton(
                  text: 'FII',
                  isSelected: selectedFilter == 'FII',
                  onTap: () => setState(() => selectedFilter = 'FII'),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: SubFilterButton(
                    text: 'Todos',
                    isSelected: selectedSubFilter == 'Todos',
                    onTap: () => setState(() => selectedSubFilter = 'Todos'),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: filteredItems.map((item) {
                  return InvestCard(
                    title: item['title']!,
                    invMin: item['invMin']!,
                    resgate: item['resgate']!,
                    ir: item['ir']!,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
