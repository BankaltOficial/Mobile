import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/PageEducation.dart';
import 'package:flutter_application_1/pages/education/direito-imposto/Procon.dart';

class CodigoConsumidorScreen extends StatefulWidget {
  const CodigoConsumidorScreen({super.key});

  @override
  State<CodigoConsumidorScreen> createState() => _CodigoConsumidorScreenState();
}

class _CodigoConsumidorScreenState extends State<CodigoConsumidorScreen> {
  @override
  Widget build(BuildContext context) {
    return PageEducationScreen(
      appBarTitle: 'Educação Financeira',
      title: 'Código do Consumidor (CDC)',
      highlightedQuestion: 'O que é o Código de Defesa do Consumidor?',
      content: '''
O Código de Defesa do Consumidor, criado pela Lei nº 8.078 de 1990, é uma legislação brasileira que tem como principal objetivo proteger os direitos dos consumidores. Ele estabelece regras e diretrizes que garantem uma relação mais justa entre consumidores e fornecedores de produtos e serviços.

É importante saber sobre o CDC pois ele garante diversos direitos para o consumidor, que normalmente não sabemos, portanto podendo ser um conhecimento valioso para assegurar relações comerciais justas, seguras e soluções rápidas para conflitos.

Princípios do CDC

Proteção à Vida e à Saúde: Os produtos e serviços devem ser seguros e não colocar em risco a saúde dos consumidores.

Educação para o Consumo: O Código incentiva a educação do consumidor sobre seus direitos e deveres, promovendo uma escolha consciente.

Transparência: As informações sobre produtos e serviços devem ser claras e precisas, evitando que o consumidor seja enganado.

Direitos Básicos do Consumidor

Proteção contra Publicidade Enganosa: O consumidor não pode ser induzido a erro por informações falsas ou enganosas.

Direito à Informação: O consumidor deve receber informações claras sobre as características, qualidade e preço dos produtos e serviços.

Liberdade de Escolha: O consumidor deve ter a liberdade de escolher entre diferentes produtos e serviços, sem pressões indevidas.

Garantia de Qualidade: Os produtos e serviços devem atender a padrões de qualidade e segurança.

Direito à Reparação: Se um produto ou serviço causar danos, o consumidor tem o direito de ser indenizado.

Garantias

Prazo de Arrependimento: O consumidor tem até 7 dias para desistir de uma compra realizada fora do estabelecimento comercial, como em compras pela internet. Durante esse período, pode devolver o produto e receber o dinheiro de volta.

Garantia de Produtos: Os produtos vendidos devem ter uma garantia mínima de 90 dias, podendo ser maior se o fabricante oferecer. Essa garantia cobre defeitos de fabricação.

Assistência Técnica: O consumidor tem direito a assistência técnica em caso de problemas com produtos que estão dentro do período de garantia.

Práticas Comerciais e Cláusulas Abusivas

Cláusulas Abusivas: Cláusulas contratuais que sejam desproporcionais ou que coloquem o consumidor em desvantagem excessiva são consideradas nulas.

Facilidade de Acesso à Justiça: O consumidor pode recorrer aos Juizados Especiais para resolver conflitos de forma rápida e com custos reduzidos.
''',
      buttonText: 'Próximo',
      onActionPressed: () {
        Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProconScreen()));
      },
    );
  }
}
