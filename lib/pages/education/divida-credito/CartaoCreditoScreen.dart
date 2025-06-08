import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/PageEducation.dart';

class CartaoCreditoScreen extends StatefulWidget {
  const CartaoCreditoScreen({super.key});

  @override
  State<CartaoCreditoScreen> createState() => _CartaoCreditoScreenState();
}

class _CartaoCreditoScreenState extends State<CartaoCreditoScreen> {
  @override
  Widget build(BuildContext context) {
    return PageEducationScreen(
      appBarTitle: 'Educação Financeira',
      title: 'Cartão de Crédito',
      highlightedQuestion: 'Riscos',
      content: '''
Como já visto anteriormente, o cartão de crédito é um método de empréstimo extremamente utilizado devido ao seu poder de compra elevado, mas as pessoas costumam muitas vezes exagerar no seu uso, o que pode acarretar em diversas dívidas altíssimas para o portador.
O cartão de crédito apenas adia um pagamento futuro do devedor, e se o usuário costuma gastar muito mais do que recebe, isto pode levar a dívidas intermináveis. Por isso é preciso ter diversos cuidados e agir de forma consciente e sábia. 

Cartão de crédito e débito
Para entender melhor o uso do cartão de crédito, podemos fazer um comparativo com o cartão de débito. Para o cartão de débito ser uma forma viável de compra, o valor requisitado precisa estar presente na conta do cliente, e por isso não há uma maneira de se endividar realizando pagamento em débito. Tudo isso muito diferente do cartão de crédito, que como já visto antes é um método fácil para se endividar acumulando juros rotativos ao longo do tempo.
''',
      buttonText: 'Próximo',
      onActionPressed: () {
        // ação para próxima tela ou função
      },
    );
  }
}
