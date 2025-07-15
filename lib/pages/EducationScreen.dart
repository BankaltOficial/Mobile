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
  final List<String> tags;

  CourseItem({
    required this.title,
    required this.description,
    required this.onTap,
    required this.tags,
  });
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

class FilterCategory {
  final String name;
  final String displayName;
  final IconData icon;
  final Color color;

  FilterCategory({
    required this.name,
    required this.displayName,
    required this.icon,
    required this.color,
  });
}

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  // Removido: final ScrollController _filterScrollController = ScrollController();
  String _searchQuery = '';
  String _selectedFilter = 'todos';
  List<TopicSection> _sections = [];
  bool _isSearchFocused = false;
  late AnimationController _filterAnimationController;
  late Animation<double> _filterAnimation;

  final List<FilterCategory> _filterCategories = [
    FilterCategory(
      name: 'todos',
      displayName: 'Todos',
      icon: Icons.all_inclusive,
      color: Colors.grey[600]!,
    ),
    FilterCategory(
      name: 'cartao',
      displayName: 'Cartão',
      icon: Icons.credit_card,
      color: Colors.blue[600]!,
    ),
    FilterCategory(
      name: 'investimento',
      displayName: 'Investimento',
      icon: Icons.trending_up,
      color: Colors.green[600]!,
    ),
    FilterCategory(
      name: 'emprestimo',
      displayName: 'Empréstimo',
      icon: Icons.account_balance,
      color: Colors.orange[600]!,
    ),
    FilterCategory(
      name: 'orcamento',
      displayName: 'Orçamento',
      icon: Icons.pie_chart,
      color: Colors.purple[600]!,
    ),
    FilterCategory(
      name: 'impostos',
      displayName: 'Impostos',
      icon: Icons.receipt_long,
      color: Colors.red[600]!,
    ),
    FilterCategory(
      name: 'direitos',
      displayName: 'Direitos',
      icon: Icons.gavel,
      color: Colors.teal[600]!,
    ),
  ];

  void _initializeSections() {
    _sections = [
      TopicSection(
        title: "Fundamentos Financeiros Pessoais",
        color: AppColors.main,
        courses: [
          CourseItem(
            title: "Renda Fixa",
            description:
                "Renda fixa é o valor que uma empresa ou indivíduo recebe de forma regular e previsível, independentemente das variações nas vendas ou na produção.",
            onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const RendaFixaScreen())),
            tags: ['investimento', 'renda', 'financas'],
          ),
          CourseItem(
            title: "Renda Variável",
            description:
                "Diferente da renda fixa, a renda variável é um investimento inconstant, ou seja, não é um tipo de investimento que possa ser previsível no mercado financeiro.",
            onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const RendaVariavelScreen())),
            tags: ['investimento', 'renda', 'financas'],
          ),
          CourseItem(
            title: "Despesas",
            description:
                "Despesas são todos os gastos que uma pessoa ou empresa tem ao utilizar recursos para manter o funcionamento de suas atividades ou o seu padrão de vida.",
            onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DespesasScreen())),
            tags: ['orcamento', 'gastos', 'financas'],
          ),
          CourseItem(
            title: "Análise de Despesas",
            description:
                "A análise de despesas é um dos pilares do controle financeiro, tanto pessoal quanto empresarial. Entender para onde vai seu dinheiro permite decisões mais conscientes e equilibradas.",
            onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const AnaliseDespesasScreen())),
            tags: ['orcamento', 'analise', 'gastos'],
          ),
          CourseItem(
            title: "Reduzir Despesas",
            description:
                "Reduzir despesas com lazer pode ser um desafio, mas com algumas estratégias simples, é possível se divertir sem comprometer o orçamento.",
            onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ReduzirDespesasScreen())),
            tags: ['orcamento', 'economia', 'gastos'],
          ),
          CourseItem(
            title: "Orçamento",
            description:
                "O orçamento pode ser dividido em três partes, que são o Orçamento pessoal e doméstico, público e empresarial, cada um com um olhar diferente, mas com a mesma pegada.",
            onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const OrcamentoScreen())),
            tags: ['orcamento', 'planejamento', 'financas'],
          ),
          CourseItem(
            title: "Conta Poupança",
            description:
                "A conta poupança funciona permitindo que você deposite um dinheiro e ganhe rendimento em cima dessa verba.",
            onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ContaPoupancaScreen())),
            tags: ['investimento', 'poupanca', 'banco'],
          ),
        ],
      ),
      TopicSection(
        title: "Conhecimentos sobre Dívidas e Crédito",
        color: AppColors.secondary ?? Colors.orange,
        courses: [
          CourseItem(
            title: "Cartão de Crédito",
            description:
                "Cartão de crédito é um método de empréstimo extremamente utilizado devido ao seu poder de compra elevado",
            onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const CartaoCreditoScreen())),
            tags: ['cartao', 'credito', 'divida'],
          ),
          CourseItem(
            title: "Empréstimo",
            description:
                "É um acordo financeiro onde uma pessoa ou instituição empresta dinheiro a outra, que se compromete a pagar de volta com juros.",
            onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const EmprestimoScreen())),
            tags: ['emprestimo', 'credito', 'divida'],
          ),
          CourseItem(
            title: "Financiamento",
            description:
                "É um empréstimo de longo prazo para comprar bens, como imóveis ou veículos, pago em parcelas com juros. O bem geralmente serve como garantia.",
            onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const FinanciamentoScreen())),
            tags: ['emprestimo', 'financiamento', 'divida'],
          ),
          CourseItem(
            title: "Hipoteca",
            description:
                "Uma hipoteca é um tipo de empréstimo em que você usa um bem, geralmente um imóvel, como garantia para obter o crédito.",
            onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const HipotecaScreen())),
            tags: ['emprestimo', 'hipoteca', 'imovel'],
          ),
          CourseItem(
            title: "Endividamento",
            description:
                "O endividamento acontece quando os gastos superam a renda e a pessoa passa a depender de crédito para cobrir suas despesas. Com o tempo, isso pode se transformar em uma bola de neve difícil de controlar.",
            onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const EndividamentoScreen())),
            tags: ['emprestimo', 'divida', 'credito'],
          ),
        ],
      ),
      TopicSection(
        title: "Conhecimentos sobre Direitos e Impostos",
        color: AppColors.tertiary ?? Colors.green,
        courses: [
          CourseItem(
            title: "Código do Consumidor (CDC)",
            description:
                "O Código de Defesa do Consumidor, criado pela Lei nº 8.078 de 1990, é uma legislação brasileira que tem como principal objetivo proteger os direitos dos consumidores.",
            onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const CodigoConsumidorScreen())),
            tags: ['direitos', 'consumidor', 'lei'],
          ),
          CourseItem(
            title: "PROCON",
            description:
                "O PROCON (Programa de Proteção e Defesa do Consumidor) é um órgão responsável por proteger os direitos dos consumidores e promover relações de consumo mais justas.",
            onTap: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const ProconScreen())),
            tags: ['direitos', 'consumidor', 'procon'],
          ),
          CourseItem(
            title: "Imposto de Renda (IR)",
            description:
                "O Imposto de Renda é um tributo cobrado sobre os ganhos de pessoas e empresas, como salários e lucros.",
            onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const ImpostoRendaScreen())),
            tags: ['impostos', 'renda', 'tributo'],
          ),
          CourseItem(
            title: "Taxa de Juros",
            description:
                "É o valor extra que você paga ou recebe pelo uso de dinheiro, sendo uma porcentagem do valor emprestado ou investido.",
            onTap: () => Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => TaxaJurosScreen())),
            tags: ['impostos', 'juros', 'financas'],
          ),
        ],
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    _initializeSections();
    _filterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _filterAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _filterAnimationController,
      curve: Curves.easeInOut,
    ));
    _filterAnimationController.forward();

    // Removido: _filterScrollController.addListener(() { ... });
  }

  List<TopicSection> _getFilteredSections() {
    List<TopicSection> filteredByCategory = _sections;

    // Filtrar por categoria
    if (_selectedFilter != 'todos') {
      filteredByCategory = _sections
          .map((section) {
            final filteredCourses = section.courses.where((course) {
              return course.tags.contains(_selectedFilter);
            }).toList();

            return TopicSection(
              title: section.title,
              color: section.color,
              courses: filteredCourses,
              isExpanded:
                  filteredCourses.isNotEmpty ? true : section.isExpanded,
            );
          })
          .where((section) => section.courses.isNotEmpty)
          .toList();
    }

    // Filtrar por busca
    if (_searchQuery.isEmpty) {
      return filteredByCategory;
    }

    return filteredByCategory
        .map((section) {
          final filteredCourses = section.courses.where((course) {
            return course.title
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                course.description
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                section.title
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());
          }).toList();

          return TopicSection(
            title: section.title,
            color: section.color,
            courses: filteredCourses,
            isExpanded: filteredCourses.isNotEmpty ? true : section.isExpanded,
          );
        })
        .where((section) => section.courses.isNotEmpty)
        .toList();
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
              // Barra de pesquisa aprimorada
              Container(
                decoration: BoxDecoration(
                  color: _isSearchFocused ? Colors.white : Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        _isSearchFocused ? AppColors.main : Colors.grey[300]!,
                    width: _isSearchFocused ? 2 : 1,
                  ),
                  boxShadow: _isSearchFocused
                      ? [
                          BoxShadow(
                            color: AppColors.main.withOpacity(0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : [],
                ),
                child: TextField(
                  controller: _searchController,
                  onTap: () {
                    setState(() {
                      _isSearchFocused = true;
                    });
                  },
                  onTapOutside: (event) {
                    setState(() {
                      _isSearchFocused = false;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Pesquisar cursos...',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color:
                          _isSearchFocused ? AppColors.main : Colors.grey[400],
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: Colors.grey[400],
                            ),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),

              // Filtros por categoria com animação (usando Wrap)
              AnimatedBuilder(
                animation: _filterAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, 20 * (1 - _filterAnimation.value)),
                    child: Opacity(
                      opacity: _filterAnimation.value,
                      child: Wrap( // Usando Wrap para quebrar em múltiplas linhas
                        spacing: 8.0, // Espaçamento horizontal entre os chips
                        runSpacing: 8.0, // Espaçamento vertical entre as linhas
                        children: _filterCategories.map((category) {
                          final isSelected = _selectedFilter == category.name;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedFilter = category.name;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              decoration: BoxDecoration(
                                color: isSelected ? category.color : Colors.grey[100],
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? category.color : Colors.grey[300]!,
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: category.color.withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : [],
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                              child: Column(
                                mainAxisSize: MainAxisSize.min, // Para que o Column não ocupe toda a largura
                                children: [
                                  AnimatedScale(
                                    scale: isSelected ? 1.1 : 1.0,
                                    duration: const Duration(milliseconds: 200),
                                    child: Icon(
                                      category.icon,
                                      size: 24,
                                      color: isSelected ? Colors.white : category.color,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    category.displayName,
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      color: isSelected ? Colors.white : Colors.grey[700],
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),

              // Indicador de filtro ativo e estatísticas
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Indicador de filtro ativo
                  if (_selectedFilter != 'todos')
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: _filterCategories
                            .firstWhere((cat) => cat.name == _selectedFilter)
                            .color
                            .withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: _filterCategories
                                .firstWhere(
                                    (cat) => cat.name == _selectedFilter)
                                .color
                                .withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _filterCategories
                                .firstWhere(
                                    (cat) => cat.name == _selectedFilter)
                                .icon,
                            size: 16,
                            color: _filterCategories
                                .firstWhere(
                                    (cat) => cat.name == _selectedFilter)
                                .color,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Filtro: ${_filterCategories.firstWhere((cat) => cat.name == _selectedFilter).displayName}',
                            style: TextStyle(
                              fontSize: 12,
                              color: _filterCategories
                                  .firstWhere(
                                      (cat) => cat.name == _selectedFilter)
                                  .color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 6),
                          InkWell(
                            onTap: () {
                              setState(() {
                                _selectedFilter = 'todos';
                              });
                            },
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: _filterCategories
                                  .firstWhere(
                                      (cat) => cat.name == _selectedFilter)
                                  .color,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Contador de resultados
                  if (filteredSections.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.library_books,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${filteredSections.fold(0, (sum, section) => sum + section.courses.length)} cursos',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              if (_selectedFilter != 'todos' || filteredSections.isNotEmpty)
                const SizedBox(height: 20),

              // Seções de tópicos com animação
              ...filteredSections.asMap().entries.map((entry) {
                final index = entry.key;
                final section = entry.value;
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 300 + (index * 100)),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, 30 * (1 - value)),
                      child: Opacity(
                        opacity: value,
                        child: Column(
                          children: [
                            _buildTopicHeader(section),
                            const SizedBox(height: 10),
                            if (section.isExpanded) ...[
                              ...section.courses
                                  .asMap()
                                  .entries
                                  .map((courseEntry) {
                                final courseIndex = courseEntry.key;
                                final course = courseEntry.value;
                                return TweenAnimationBuilder<double>(
                                  duration: Duration(
                                      milliseconds: 200 + (courseIndex * 50)),
                                  tween: Tween(begin: 0.0, end: 1.0),
                                  builder: (context, courseValue, child) {
                                    return Transform.translate(
                                      offset: Offset(20 * (1 - courseValue), 0),
                                      child: Opacity(
                                        opacity: courseValue,
                                        child: Column(
                                          children: [
                                            _buildCourseBlock(course),
                                            const SizedBox(height: 15),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }),
                              const SizedBox(height: 20),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),

              // Mensagem aprimorada quando não há resultados
              if (filteredSections.isEmpty)
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 500),
                  tween: Tween(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: 0.8 + (0.2 * value),
                      child: Opacity(
                        opacity: value,
                        child: Container(
                          padding: const EdgeInsets.all(40),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _searchQuery.isNotEmpty
                                      ? Icons.search_off
                                      : Icons.filter_list_off,
                                  size: 60,
                                  color: Colors.grey[400],
                                ),
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
                                _searchQuery.isNotEmpty
                                    ? 'Tente pesquisar com outras palavras-chave'
                                    : 'Tente selecionar outro filtro',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[500],
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Botão para limpar filtros
                              if (_searchQuery.isNotEmpty ||
                                  _selectedFilter != 'todos')
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _searchController.clear();
                                      _searchQuery = '';
                                      _selectedFilter = 'todos';
                                    });
                                  },
                                  icon: const Icon(Icons.clear_all),
                                  label: const Text('Limpar Filtros'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.main,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Removido: void _scrollToSelectedFilter(int index) { ... }

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
      borderRadius: BorderRadius.circular(12),
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
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: course.onTap,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                course.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            // Tags visuais
                            if (course.tags.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.main.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  course.tags.first,
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: AppColors.main,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                          ],
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey[400],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    // Removido: _filterScrollController.dispose();
    _filterAnimationController.dispose();
    super.dispose();
  }
}