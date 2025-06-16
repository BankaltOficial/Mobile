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
import 'package:flutter_application_1/service/Sessao.dart';
import 'package:flutter_application_1/service/Usuario.dart';

class PoupancaScreen extends StatefulWidget {
  const PoupancaScreen({super.key});

  @override
  State<PoupancaScreen> createState() => _PoupancaScreenState();
}

class _PoupancaScreenState extends State<PoupancaScreen> {
  String selectedFilter = 'Comum';
  String selectedSubFilter = 'Todos';
  Usuario? usuario;
  bool isLoading = true;

  List<Map<String, String>> allItems = [
    {
      'tipo': 'Comum',
      'title': 'Poupança',
      'invMin': 'R\$ 1,00',
      'resgate': 'Imediato',
      'ir': 'Progressivo',
    },
  ];

  @override
  void initState() {
    super.initState();
    _carregarUsuarioLogado();
  }

  Future<void> _carregarUsuarioLogado() async {
    try {
      setState(() {
        isLoading = true;
      });

      // Garantir que a sessão está inicializada
      await Sessao.inicializar();

      // Recarregar dados do usuário
      await Sessao.recarregarUsuario();

      // Obter usuário da sessão
      Usuario? usuarioAtual = Sessao.getUsuario();

      if (usuarioAtual != null) {
        setState(() {
          usuario = usuarioAtual;
          isLoading = false;
        });
        print(
            "Usuário carregado: ${usuarioAtual.nome}, Saldo: R\$ ${usuarioAtual.saldo}");
      } else {
        // Se não há usuário logado, redirecionar para login
        print("Nenhum usuário logado encontrado");
        setState(() {
          isLoading = false;
        });
        _redirecionarParaLogin();
      }
    } catch (e) {
      print("Erro ao carregar usuário: $e");
      setState(() {
        isLoading = false;
      });
      _mostrarErro("Erro ao carregar dados do usuário");
    }
  }

  void _redirecionarParaLogin() {
    // Implementar redirecionamento para tela de login
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    _mostrarErro("Usuário não está logado");
  }

  void _mostrarErro(String mensagem) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagem),
          backgroundColor: Colors.red,
        ),
      );
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
    if (usuario == null) {
      _mostrarErro("Usuário não está logado");
      return;
    }

    showDialog(
      context: context,
      builder: (context) => InvestirDialog(
        nomeAtivo: item['title']!,
        tipoAtivo: selectedFilter,
        investimentoMinimo: item['invMin']!,
        resgateDisponivel: item['resgate']!,
        usuario: usuario!,
        onInvestimentoRealizado: () async {
          // Recarregar dados do usuário após investimento
          await _carregarUsuarioLogado();
        },
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // Se está carregando, mostrar indicador
    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.theme,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: AppColors.main,
              ),
              SizedBox(height: 16),
              Text(
                'Carregando dados...',
                style: TextStyle(
                  color: AppColors.invertMode,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Se não há usuário, mostrar erro
    if (usuario == null) {
      return Scaffold(
        backgroundColor: AppColors.theme,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 64,
              ),
              SizedBox(height: 16),
              Text(
                'Erro ao carregar usuário',
                style: TextStyle(
                  color: AppColors.invertMode,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Tente fazer login novamente',
                style: TextStyle(
                  color: AppColors.invertMode.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _carregarUsuarioLogado,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.main,
                ),
                child: Text(
                  'Tentar Novamente',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

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
        title: 'Poupança',
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
                      'R\$ ${usuario!.saldo.toStringAsFixed(2).replaceAll('.', ',')}',
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
