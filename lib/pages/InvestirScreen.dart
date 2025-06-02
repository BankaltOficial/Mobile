// ignore_for_file: file_names, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/InvestimentoScreen.dart';
import 'package:flutter_application_1/pages/PoupancaScreen.dart';
import 'package:flutter_application_1/pages/RendafixaScreen.dart';
import 'package:flutter_application_1/pages/RendavariavelScreen.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/service/Colors.dart';

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
      appBar: CustomAppBar(title: 'Investir', scaffoldKey: _scaffoldKey, onBackPressed: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const InvestimentoScreen()));
      }),
      drawer: CustomDrawer(),
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
                    MaterialPageRoute(
                        builder: (context) => const PoupancaScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.main,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Column(
                    children: [
                      Text(
                        "Poupança",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.mainWhite),
                      ),
                      Divider(),
                      Text(
                        "É um investimento seguro, de fácil acesso e com resgate imediato, ideal para guardar dinheiro no curto prazo.",
                        style: TextStyle(fontSize: 16, color: AppColors.mainWhite),
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
                    MaterialPageRoute(
                        builder: (context) => const RendafixaScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.main,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Column(
                    children: [
                      Text(
                        "Renda fixa",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.mainWhite),
                      ),
                      Divider(),
                      Text(
                        "Oferece investimentos com baixo risco e retorno previsível, como CDBs e Tesouro Direto, ideais para quem busca segurança e estabilidade.",
                        style: TextStyle(fontSize: 16, color: AppColors.mainWhite),
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
                    MaterialPageRoute(
                        builder: (context) => const RendavariavelScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.main,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Column(
                    children: [
                      Text(
                        "Renda variável",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.mainWhite),
                      ),
                      Divider(),
                      Text(
                        "A renda variável inclui investimentos como ações e fundos imobiliários, com maior risco, mas potencial de ganhos superiores no longo prazo.",
                        style: TextStyle(fontSize: 16, color: AppColors.mainWhite),
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.main,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Column(
                    children: [
                      Text(
                        "Fundo de investimentos",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.mainWhite),
                      ),
                      Divider(),
                      Text(
                        "Os fundos de investimento juntam o dinheiro de várias pessoas e um gestor decide onde investir, facilitando a diversificação.",
                        style: TextStyle(fontSize: 16, color: AppColors.mainWhite),
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
