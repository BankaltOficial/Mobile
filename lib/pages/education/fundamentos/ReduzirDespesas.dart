import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/PageEducation.dart';

class ReduzirDespesasScreen extends StatefulWidget {
  const ReduzirDespesasScreen({super.key});

  @override
  State<ReduzirDespesasScreen> createState() => _ReduzirDespesasScreenState();
}

class _ReduzirDespesasScreenState extends State<ReduzirDespesasScreen> {
  @override
  Widget build(BuildContext context) {
    return PageEducationScreen(
      appBarTitle: 'Educação Financeira',
      title: 'Reduzir despesas',
      highlightedQuestion: 'Método 50-15-35',
      content: '''
Método 50-15-35
O método 50-15-35 é uma forma de se organizar financeiramente muito conhecida no mundo da educação financeira, que basicamente consiste na divisão de despesas por porcentagem. Metade do seu orçamento mensal vai para as despesas fixas, que como já vimos antes engloba aluguéis, conta de luz e água, mensalidades escolares… 15% do orçamento é destinado para prioridades financeiras e dívidas. Se você não tiver dívidas, essa parte do orçamento pode ser investida. E por último, 35% do dinheiro vai para o lazer e o bem-estar pessoal. O ideal é lembrar que essa parte deve ser a primeira com cortes de gastos caso você passe por um aperto e ela sempre deve estar aberta a mudanças.
Apesar de ser um ótimo modo de organização financeira, ele não permite diminuições nessas parcelas e por isso, muitas vezes é necessário ir um ponto além desse método para conseguir reduzir melhor as suas despesas mensais.

Como reduzir despesas fixas da casa?
Como as despesas fixas muitas vezes não podem sofrer cortes, é necessário adotar algumas medidas conscientes para uma diminuição das contas no final do mês. Então, atente-se em economizar água enquanto escova os dentes, lava o quintal, lava as louças, toma banho e etc. Isso é uma ação consciente que ajuda o seu bolso e o mundo ao mesmo tempo.

Reduza despesas com lazer
Reduzir despesas com lazer pode ser um desafio, mas com algumas estratégias simples, é possível se divertir sem comprometer o orçamento. Primeiro, busque opções gratuitas ou de baixo custo em sua comunidade, como eventos culturais, feiras e atividades ao ar livre, que muitas vezes oferecem entretenimento sem custo. Além disso, aproveite promoções e descontos em cinemas, teatros e shows, verificando sites de ofertas e redes sociais.
Outra maneira de economizar é organizar encontros em casa com amigos, em vez de sair para comer ou beber. Cozinhar em grupo pode ser divertido e muito mais barato. Considere também fazer atividades que não envolvem gastos, como caminhadas, trilhas ou piqueniques em parques.
Por fim, planeje suas saídas com antecedência, definindo um orçamento específico para o que deseja fazer, evitando assim gastos impulsivos. Com criatividade e planejamento, é possível aproveitar momentos de lazer de maneira econômica e ainda assim se divertir bastante.

Cuidados com o cartão de crédito
De novo iremos falar do cartão de crédito, pois ele pode ser tanto benéfico quanto negativo para seu orçamento no final do mês, por isso novamente salientamos em ter bastante cuidado ao usar esse método de compra e sempre se atente às taxas de juros acumuladas. 
O cartão de crédito é uma ferramenta muito importante, mas somente para quem sabe usá-lo corretamente. Você não tem o dinheiro que ele te proporciona, você deve essa verba, lembre-se sempre disso.
''',
      buttonText: 'Próximo',
      onActionPressed: () {
        // ação ao pressionar o botão
      },
    );
  }
}
