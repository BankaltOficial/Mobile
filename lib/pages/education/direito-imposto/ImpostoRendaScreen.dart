import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/PageEducation.dart';

class ImpostoRendaScreen extends StatefulWidget {
  const ImpostoRendaScreen({super.key});

  @override
  State<ImpostoRendaScreen> createState() => _ImpostoRendaScreenState();
}

class _ImpostoRendaScreenState extends State<ImpostoRendaScreen> {
  @override
  Widget build(BuildContext context) {
    return PageEducationScreen(
      appBarTitle: 'Educação Financeira',
      title: 'Imposto de Renda (IR)',
      highlightedQuestion: 'O que é imposto de renda?',
      content: '''
O Imposto de Renda é um tipo de tributo que você paga ao governo com base na sua renda, ou seja, no dinheiro que você ganha. A ideia é que quanto mais você ganha, mais você deve contribuir. Esse imposto é uma das principais fontes de renda do governo federal e pagar o Imposto de Renda deveria ser uma maneira de contribuir para o funcionamento do país. Com esse dinheiro, o governo pode investir em coisas importantes para a sociedade. Além disso, declarar corretamente e pagar o imposto evita problemas legais e ajuda a manter tudo em ordem.

Quais são os tipos de Imposto de Renda?

Imposto de Renda Pessoa Física (IRPF)

O IRPF é o imposto que as pessoas físicas (indivíduos) precisam pagar sobre a renda que recebem. Isso inclui salários, rendimentos de investimentos, aluguéis e outras fontes de receita. Qualquer pessoa que tenha uma renda acima de um determinado limite precisa pagar o IRPF.

Imposto de Renda Pessoa Jurídica (IRPJ)

O IRPJ é o imposto que empresas e outras entidades jurídicas (como associações e fundações) precisam pagar sobre seus lucros. Ele é uma forma de tributar a renda das pessoas jurídicas. Todas as empresas e organizações que têm fins lucrativos devem pagar o IRPJ. Isso inclui empresas individuais, sociedades, corporações e outras formas de negócios.
''',
      buttonText: 'Próximo',
      onActionPressed: () {
        // ação para próxima tela ou função
      },
    );
  }
}
