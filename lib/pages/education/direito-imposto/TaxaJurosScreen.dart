import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/PageEducation.dart';

class TaxaJurosScreen extends StatefulWidget {
  const TaxaJurosScreen({super.key});

  @override
  State<TaxaJurosScreen> createState() => _TaxaJurosScreenState();
}

class _TaxaJurosScreenState extends State<TaxaJurosScreen> {
  @override
  Widget build(BuildContext context) {
    return PageEducationScreen(
      appBarTitle: 'Educação Financeira',
      title: 'Taxas de Juros',
      highlightedQuestion: 'O que são as taxas de juros?',
      content: '''
As taxas de juros são uma forma de remuneração para o banco, no qual quando se pega algo emprestado, deve-se pagar uma quantia como maneira de compensação ao tempo que o dinheiro ficou emprestado.

É tão importante saber dele pois ele está envolvido em basicamente quase todas as contas que pagamos mensalmente, e muitas vezes, “decide” se um tipo de financiamento ou empréstimo valerá a pena ser feito.

Por exemplo: Se você pega um empréstimo de R\$ 1.000,00 com uma taxa de juros de 10% ao mês, no final do mês você deverá R\$ 1.100,00. Os R\$ 100,00 a mais são os juros.

Juros Simples

Juros simples são uma forma de calcular quanto você ganha ou paga por um dinheiro emprestado ou investido. Nos juros simples, você calcula os juros sempre sobre o valor original (o capital inicial) e não sobre o total acumulado. Os juros nesse caso não mudam com o passar do tempo.

A fórmula é bem simples:
Juros = Capital x Taxa de Juros x Tempo

Onde:
- Capital é o valor que você empresta ou investe.
- Taxa de Juros é a porcentagem que você ganha ou paga (se for 5%, use 0,05).
- Tempo é o período (em anos ou meses).

Juros Compostos

Os juros compostos são uma forma de calcular não somente os juros sobre o capital inicial (como nos juros simples), mas também os juros que já foram acumulados em períodos anteriores. Isso significa que você paga juros sobre juros.

A fórmula para calcular os juros compostos é:
M = P x (1 + i)^n

Onde:
- M = Montante final (o total que você terá no final)
- P = Capital inicial (o valor que você investe ou empresta)
- i = Taxa de juros (em decimal, por exemplo, 5% = 0,05)
- n = Número de períodos (anos, meses, etc.)

Juros de Mora

Os juros de mora são um tipo específico de juros aplicados quando há atraso no cumprimento de uma obrigação financeira, como o pagamento de uma dívida ou de um contrato. Este tipo de juros é limitado por 1% ao mês, porém se o atraso for inferior a esse tempo, a taxa é de 0,0333% por dia de atraso.

Juros Rotativos

Juros rotativos são aplicados quando você utiliza um crédito disponível em um cartão, mas não paga a fatura inteira. Assim, a parte não paga é sujeita a novos juros.

Por exemplo:
Suponha que sua fatura do cartão seja de R\$ 1.000,00 e você paga apenas R\$ 600,00. O saldo que sobrou é de R\$ 400,00.
Se a taxa de juros rotativos for de 10% ao mês, no próximo mês você terá que pagar 10% do valor que sobrou.
Portanto, no segundo mês, você deverá R\$ 440,00 (R\$ 400,00 + R\$ 40,00 de juros rotativos).
''',
      buttonText: 'Próximo',
      onActionPressed: () {
        // ação para próxima tela ou função
      },
    );
  }
}
