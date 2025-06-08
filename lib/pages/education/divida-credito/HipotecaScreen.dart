import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/PageEducation.dart';

class HipotecaScreen extends StatefulWidget {
  const HipotecaScreen({super.key});

  @override
  State<HipotecaScreen> createState() => _HipotecaScreenState();
}

class _HipotecaScreenState extends State<HipotecaScreen> {
  @override
  Widget build(BuildContext context) {
    return PageEducationScreen(
      appBarTitle: 'Educação Financeira',
      title: 'Hipoteca',
      highlightedQuestion: 'O que é hipoteca?',
      content: '''
Uma hipoteca é um tipo de empréstimo em que você usa um bem, geralmente um imóvel, como garantia para obter o crédito. Isso significa que, se você não pagar o empréstimo como combinado, o banco ou a instituição financeira pode tomar o bem para quitar a dívida.

Suponha que você queira comprar uma casa que custa R\$200.000, mas só tem R\$50.000. Você pode fazer uma hipoteca para emprestar os R\$150.000 restantes do banco. Você paga o banco em parcelas mensais durante vários anos. Se você não pagar, o banco pode tomar a casa.

Quais são os tipos de hipoteca?

Convencional
Este tipo de hipoteca é negociada entre o devedor e credor, no qual o devedor hipotecou a casa no contrato de empréstimo como forma de garantia do pagamento.

Judicial
Firmada pela justiça em casos que o devedor precisa pagar sua dívida, servindo para assegurar a condenação do réu.

Legal
A hipoteca dificilmente acontece e é solicitada sem a autorização do devedor. Um exemplo é o direito dos filhos sobre imóveis hipotecados de pais falecidos.
''',
      buttonText: 'Próximo',
      onActionPressed: () {
        // ação para próxima tela ou função
      },
    );
  }
}
