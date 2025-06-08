import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/PageEducation.dart';

class ContaPoupancaScreen extends StatefulWidget {
  const ContaPoupancaScreen({super.key});

  @override
  State<ContaPoupancaScreen> createState() => _ContaPoupancaScreenState();
}

class _ContaPoupancaScreenState extends State<ContaPoupancaScreen> {
  @override
  Widget build(BuildContext context) {
    return PageEducationScreen(
      appBarTitle: 'Educação Financeira',
      title: 'Conta Poupança',
      highlightedQuestion: 'O que é conta poupança?',
      content: '''
A conta poupança é um tipo de investimento muito popular entre as pessoas atualmente, pois diferente de outros tipos de conta, a poupança não cobra taxas nem tarifas de entrada, além de ter um risco de perda muito baixo. 
A conta poupança funciona permitindo que você deposite um dinheiro e ganhe rendimento em cima dessa verba. Para abrir uma conta poupança, você deve fornecer documentos pessoais ao banco, após isso pode fazer depósitos e saques conforme necessário. O rendimento é calculado com base em uma porcentagem anual, que é creditada mensalmente. No Brasil, por exemplo, a taxa de juros da poupança é definida pelo governo e pode variar ao longo do tempo. A conta permite um acesso fácil aos fundos, mas os rendimentos são menores do que outros investimentos. Além disso, o saldo da conta poupança é protegido pelo Fundo Garantidor de Créditos (FGC) até um limite específico por CPF e instituição financeira.
''',
      buttonText: 'Próximo',
      onActionPressed: () {
        // ação para próxima tela ou função
      },
    );
  }
}
