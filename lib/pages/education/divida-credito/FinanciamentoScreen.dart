import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/PageEducation.dart';
import 'package:flutter_application_1/pages/education/divida-credito/HipotecaScreen.dart';

class FinanciamentoScreen extends StatelessWidget {
  const FinanciamentoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageEducationScreen(
      title: 'Financiamento',
      appBarTitle: 'Financiamento',
      brandName: 'bankalt',
      highlightedQuestion: 'O que é Financiamento?',
      content:
          'Financiamento é um tipo de empréstimo que você toma para comprar algo de alto valor, como uma casa, um carro ou até mesmo para investir em um negócio. Em vez de pagar o valor total de uma vez, você paga em parcelas ao longo do tempo. Ao mesmo tempo que o financiamento pode ser uma opção para aqueles que não têm dinheiro, é preciso analisar as condições do investimento para saber se realmente é algo viável.',
      buttonText: 'Próximo',
      onActionPressed: () {
        Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HipotecaScreen()));
      },
    ));
  }
}
