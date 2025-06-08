// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/education/direito-imposto/CodigoConsumidorScreen.dart';
import 'package:flutter_application_1/pages/education/direito-imposto/ImpostoRendaScreen.dart';
import 'package:flutter_application_1/pages/education/direito-imposto/Procon.dart';
import 'package:flutter_application_1/pages/education/direito-imposto/TaxaJurosScreen.dart';
import 'package:flutter_application_1/pages/education/divida-credito/EmprestimoScreen.dart';
import 'package:flutter_application_1/pages/education/divida-credito/EndividamentoScreen.dart';
import 'package:flutter_application_1/pages/education/divida-credito/HipotecaScreen.dart';
import 'package:flutter_application_1/pages/education/divida-credito/FinanciamentoScreen.dart';
import 'package:flutter_application_1/pages/education/divida-credito/CartaoCreditoScreen.dart';
import 'package:flutter_application_1/pages/education/fundamentos/ContaPoupancaScreen.dart';
import 'package:flutter_application_1/pages/education/fundamentos/DespesasScreen.dart';
import 'package:flutter_application_1/pages/education/fundamentos/AnaliseDespesasScreen.dart';
import 'package:flutter_application_1/pages/education/fundamentos/OrcamentoScreen.dart';
import 'package:flutter_application_1/pages/education/fundamentos/ReduzirDespesas.dart';
import 'package:flutter_application_1/pages/education/fundamentos/RendaFixaScreen.dart';
import 'package:flutter_application_1/pages/education/fundamentos/RendaVariavelScreen.dart';
import 'package:flutter_application_1/pages/inicialScreen.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/ColorsProvider.dart';
import 'package:provider/provider.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final colors = Provider.of<ColorProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
          title: 'Educação Financeira',
          scaffoldKey: scaffoldKey,
          onBackPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const InicialScreen(),
              ),
            );
          }),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("Fundamentos Financeiros Pessoais",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.main)),
              const SizedBox(height: 20),
              buildBlock("Renda Fixa",
                  "Renda fixa é o valor que uma empresa ou indivíduo recebe de forma regular e previsível, independentemente das variações nas vendas ou na produção.",
                  () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RendaFixaScreen()));
              }),
              const SizedBox(height: 20),
              buildBlock("Renda Variável",
                  "Diferente da renda fixa, a renda variável é um investimento inconstante, ou seja, não é um tipo de investimento que possa ser previsível no mercado financeiro.",
                  () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RendaVariavelScreen()));
              }),
              const SizedBox(height: 20),
              buildBlock("Despesas", "Despesas são todos os gastos que uma pessoa ou empresa tem ao utilizar recursos para manter o funcionamento de suas atividades ou o seu padrão de vida.", () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DespesasScreen()));
              }),
              const SizedBox(height: 20),
              buildBlock("Análise de Despesas", "A análise de despesas é um dos pilares do controle financeiro, tanto pessoal quanto empresarial. Entender para onde vai seu dinheiro permite decisões mais conscientes e equilibradas.", () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AnaliseDespesasScreen()));
              }),
              const SizedBox(height: 20),
              buildBlock("Reduzir Despesas",
                  "Reduzir despesas com lazer pode ser um desafio, mas com algumas estratégias simples, é possível se divertir sem comprometer o orçamento.",
                  () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ReduzirDespesasScreen()));
              }),
              const SizedBox(height: 20),
              buildBlock("Orçamento",
                  "O orçamento pode ser dividido em três partes, que são o Orçamento pessoal e doméstico, público e empresarial, cada um com um olhar diferente, mas com a mesma pegada.",
                  () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OrcamentoScreen()));
              }),
              const SizedBox(height: 20),
              buildBlock("Conta Poupança",
                  "A conta poupança funciona permitindo que você deposite um dinheiro e ganhe rendimento em cima dessa verba.",
                  () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ContaPoupancaScreen()));
              }),
              const SizedBox(height: 40),
              const Divider(
                color: AppColors.mainGray,
                thickness: 1,
              ),
              const SizedBox(height: 40),
              Text("Conhecimentos sobre Dívidas e Crédito",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.secondary)),
              const SizedBox(height: 40),
              buildBlock("Cartão de Crédito",
                  "Cartão de crédito é um método de empréstimo extremamente utilizado devido ao seu poder de compra elevado",
                  () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CartaoCreditoScreen()));
              }),
              const SizedBox(height: 20),
              buildBlock("Empréstimo",
                  "É um acordo financeiro onde uma pessoa ou instituição empresta dinheiro a outra, que se compromete a pagar de volta com juros.",
                  () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EmprestimoScreen()));
              }),
              const SizedBox(height: 20),
              buildBlock("Financiamento",
                  "É um empréstimo de longo prazo para comprar bens, como imóveis ou veículos, pago em parcelas com juros. O bem geralmente serve como garantia.",
                  () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FinanciamentoScreen()));
              }),
              const SizedBox(height: 20),
              buildBlock("Hipoteca",
                  "Uma hipoteca é um tipo de empréstimo em que você usa um bem, geralmente um imóvel, como garantia para obter o crédito.",
                  () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HipotecaScreen()));
              }),
              const SizedBox(height: 20),
              buildBlock("Endividamento", "O endividamento acontece quando os gastos superam a renda e a pessoa passa a depender de crédito para cobrir suas despesas. Com o tempo, isso pode se transformar em uma bola de neve difícil de controlar.", () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const EndividamentoScreen()));
              }),
              const SizedBox(height: 40),
              const Divider(
                color: AppColors.mainGray,
                thickness: 1,
              ),
              const SizedBox(height: 40),
              Text("Conhecimentos sobre Direitos e Impostos",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: colors.tertiary)),
              const SizedBox(height: 20),
              buildBlock("Código do Consumidor (CDC)",
                  "O Código de Defesa do Consumidor, criado pela Lei nº 8.078 de 1990, é uma legislação brasileira que tem como principal objetivo proteger os direitos dos consumidores.",
                  () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CodigoConsumidorScreen()));
              }),
              const SizedBox(height: 20),
              buildBlock("PROCON",
                  "O PROCON (Programa de Proteção e Defesa do Consumidor) é um órgão responsável por proteger os direitos dos consumidores e promover relações de consumo mais justas.",
                  () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProconScreen()));
              }),
              const SizedBox(height: 20),
              buildBlock("Imposto de Renda (IR)",
                  "O Imposto de Renda é um tributo cobrado sobre os ganhos de pessoas e empresas, como salários e lucros.",
                  () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ImpostoRendaScreen()));
              }),
              const SizedBox(height: 20),
              buildBlock("Taxa de Juros",
                  "É o valor extra que você paga ou recebe pelo uso de dinheiro, sendo uma porcentagem do valor emprestado ou investido.",
                  () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TaxaJurosScreen()));
              }),
              const SizedBox(height: 20),
              
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildBlock(String title, String description, VoidCallback? onTap) {
  return InkWell(
    onTap: onTap,
    child: Container(
      decoration: BoxDecoration(
        color: AppColors.main,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.mainWhite),
          ),
          const Divider(
            thickness: 1,
          ),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: AppColors.mainWhite, height: 1.5),
          )
        ],
      ),
    ),
  );
}
