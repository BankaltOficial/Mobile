import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/PageEducation.dart';

class RendaVariavelScreen extends StatefulWidget {
  const RendaVariavelScreen({super.key});

  @override
  State<RendaVariavelScreen> createState() => _RendaVariavelScreenState();
}

class _RendaVariavelScreenState extends State<RendaVariavelScreen> {
  @override
  Widget build(BuildContext context) {
    return PageEducationScreen(
      appBarTitle: 'Educação Financeira',
      title: 'Renda Variável',
      highlightedQuestion: 'O que é renda variável?',
      content: '''
O que é renda variável?
Diferente da renda fixa, a renda variável é um investimento inconstante, ou seja, não é um tipo de investimento que possa ser previsível no mercado financeiro. A renda variável tem um risco muito maior atrelado, comparado à renda fixa, pois não há nenhuma garantia de que o cliente irá ganhar, por isso deve-se ter bastante cuidado ao investir nesses tipos de aplicações. Por outro lado, para compensar o risco, a renda variável pode ser mais lucrativa se utilizada da maneira correta, agindo com cautela e muita pesquisa.
Tipos de renda variável
Ações
O tipo mais comum entre os investimentos de renda variável, as ações são obtidas na bolsa de valores e basicamente podem ser definidas como partes de empresas oferecidas pelas instituições aos acionistas, como uma forma alternativa de gerar renda. Em troca, os investidores ganham com a distribuição de dividendos. Conforme os resultados das instituições aparecem (sejam eles bons ou ruins), as ações podem valorizar ou desvalorizar e é nisso que estarão baseados os ganhos dos acionistas. Se a empresa estiver tendo bons resultados, as ações valorizam e os acionistas ganham, do contrário eles perdem.
Fundos Imobiliários (FIIs)
Os fundos imobiliários funcionam de forma semelhante às ações, porém os recursos arrecadados por eles são utilizados para uma finalidade diferente, na qual a renda é usada para construção ou compra de imóveis. Fora isso os FIIs agem como um tipo de investimento com renda variável, pois dependem da oferta e demanda do mercado nestes imóveis.
''',
      buttonText: 'Próximo',
      onActionPressed: () {
        // ação ao pressionar o botão
      },
    );
  }
}
