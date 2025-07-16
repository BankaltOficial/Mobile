// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/ConsultaInvestimentoScreen.dart';
import 'package:flutter_application_1/pages/PerfilInvestidorScreen.dart';
import 'package:flutter_application_1/pages/ResgateScreen.dart';
import 'InicialScreen.dart';
import 'InvestirScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/service/Sessao.dart';
import 'package:flutter_application_1/service/InvestimentoService.dart';

class InvestimentoScreen extends StatefulWidget {
  const InvestimentoScreen({super.key});

  @override
  State<InvestimentoScreen> createState() => _InvestimentoScreenState();
}

class _InvestimentoScreenState extends State<InvestimentoScreen> {
  double totalInvestido = 0.0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarTotalInvestido();
  }

  Future<void> _carregarTotalInvestido() async {
    try {
      // Verificar se há usuário logado
      if (Sessao.isUsuarioLogado()) {
        int usuarioId = Sessao.getUsuario()!.id;
        double total = await InvestimentoService.calcularTotalInvestido(usuarioId);
        
        setState(() {
          totalInvestido = total;
          isLoading = false;
        });
      } else {
        setState(() {
          totalInvestido = 0.0;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Erro ao carregar total investido: $e');
      setState(() {
        totalInvestido = 0.0;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: AppColors.theme,
      key: scaffoldKey,
      appBar: CustomAppBar(
        title: 'Investimento', 
        scaffoldKey: scaffoldKey, 
        onBackPressed: () {
          Navigator.pushReplacement(
            context, 
            MaterialPageRoute(builder: (context) => const InicialScreen())
          );
        }
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.mainWeak,
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
                        color: AppColors.invertMode
                      ),
                    ),
                    SizedBox(height: 8),
                    isLoading 
                      ? CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.invertMode),
                        )
                      : Text(
                          'R\$ ${totalInvestido.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 24,
                            color: AppColors.invertMode
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
                        backgroundColor: AppColors.main,
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
                              fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.invertMode),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Aplique seu dinheiro de forma segura e prática,\npara alcançar seus objetivos financeiros.",
                          style: TextStyle(fontSize: 14, color: AppColors.invertMode),
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
                      backgroundColor: AppColors.main,
                      radius: 45,
                      child: Icon(
                        Icons.person,
                        color: AppColors.mainWhite,
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
                              fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.invertMode),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Identifique seu perfil financeiro, recomendando \ninvestimentos alinhados ao seu nível de \nexperiência e tolerância ao risco.",
                          style: TextStyle(fontSize: 14, color: AppColors.invertMode),
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
                        backgroundColor: AppColors.main,
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
                              fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.invertMode),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Retirar o valor investido de forma rápida e \nfácil, diretamente para a sua conta.",
                          style: TextStyle(fontSize: 14, color: AppColors.invertMode),
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
                      builder: (context) => ConsultaInvestimentoScreen()),
                );
              },
              child: Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.main,
                      radius: 45,
                      child: Icon(
                        Icons.search,
                        color: AppColors.mainWhite,
                        size: 50,
                      ),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Consulta de investimentos",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.invertMode),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Acompanhe o desempenho\ndos seus investimentos, visualizando\ninformações detalhadas sobre cada um.",
                          style: TextStyle(fontSize: 14, color: AppColors.invertMode),
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