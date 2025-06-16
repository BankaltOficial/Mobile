import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/PageEducation.dart';
import 'package:flutter_application_1/pages/education/direito-imposto/CodigoConsumidorScreen.dart';

class EndividamentoScreen extends StatefulWidget {
  const EndividamentoScreen({super.key});

  @override
  State<EndividamentoScreen> createState() => _EndividamentoScreenState();
}

class _EndividamentoScreenState extends State<EndividamentoScreen> {
  @override
  Widget build(BuildContext context) {
    return PageEducationScreen(
      appBarTitle: 'Educação Financeira',
      title: 'Endividamento',
      highlightedQuestion: 'Causas',
      content: '''
Gastos impulsivos: Compras por impulso e o uso frequente de cartões de crédito ou parcelamentos fazem com que as dívidas se acumulem rapidamente. Isso acontece principalmente quando as pessoas não calculam o impacto dos juros ou compram além do que realmente precisam.

Falta de planejamento: Sem um orçamento claro, fica difícil controlar as finanças e saber para onde o dinheiro está indo. A ausência de uma reserva para emergências também aumenta a chance de recorrer a empréstimos em momentos de crise.

Desemprego: A perda de emprego ou queda na renda força muitas pessoas a recorrerem a empréstimos ou cartões de crédito para cobrir despesas básicas, como aluguel e alimentação, o que pode resultar em dívidas de longo prazo.

Emergências: Situações inesperadas, como doenças ou acidentes, geram gastos urgentes que, sem uma reserva financeira, precisam ser cobertos por crédito, frequentemente com juros altos. Isso acaba aumentando o nível de endividamento.

Riscos

Juros altos: Dívidas com cartões de crédito, empréstimos e financiamentos podem ter juros elevados. Isso faz com que o valor final a ser pago seja muito maior do que o inicialmente tomado, aumentando ainda mais o endividamento.

Perda de bens: Quando o pagamento das dívidas não é feito, o credor pode recorrer a medidas legais, levando à perda de bens, como imóveis ou carros, para quitar o débito.

Nome sujo: O não pagamento das dívidas pode resultar na inclusão do nome em cadastros de inadimplentes, como SPC ou Serasa, o que dificulta o acesso a novos créditos e até oportunidades de trabalho em algumas empresas.

Restrição de crédito: Ao se endividar, a pessoa perde credibilidade no mercado e tem mais dificuldade em conseguir novos empréstimos ou financiamentos, ou receber condições menos favoráveis, como juros mais altos e prazos mais curtos.

Impacto na saúde mental: O estresse causado pelo endividamento pode gerar ansiedade, depressão e dificuldades nos relacionamentos, afetando o bem-estar geral da pessoa e de sua família.

Soluções e Precauções

Levantamento das dívidas: O primeiro passo é listar todas as dívidas, incluindo valores, taxas de juros e prazos. Isso ajuda a ter uma visão clara da situação e a priorizar o pagamento das dívidas mais urgentes ou com juros mais altos.

Corte de gastos desnecessários: Reduzir despesas supérfluas é essencial. Revisar o orçamento familiar e eliminar gastos não essenciais, como assinaturas ou compras por impulso, pode liberar dinheiro para o pagamento das dívidas.

Negociação com credores: Tentar negociar melhores condições, como prazos maiores ou redução de juros, pode ser uma saída viável. Muitas empresas estão dispostas a renegociar para evitar inadimplência.

Refinanciamento: Em alguns casos, consolidar dívidas, ou seja, pegar um empréstimo com juros menores para pagar várias dívidas com juros altos, pode ajudar a organizar os pagamentos e reduzir o valor total pago.

Aumentar a renda: Buscar uma fonte de renda extra, como trabalhos freelancers ou venda de produtos, pode acelerar o processo de quitação das dívidas.

Educação financeira: Investir no aprendizado de como administrar melhor o dinheiro é fundamental para evitar repetir os mesmos erros no futuro e garantir uma vida financeira saudável.
''',
      buttonText: 'Próximo',
      onActionPressed: () {
        Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CodigoConsumidorScreen()));
      },
    );
  }
}
