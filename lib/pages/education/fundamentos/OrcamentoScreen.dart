import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/PageEducation.dart';
import 'package:flutter_application_1/pages/education/fundamentos/ContaPoupancaScreen.dart';

class OrcamentoScreen extends StatefulWidget {
  const OrcamentoScreen({super.key});

  @override
  State<OrcamentoScreen> createState() => _OrcamentoScreenState();
}

class _OrcamentoScreenState extends State<OrcamentoScreen> {
  @override
  Widget build(BuildContext context) {
    return PageEducationScreen(
      appBarTitle: 'Educação Financeira',
      title: 'Orçamento',
      highlightedQuestion: 'O que é orçamento e como elaborar?',
      content: '''
O orçamento pode ser dividido em três partes, que são o Orçamento pessoal e doméstico, público e empresarial, cada um com um olhar diferente, mas com a mesma pegada. Iremos dar um foco nos Orçamento pessoal e doméstico e empresarial 

Orçamento pessoal e doméstico 
O foco do pessoal e doméstico é a casa, família, carro, financiamento e outros, para isso temos que dividir as rendas fixas como o salário e as variáveis aquelas inesperadas como um dinheiro ganho do seu tio, e assim ver e arrumar seus gastos. O doméstico é manter o equilíbrio da família que todos consigam viver bem, calculando as médias das rendas, mas tem que ter cuidado pois pode ter uma diferença de rendas ou até mesmo alguém não ter como de exemplo seus filhos mais novos, para isso você terá que ensiná-los a economizar e saber que está gastando e com consciência 

Orçamento empresarial 
O orçamento empresarial é um plano financeiro que projeta as receitas, despesas e investimentos de uma empresa em um período determinado, geralmente um ano. Ele serve como uma ferramenta de gestão, ajudando a empresa a alinhar suas metas e objetivos estratégicos com os recursos disponíveis. O processo envolve:
Estimativa de receitas: Prever quanto a empresa espera gerar em vendas ou outras fontes de renda.
Previsão de despesas: Estimar os custos operacionais, como salários, aluguel, matérias-primas e outros gastos necessários para o funcionamento do negócio.
Definição de investimentos: Planejar quanto será alocado para novos projetos, expansão ou aquisição de ativos.
Fluxo de caixa: Prever a entrada e saída de dinheiro, garantindo que a empresa tenha liquidez suficiente para cobrir suas obrigações.
Monitoramento e controle: Comparar os resultados reais com o orçamento previsto, identificando desvios e ajustando o planejamento conforme necessário.O orçamento empresarial permite que a empresa tome decisões baseadas em dados, evite gastos desnecessários, maximize os lucros e alcance suas metas de maneira eficiente.

Como elaborar um orçamento? 
Faça uma análise financeira: Avalie sua situação atual, anotando todas as despesas fixas e variáveis, bem como suas receitas ou ganhos.
Defina objetivos: Com base nos recursos disponíveis, após pagar todas as despesas fixas, determine quanto você pode economizar mensalmente, com o intuito de investir no futuro.
Estabeleça regras: Implemente práticas que ajudem a reduzir os gastos, como economizar no consumo de água e energia elétrica, entre outros.
Planeje com antecedência: Sempre faça previsões de receitas e despesas para garantir uma reserva financeira que possa ser utilizada em momentos de maior necessidade.
''',
      buttonText: 'Próximo',
      onActionPressed: () {
       Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ContaPoupancaScreen()));
      },
    );
  }
}
