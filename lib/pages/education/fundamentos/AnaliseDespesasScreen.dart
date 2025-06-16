import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/PageEducation.dart';
import 'package:flutter_application_1/pages/education/fundamentos/ReduzirDespesas.dart';

class AnaliseDespesasScreen extends StatefulWidget {
  const AnaliseDespesasScreen({super.key});

  @override
  State<AnaliseDespesasScreen> createState() => _AnaliseDespesasScreenState();
}

class _AnaliseDespesasScreenState extends State<AnaliseDespesasScreen> {
  @override
  Widget build(BuildContext context) {
    return PageEducationScreen(
      appBarTitle: 'Educação Financeira',
      title: 'Análise de despesas',
      highlightedQuestion: 'Importância da análise de despesas',
      content: '''
Importância da análise de despesas
Controle Financeiro: Permite acompanhar de perto para onde o dinheiro está indo, ajudando a evitar surpresas financeiras no final do mês.
Identificação de Gastos Desnecessários: Ajuda a detectar despesas que podem ser cortadas ou reduzidas, contribuindo para uma melhor saúde financeira.
Planejamento e Orçamento: Facilita a criação de um orçamento mais realista e eficiente, ajustando as despesas conforme a receita disponível.
Tomada de Decisões: Com uma visão clara das finanças, é mais fácil tomar decisões informadas sobre investimentos, compras e economias.
Objetivos Financeiros: Auxilia na definição e monitoramento de metas financeiras, como poupança para viagens, compra de bens ou investimento em educação.

Como realizar uma análise de despesas doméstica
Coleta de Dados: Reúna todos os comprovantes de despesas do mês, como contas, recibos e extratos bancários.
Classificação: Categorize as despesas (moradia, alimentação, transporte, lazer, saúde, etc.) para entender onde você gasta mais.
Registro: Use uma planilha, aplicativo de finanças ou um caderno para registrar as despesas de cada categoria.
Análise: Compare as despesas com o orçamento planejado. Verifique onde está gastando mais ou menos do que o esperado.
Ajustes: Com base na análise, ajuste seu orçamento e faça planos para o próximo mês, buscando cortar gastos elevados nas áreas que julgar necessário.

Como funciona uma análise de despesas em empresas?
A análise de despesas em empresas segue o mesmo conceito da doméstica, mudando apenas como são classificados. Veja melhor o esquema abaixo:
Coleta de Dados: A empresa deve coletar dados financeiros de todas as áreas, como contas a pagar, despesas operacionais, folha de pagamento, etc.
Classificação e Segmentação: As despesas são categorizadas por departamento, projeto ou tipo, permitindo uma visão mais detalhada.
Relatórios Financeiros: Elaboração de relatórios mensais que consolidam todas as despesas, comparando com o orçamento e os resultados financeiros.
Análise de Desempenho: Avaliação do desempenho financeiro em relação a metas e benchmarks do setor, identificando áreas de eficiência e desperdício.
Tomada de Decisão: As informações obtidas ajudam a definir estratégias de corte de custos, investimento em áreas lucrativas e otimização de recursos.
''',
      buttonText: 'Próximo',
      onActionPressed: () {
        Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ReduzirDespesasScreen()));
      },
    );
  }
}
