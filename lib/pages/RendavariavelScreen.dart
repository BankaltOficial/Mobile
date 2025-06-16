// ignore_for_file: file_names, library_private_types_in_public_api, prefer_const_constructors, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/components/FilterButton.dart';
import 'package:flutter_application_1/pages/InvestirScreen.dart';
import 'package:flutter_application_1/components/SubFilterButton.dart';
import 'package:flutter_application_1/components/InvestirCard.dart';
import 'package:flutter_application_1/components/InvestirDialog.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/UsuarioService.dart';

class RendavariavelScreen extends StatefulWidget {
  const RendavariavelScreen({super.key});

  @override
  State<RendavariavelScreen> createState() => _RendavariavelScreenState();
}

class _RendavariavelScreenState extends State<RendavariavelScreen> {
  String selectedFilter = 'Ações';
  String selectedSubFilter = 'Todos';
  Usuario? usuarioLogado;

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

  @override
  void initState() {
    super.initState();
    _carregarUsuarioLogado();
  }

  Future<void> _carregarUsuarioLogado() async {
    int? usuarioId = await UsuarioService.carregarUsuarioLogado();
    if (usuarioId != null) {
      List<Usuario> usuarios = await UsuarioService.carregarUsuarios();
      setState(() {
        usuarioLogado = usuarios.firstWhere((u) => u.id == usuarioId);
      });
    }
  }

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

  void _mostrarDialogInvestimento(Map<String, String> item) {
    if (usuarioLogado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Usuário não encontrado. Faça login novamente.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => InvestirDialog(
        nomeAtivo: item['title']!,
        tipoAtivo: selectedFilter,
        investimentoMinimo: item['invMin']!,
        resgateDisponivel: item['resgate']!,
        usuario: usuarioLogado!,
        onInvestimentoRealizado: () {
          _carregarUsuarioLogado(); // Recarrega os dados do usuário
        },
      ),
    );
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
      backgroundColor: AppColors.theme,
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Renda Variavel',
        scaffoldKey: _scaffoldKey,
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const InvestirScreen()),
          );
        },
      ),
      drawer: CustomDrawer(),
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
                  text: 'BDR',
                  isSelected: selectedFilter == 'BDR',
                  onTap: () => setState(() => selectedFilter = 'BDR'),
                ),
                FilterButton(
                  text: 'ETF',
                  isSelected: selectedFilter == 'ETF',
                  onTap: () => setState(() => selectedFilter = 'ETF'),
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
            if (usuarioLogado != null) ...[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.main.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Seu Saldo:',
                        style: TextStyle(
                          color: AppColors.invertMode,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'R\$ ${usuarioLogado!.saldo.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: TextStyle(
                          color: AppColors.invertModeMain,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            Expanded(
              child: ListView(
                children: filteredItems.map((item) {
                  return InvestirCard(
                    title: item['title']!,
                    invMin: item['invMin']!,
                    resgate: item['resgate']!,
                    ir: item['ir']!,
                    tipoAtivo: selectedFilter,
                    onTap: () => _mostrarDialogInvestimento(item),
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
