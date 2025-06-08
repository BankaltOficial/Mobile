import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/PageEducation.dart';
import 'package:flutter_application_1/service/Colors.dart';

class TaxaJurosScreen extends StatefulWidget {
  TaxaJurosScreen({super.key});

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
      content: "", 
      additionalContent: [
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 16,
              color: AppColors.invertMode,
              height: 1.5,
              fontWeight: FontWeight.w300,
              fontFamily: "Poppins"
            ),
            children: [
              TextSpan(
                text: 'As taxas de juros são uma forma de ',
              ),
              TextSpan(
                text: 'remuneração para o banco',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ', no qual quando se pega algo emprestado, deve-se pagar uma quantia como maneira de compensação ao tempo que o dinheiro ficou emprestado.\n\n',
              ),
              TextSpan(
                text: 'É tão importante saber dele pois ele está envolvido em ',
              ),
              TextSpan(
                text: 'basicamente quase todas as contas',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' que pagamos mensalmente, e muitas vezes, "decide" se um tipo de financiamento ou empréstimo ',
              ),
              TextSpan(
                text: 'valerá a pena',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' ser feito.\n\n',
              ),
              TextSpan(
                text: 'Por exemplo:',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' Se você pega um empréstimo de ',
              ),
              TextSpan(
                text: 'R\$ 1.000,00',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' com uma taxa de juros de ',
              ),
              TextSpan(
                text: '10% ao mês',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ', no final do mês você deverá ',
              ),
              TextSpan(
                text: 'R\$ 1.100,00',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: '. Os ',
              ),
              TextSpan(
                text: 'R\$ 100,00',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' a mais são os juros.\n\n',
              ),
              
              // Subtítulo Juros Simples
              TextSpan(
                text: 'Juros Simples\n\n',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.secondary,
                ),
              ),
              TextSpan(
                text: 'Juros simples são uma forma de calcular quanto você ganha ou paga por um dinheiro emprestado ou investido. Nos juros simples, você calcula os juros sempre sobre o ',
              ),
              TextSpan(
                text: 'valor original',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' (o capital inicial) e não sobre o total acumulado. Os juros nesse caso ',
              ),
              TextSpan(
                text: 'não mudam',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' com o passar do tempo.\n\nA fórmula é bem simples:\n',
              ),
              TextSpan(
                text: 'Juros = Capital x Taxa de Juros x Tempo',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                ),
              ),
              TextSpan(
                text: '\n\nOnde:\n- ',
              ),
              TextSpan(
                text: 'Capital',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' é o valor que você empresta ou investe.\n- ',
              ),
              TextSpan(
                text: 'Taxa de Juros',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' é a porcentagem que você ganha ou paga (se for 5%, use 0,05).\n- ',
              ),
              TextSpan(
                text: 'Tempo',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' é o período (em anos ou meses).\n\n',
              ),
              
              // Subtítulo Juros Compostos
              TextSpan(
                text: 'Juros Compostos\n\n',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.secondary,
                ),
              ),
              TextSpan(
                text: 'Os juros compostos são uma forma de calcular não somente os juros sobre o capital inicial (como nos juros simples), mas também os juros que já foram acumulados em períodos anteriores. Isso significa que você paga ',
              ),
              TextSpan(
                text: 'juros sobre juros',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: '.\n\nA fórmula para calcular os juros compostos é:\n',
              ),
              TextSpan(
                text: 'M = P x (1 + i)^n',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                ),
              ),
              TextSpan(
                text: '\n\nOnde:\n- ',
              ),
              TextSpan(
                text: 'M',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' = Montante final (o total que você terá no final)\n- ',
              ),
              TextSpan(
                text: 'P',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' = Capital inicial (o valor que você investe ou empresta)\n- ',
              ),
              TextSpan(
                text: 'i',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' = Taxa de juros (em decimal, por exemplo, 5% = 0,05)\n- ',
              ),
              TextSpan(
                text: 'n',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' = Número de períodos (anos, meses, etc.)\n\n',
              ),
              
              // Subtítulo Juros de Mora
              TextSpan(
                text: 'Juros de Mora\n\n',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.secondary,
                ),
              ),
              TextSpan(
                text: 'Os juros de mora são um tipo específico de juros aplicados quando há ',
              ),
              TextSpan(
                text: 'atraso no cumprimento',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' de uma obrigação financeira, como o pagamento de uma dívida ou de um contrato. Este tipo de juros é limitado por ',
              ),
              TextSpan(
                text: '1% ao mês',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ', porém se o atraso for inferior a esse tempo, a taxa é de ',
              ),
              TextSpan(
                text: '0,0333% por dia',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' de atraso.\n\n',
              ),
              
              // Subtítulo Juros Rotativos
              TextSpan(
                text: 'Juros Rotativos\n\n',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.secondary,
                ),
              ),
              TextSpan(
                text: 'Juros rotativos são aplicados quando você utiliza um ',
              ),
              TextSpan(
                text: 'crédito disponível',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' em um cartão, mas ',
              ),
              TextSpan(
                text: 'não paga a fatura inteira',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: '. Assim, a parte não paga é sujeita a novos juros.\n\n',
              ),
              TextSpan(
                text: 'Por exemplo:',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: '\nSuponha que sua fatura do cartão seja de ',
              ),
              TextSpan(
                text: 'R\$ 1.000,00',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' e você paga apenas ',
              ),
              TextSpan(
                text: 'R\$ 600,00',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: '. O saldo que sobrou é de ',
              ),
              TextSpan(
                text: 'R\$ 400,00',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: '.\nSe a taxa de juros rotativos for de ',
              ),
              TextSpan(
                text: '10% ao mês',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ', no próximo mês você terá que pagar 10% do valor que sobrou.\nPortanto, no segundo mês, você deverá ',
              ),
              TextSpan(
                text: 'R\$ 440,00',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' (',
              ),
              TextSpan(
                text: 'R\$ 400,00',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' + ',
              ),
              TextSpan(
                text: 'R\$ 40,00',
                style: TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' de juros rotativos).',
              ),
            ],
          ),
        ),
      ],
      buttonText: 'Próximo',
      onActionPressed: () {
        // ação para próxima tela ou função
      },
    );
  }
}