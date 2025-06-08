import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/PageEducation.dart';

class DespesasScreen extends StatefulWidget {
  const DespesasScreen({super.key});

  @override
  State<DespesasScreen> createState() => _DespesasScreenState();
}

class _DespesasScreenState extends State<DespesasScreen> {
  @override
  Widget build(BuildContext context) {
    return PageEducationScreen(
      appBarTitle: 'Educação Financeira',
      title: 'Despesas',
      highlightedQuestion: 'O que são as despesas?',
      content: '''
Despesas
O que são as despesas?
Despesas são todos os gastos que uma pessoa ou empresa tem ao utilizar recursos para manter o funcionamento de suas atividades ou o seu padrão de vida. Elas podem ser divididas em diferentes tipos, como as despesas fixas, variáveis e eventuais, que iremos comentar a seguir.

Despesas fixas
As despesas fixas são gastos que não mudam muito de um mês para o outro, o que ajuda a planejar melhor as finanças. Exemplos incluem aluguel, contas de água e luz, e mensalidades escolares. Esses gastos costumam representar uma boa parte do orçamento mensal, então é importante controlá-los para evitar surpresas, já que precisam ser pagos todo mês.
Para gerenciar as despesas fixas, vale a pena revisar contratos e procurar melhores condições, como um aluguel mais barato ou um plano de telefone mais em conta. Como é mais difícil reduzir esses gastos do que as despesas variáveis, é fundamental cuidar bem deles para manter a estabilidade financeira.

Despesas variáveis
As despesas variáveis são gastos que mudam de um mês para o outro, dependendo do consumo e das necessidades. Exemplos incluem compras de supermercado, contas de água e luz, transporte e lazer. 
Essas despesas oferecem mais flexibilidade, pois podem ser ajustadas facilmente se for necessário economizar. No entanto, é importante monitorá-las, pois pequenos gastos podem se acumular e impactar o orçamento. Fazer um planejamento mensal ajuda a prever esses gastos e manter a saúde financeira.

Despesas eventuais
As despesas eventuais são gastos que ocorrem de forma incerta e não têm um padrão mensal fixo. Exemplos incluem consertos de carro, manutenção da casa, festas e compras de presentes. 
Embora sejam imprevisíveis, é importante planejar uma reserva para esses gastos, pois podem impactar o orçamento quando surgem. Ter controle sobre essas despesas ajuda a evitar surpresas financeiras e a garantir que as despesas fixas e variáveis não sejam comprometidas.

Importância de planejar as despesas
Planejar as despesas é essencial para ter controle financeiro e prever gastos, evitando surpresas. Isso ajuda a reduzir desperdícios, alcançar metas financeiras, garantir segurança e criar uma reserva para emergências, tudo isso a fim de construir uma vida financeira saudável e tranquila.
''',
      buttonText: 'Próximo',
      onActionPressed: () {
        // ação ao pressionar o botão
      },
    );
  }
}
