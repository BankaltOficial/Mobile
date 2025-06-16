import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/PageEducation.dart';
import 'package:flutter_application_1/pages/education/divida-credito/FinanciamentoScreen.dart';

class EmprestimoScreen extends StatefulWidget {
  const EmprestimoScreen({super.key});

  @override
  State<EmprestimoScreen> createState() => _EmprestimoScreenState();
}

class _EmprestimoScreenState extends State<EmprestimoScreen> {
  @override
  Widget build(BuildContext context) {
    return PageEducationScreen(
      appBarTitle: 'Educação Financeira',
      title: 'Empréstimo',
      highlightedQuestion: 'O que é empréstimo?',
      content: '''
Um empréstimo é quando você pega dinheiro emprestado de uma instituição financeira, como um banco, ou de uma pessoa, e se compromete a pagar esse dinheiro de volta em parcelas, geralmente com juros. Em outras palavras, você recebe um valor hoje e se compromete a devolver esse valor ao longo do tempo, acrescido de uma taxa de juros.

Quais são os tipos de empréstimos?

Empréstimo Pessoal
O empréstimo pessoal é o mais comum e acessível para todos, no qual o cliente interessado solicita ao banco uma quantia que esteja dentro dos valores estabelecidos pelo contrato, e logo após, começa a pagar o banco mensalmente em parcelas que variam devido às taxas de juros.

Empréstimo com garantia
Como o próprio nome já diz, o empréstimo com garantia gira em torno de bens que o cliente oferece ao banco caso o pagamento mensal não seja cumprido. Este tipo de empréstimo costuma ser uma das opções mais vantajosas aos consumidores, pois têm as taxas de juros mais baixas do mercado, junto de prazos de pagamento mais estendidos.

Empréstimo Consignado
O empréstimo consignado é semelhante ao pessoal, apenas se difere na forma de pagamento e quem são as pessoas que podem realizá-lo. Este tipo de empréstimo é cobrado automaticamente da folha salarial do devedor todo mês, evitando que o consumidor não pague devidamente ao credor.

Importante ressaltar que o empréstimo consignado não é uma opção disponível para todas as pessoas, ela é apenas uma alternativa válida para pensionistas do INSS, servidores públicos, trabalhadores com carteira assinada e aposentados. Isso limita as possibilidades de quem pode realizar esse empréstimo, porém é uma ótima opção para aqueles que conseguem, pois o empréstimo consignado tem vantagens notáveis, como as taxas de juros mais baixas.

Empréstimo por penhor
O empréstimo por penhor é um método no qual um bem de valor é oferecido como uma forma de garantia para obter um empréstimo. O acesso ao capital nesse tipo de empréstimo é bastante rápido, porém deve-se considerar os pontos negativos que nele estão inseridos. As taxas de juros são mais altas e a possibilidade do seu item ser penhorado é grande se o empréstimo não for pago corretamente, portanto considere bastante antes de fazer um empréstimo por penhor.

Cartão de Crédito
O cartão de crédito pode ser considerado um tipo de empréstimo, pois quando você efetua uma compra com ele, na verdade um empréstimo é solicitado à administradora do cartão, que deve ser pago pelo devedor ao final do mês. O limite do seu cartão de crédito é baseado na confiança que a administradora deposita em você, por meio de um perfil de crédito ou score de crédito.

Deve-se ter cuidado ao usar o cartão de crédito indevidamente, pois várias compras com ele podem gerar altas taxas de juros, por isso tente manter as taxas o mais baixo possível.

Cheque Especial
O cheque especial é uma outra forma de empréstimo muito popular no Brasil, devido ao seu fácil acesso hoje em dia. Com ele é possível retirar mais saldo do que se tem em conta, dependendo do seu perfil, assim como no cartão de crédito. 
Similar ao cartão de crédito novamente, o cheque especial deve ser usado com cuidado, pois o uso dele excessivamente pode comprometer em altas taxas de juros.

Crédito Rotativo
O crédito rotativo permite que você use um limite de crédito que está disponível continuamente, desde que você pague uma parte do saldo devido. É uma forma de crédito que não tem um prazo fixo, e você pode manter o saldo em aberto, desde que faça o pagamento mínimo exigido.

Vejamos um exemplo abaixo:
Por exemplo, se você tem um limite de R\$ 5.000 e gasta R\$ 2.000, na data de vencimento da fatura, você pode optar por pagar apenas o mínimo exigido, digamos R\$ 200. O saldo restante de R\$ 1.800 será transferido para o próximo mês e estará sujeito a juros, que podem ser bastante altos. Enquanto você paga parte do saldo, o crédito disponível no seu cartão é reabastecido. Portanto, se pagar os R\$ 1.800 restantes, o crédito disponível volta ao máximo de R\$ 5.000. Caso não pague, o limite disponível diminui.

Antecipação do salário
Na antecipação do salário, como o próprio nome já diz é uma solicitação do cliente para anteciparem parte do seu salário, devido a um motivo especificado pela pessoa. Seu pedido será avaliado e se aprovado ele receberá o dinheiro, porém será descontado a mesma quantia (mais juros) do seu próximo pagamento.
''',
      buttonText: 'Próximo',
      onActionPressed: () {
        Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FinanciamentoScreen()));
      },
    );
  }
}
