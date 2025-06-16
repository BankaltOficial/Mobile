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

class CourseItem {
  final String title;
  final String description;
  final VoidCallback onTap;

  CourseItem({required this.title, required this.description, required this.onTap});
}

class TopicSection {
  final String title;
  final Color color;
  final List<CourseItem> courses;
  bool isExpanded;

  TopicSection({
    required this.title,
    required this.color,
    required this.courses,
    this.isExpanded = false,
  });
}

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  List<TopicSection> _sections = [];

  @override
  void initState() {
    super.initState();
    _initializeSections();
  }

  void _initializeSections() {
    _sections = [
      TopicSection(
        title: "Fundamentos Financeiros Pessoais",
        color: AppColors.main,
        courses: [
          CourseItem(
            title: "Renda Fixa",
            description: "Renda fixa é o valor que uma empresa ou indivíduo recebe de forma regular e previsível, independentemente das variações nas vendas ou na produção.",
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RendaFixaScreen())),
          ),
          CourseItem(
            title: "Renda Variável",
            description: "Diferente da renda fixa, a renda variável é um investimento inconstante, ou seja, não é um tipo de investimento que possa ser previsível no mercado financeiro.",
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RendaVariavelScreen())),
          ),
          CourseItem(
            title: "Despesas",
            description: "Despesas são todos os gastos que uma pessoa ou empresa tem ao utilizar recursos para manter o funcionamento de suas atividades ou o seu padrão de vida.",
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DespesasScreen())),
          ),
          CourseItem(
            title: "Análise de Despesas",
            description: "A análise de despesas é um dos pilares do controle financeiro, tanto pessoal quanto empresarial. Entender para onde vai seu dinheiro permite decisões mais conscientes e equilibradas.",
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AnaliseDespesasScreen())),
          ),
          CourseItem(
            title: "Reduzir Despesas",
            description: "Reduzir despesas com lazer pode ser um desafio, mas com algumas estratégias simples, é possível se divertir sem comprometer o orçamento.",
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ReduzirDespesasScreen())),
          ),
          CourseItem(
            title: "Orçamento",
            description: "O orçamento pode ser dividido em três partes, que são o Orçamento pessoal e doméstico, público e empresarial, cada um com um olhar diferente, mas com a mesma pegada.",
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OrcamentoScreen())),
          ),
          CourseItem(
            title: "Conta Poupança",
            description: "A conta poupança funciona permitindo que você deposite um dinheiro e ganhe rendimento em cima dessa verba.",
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ContaPoupancaScreen())),
          ),
        ],
      ),
      TopicSection(
        title: "Conhecimentos sobre Dívidas e Crédito",
        color: AppColors.secondary ?? Colors.orange,
        courses: [
          CourseItem(
            title: "Cartão de Crédito",
            description: "Cartão de crédito é um método de empréstimo extremamente utilizado devido ao seu poder de compra elevado",
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CartaoCreditoScreen())),
          ),
          CourseItem(
            title: "Empréstimo",
            description: "É um acordo financeiro onde uma pessoa ou instituição empresta dinheiro a outra, que se compromete a pagar de volta com juros.",
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EmprestimoScreen())),
          ),
          CourseItem(
            title: "Financiamento",
            description: "É um empréstimo de longo prazo para comprar bens, como imóveis ou veículos, pago em parcelas com juros. O bem geralmente serve como garantia.",
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const FinanciamentoScreen())),
          ),
          CourseItem(
            title: "Hipoteca",
            description: "Uma hipoteca é um tipo de empréstimo em que você usa um bem, geralmente um imóvel, como garantia para obter o crédito.",
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HipotecaScreen())),
          ),
          CourseItem(
            title: "Endividamento",
            description: "O endividamento acontece quando os gastos superam a renda e a pessoa passa a depender de crédito para cobrir suas despesas. Com o tempo, isso pode se transformar em uma bola de neve difícil de controlar.",
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const EndividamentoScreen())),
          ),
        ],
      ),
      TopicSection(
        title: "Conhecimentos sobre Direitos e Impostos",
        color: AppColors.tertiary ?? Colors.green,
        courses: [
          CourseItem(
            title: "Código do Consumidor (CDC)",
            description: "O Código de Defesa do Consumidor, criado pela Lei nº 8.078 de 1990, é uma legislação brasileira que tem como principal objetivo proteger os direitos dos consumidores.",
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CodigoConsumidorScreen())),
          ),
          CourseItem(
            title: "PROCON",
            description: "O PROCON (Programa de Proteção e Defesa do Consumidor) é um órgão responsável por proteger os direitos dos consumidores e promover relações de consumo mais justas.",
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProconScreen())),
          ),
          CourseItem(
            title: "Imposto de Renda (IR)",
            description: "O Imposto de Renda é um tributo cobrado sobre os ganhos de pessoas e empresas, como salários e lucros.",
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ImpostoRendaScreen())),
          ),
          CourseItem(
            title: "Taxa de Juros",
            description: "É o valor extra que você paga ou recebe pelo uso de dinheiro, sendo uma porcentagem do valor emprestado ou investido.",
            onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TaxaJurosScreen())),
          ),
        ],
      ),
    ];
  }

  List<TopicSection> _getFilteredSections() {
    if (_searchQuery.isEmpty) {
      return _sections;
    }

    return _sections.map((section) {
      final filteredCourses = section.courses.where((course) {
        return course.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            course.description.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            section.title.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();

      return TopicSection(
        title: section.title,
        color: section.color,
        courses: filteredCourses,
        isExpanded: filteredCourses.isNotEmpty ? true : section.isExpanded,
      );
    }).where((section) => section.courses.isNotEmpty).toList();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final colors = Provider.of<ColorProvider>(context);
    final filteredSections = _getFilteredSections();

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
        },
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Barra de pesquisa
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Pesquisar cursos...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Seções de tópicos
              ...filteredSections.map((section) => Column(
                children: [
                  _buildTopicHeader(section),
                  const SizedBox(height: 10),
                  if (section.isExpanded) ...[
                    ...section.courses.map((course) => Column(
                      children: [
                        _buildCourseBlock(course),
                        const SizedBox(height: 15),
                      ],
                    )),
                    const SizedBox(height: 20),
                  ],
                ],
              )),

              // Mensagem quando não há resultados
              if (filteredSections.isEmpty && _searchQuery.isNotEmpty)
                Container(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 60,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Nenhum curso encontrado',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Tente pesquisar com outras palavras-chave',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopicHeader(TopicSection section) {
    return InkWell(
      onTap: () {
        setState(() {
          section.isExpanded = !section.isExpanded;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: section.color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    section.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mainWhite,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Opacity(
                    opacity: 0.8,
                    child: Text(
                      '${section.courses.length} curso${section.courses.length != 1 ? 's' : ''}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.mainWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              section.isExpanded ? Icons.expand_less : Icons.expand_more,
              color: AppColors.mainWhite,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseBlock(CourseItem course) {
    return InkWell(
      onTap: course.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    course.description,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}