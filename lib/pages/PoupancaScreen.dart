// ignore_for_file: file_names, library_private_types_in_public_api, prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/CardsScreen.dart';
import 'package:flutter_application_1/components/FilterButton.dart';
import 'package:flutter_application_1/pages/InvestimentoScreen.dart';
import 'package:flutter_application_1/pages/InvestirScreen.dart';
import 'package:flutter_application_1/pages/PixScreen.dart';
import 'package:flutter_application_1/components/SubFilterButton.dart';
import 'package:flutter_application_1/components/InvestCard.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'InicialScreen.dart';

class PoupancaScreen extends StatefulWidget {
  const PoupancaScreen({super.key});

  @override
  State<PoupancaScreen> createState() => _PoupancaScreenState();
}

class _PoupancaScreenState extends State<PoupancaScreen> {
  String selectedFilter = 'Comum';
  String selectedSubFilter = 'Todos';

  List<Map<String, String>> allItems = [
    {
      'tipo': 'Comum',
      'title': 'Poupança',
      'invMin': 'R\$ 1,00',
      'resgate': 'Imediato',
      'ir': 'Progressivo',
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
        backgroundColor: AppColors.main,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.menu, color: AppColors.mainWhite),
                  onPressed: () {
                    _scaffoldKey.currentState?.openDrawer();
                  },
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      'bankalt',
                      style: TextStyle(
                        color: AppColors.mainWhite,
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
                  icon: Icon(Icons.arrow_back, color: AppColors.mainWhite),
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
                      'Poupança',
                      style: TextStyle(
                        color: AppColors.mainWhite,
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
                  color: AppColors.mainWhite,
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
                  text: 'Comum',
                  isSelected: selectedFilter == 'Comum',
                  onTap: () => setState(() => selectedFilter = 'Comum'),
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
