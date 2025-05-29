// ignore_for_file: file_names, library_private_types_in_public_api, prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/CardsScreen.dart';
import 'package:flutter_application_1/components/FilterButton.dart';
import 'package:flutter_application_1/pages/inicialScreen.dart';
import 'package:flutter_application_1/pages/InvestimentoScreen.dart';
import 'package:flutter_application_1/pages/InvestirScreen.dart';
import 'package:flutter_application_1/pages/PixScreen.dart';
import 'package:flutter_application_1/components/SubFilterButton.dart';
import 'package:flutter_application_1/components/InvestCard.dart';

class RendafixaScreen extends StatefulWidget {
  const RendafixaScreen({super.key});

  @override
  State<RendafixaScreen> createState() => _RendafixaScreenState();
}

class _RendafixaScreenState extends State<RendafixaScreen> {
  String selectedFilter = 'CDB';
  String selectedSubFilter = 'Todos';

  List<Map<String, String>> allItems = [
    {
      'tipo': 'CDB',
      'title': 'CDB POS DI LIQUIDEZ DIÁRIA',
      'invMin': 'R\$ 10,00',
      'resgate': 'Imediato',
      'ir': 'Regressivo',
    },
    {
      'tipo': 'CDB',
      'title': 'CDB XP LIQUIDEZ 7 DIAS',
      'invMin': 'R\$ 50,00',
      'resgate': '7 dias',
      'ir': 'Regressivo',
    },
    {
      'tipo': 'CDB',
      'title': 'CDB 180 DIAS 110% CDI',
      'invMin': 'R\$ 100,00',
      'resgate': '180 dias',
      'ir': 'Regressivo',
    },
    {
      'tipo': 'CDB',
      'title': 'CDB 15 DIAS 102% CDI',
      'invMin': 'R\$ 30,00',
      'resgate': '15 dias',
      'ir': 'Regressivo',
    },
    {
      'tipo': 'LCA/LCI',
      'title': 'LCI DI 1080',
      'invMin': 'R\$ 150,00',
      'resgate': '25/12/2024',
      'ir': 'Isento',
    },
    {
      'tipo': 'LCA/LCI',
      'title': 'LCI DE LIQUIDEZ 30 DIAS',
      'invMin': 'R\$ 30,00',
      'resgate': '30 dias',
      'ir': 'Isento',
    },
    {
      'tipo': 'LCA/LCI',
      'title': 'LCA 90 DIAS 97% CDI',
      'invMin': 'R\$ 200,00',
      'resgate': '90 dias',
      'ir': 'Isento',
    },
    {
      'tipo': 'TD',
      'title': 'Tesouro IPCA+ 2029',
      'invMin': 'R\$ 100,00',
      'resgate': '2029',
      'ir': 'Regressivo',
    },
    {
      'tipo': 'TD',
      'title': 'Tesouro Selic 2025',
      'invMin': 'R\$ 120,00',
      'resgate': '2027',
      'ir': 'Regressivo',
    },
    {
      'tipo': 'TD',
      'title': 'Tesouro Pré-Fixado 2026',
      'invMin': 'R\$ 150,00',
      'resgate': '2026',
      'ir': 'Regressivo',
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
                      'Renda fixa',
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
                  text: 'CDB',
                  isSelected: selectedFilter == 'CDB',
                  onTap: () => setState(() => selectedFilter = 'CDB'),
                ),
                FilterButton(
                  text: 'LCA/LCI',
                  isSelected: selectedFilter == 'LCA/LCI',
                  onTap: () => setState(() => selectedFilter = 'LCA/LCI'),
                ),
                FilterButton(
                  text: 'TD',
                  isSelected: selectedFilter == 'TD',
                  onTap: () => setState(() => selectedFilter = 'TD'),
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
                Expanded(
                  child: SubFilterButton(
                    text: 'Resgate rápido',
                    isSelected: selectedSubFilter == 'Resgate rápido',
                    onTap: () =>
                        setState(() => selectedSubFilter = 'Resgate rápido'),
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
