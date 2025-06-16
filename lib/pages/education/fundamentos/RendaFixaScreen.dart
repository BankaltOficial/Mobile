import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/PageEducation.dart';
import 'package:flutter_application_1/pages/education/fundamentos/RendaVariavelScreen.dart';

class RendaFixaScreen extends StatefulWidget {
  const RendaFixaScreen({super.key});

  @override
  State<RendaFixaScreen> createState() => _RendaFixaScreenState();
}

class _RendaFixaScreenState extends State<RendaFixaScreen> {
  @override
  Widget build(BuildContext context) {
    return PageEducationScreen(
      appBarTitle: 'Educação Financeira',
      title: 'Renda Fixa',
      highlightedQuestion: 'O que é Renda Fixa?',
      content: '''
Renda fixa é o valor que uma empresa ou indivíduo recebe de forma regular e previsível, independentemente das variações nas vendas ou na produção. Alguns exemplos de receita fixa são salário, aluguel, assinaturas e outros acordos em que o pagamento é garantido em tempos determinados, como mensalmente ou anualmente.

Além disso, a renda fixa pode ter outro significado no ramo dos investimentos. Os investimentos de renda fixa são aqueles que têm um retorno fixo e garantido todo mês. Este tipo de investimento é considerado de menos risco do que as ações, por exemplo, porque todos os ganhos são previsíveis e ocorrem em intervalos regulares.

Tipos de renda fixa:

• **Poupança**: é o tipo de renda fixa mais popular do Brasil, pois é livre de impostos e pode ser retirada a qualquer momento, porém tem rendimento menor comparado a outros investimentos.

• **Tesouro Direto**: forma de adquirir títulos do governo. Você está basicamente emprestando dinheiro ao governo, que retorna com juros. Tem rendimento maior e segurança similar à poupança.

• **CDB (Certificado de Depósito Bancário)**: emitido por bancos, com garantia do FGC. Você empresta ao banco, que usa para financiar suas operações.

• **Debêntures e Notas Promissórias**: são títulos emitidos por empresas. Debêntures são de médio/longo prazo, enquanto notas promissórias são de curto prazo. Ambas pagam juros sobre o valor investido.

• **LCIs e LCAs**: emitidos por bancos, usados para financiar setores específicos: imobiliário (LCI) e agronegócio (LCA). Também são isentos de imposto de renda para pessoa física.
''',
      buttonText: 'Próximo',
      onActionPressed: () {
        Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RendaVariavelScreen()));
      },
    );
  }
}
