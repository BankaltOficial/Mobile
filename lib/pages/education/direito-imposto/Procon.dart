import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/PageEducation.dart';

class ProconScreen extends StatefulWidget {
  const ProconScreen({super.key});

  @override
  State<ProconScreen> createState() => _ProconScreenState();
}

class _ProconScreenState extends State<ProconScreen> {
  @override
  Widget build(BuildContext context) {
    return PageEducationScreen(
      appBarTitle: 'Educação Financeira',
      title: 'PROCON',
      highlightedQuestion: 'O que é o PROCON?',
      content: '''
O PROCON (Programa de Proteção e Defesa do Consumidor) é um órgão responsável por proteger os direitos dos consumidores e promover relações de consumo mais justas.

Origem

O PROCON foi criado no Brasil em 1976, inicialmente em São Paulo, como resposta à necessidade de um órgão que pudesse defender os direitos dos consumidores diante de abusos e práticas comerciais desleais. Com o passar do tempo, outros estados e municípios também instituíram seus próprios PROCONs, sempre procurando proteger o consumidor.

Atuação

Fiscalização: O órgão monitora práticas comerciais, verificando se as empresas cumprem as normas do Código de Defesa do Consumidor (CDC) e coibindo abusos, como propaganda enganosa e preços indevidos.

Atendimento ao consumidor: O PROCON oferece atendimento ao público para receber reclamações e orientações sobre direitos e deveres, ajudando os consumidores a resolverem conflitos com fornecedores.

Educação e conscientização: O PROCON realiza campanhas educativas e informativas para promover a conscientização dos consumidores sobre seus direitos, ajudando a prevenir abusos.

Mediação e conciliação: O órgão busca resolver conflitos entre consumidores e empresas por meio da mediação, ajudando as partes a chegarem a um acordo satisfatório.

Assistência ao consumidor

Orientação: Os consumidores podem obter informações sobre seus direitos e como agir em situações de desrespeito, além de dicas sobre consumo consciente.

Registro de reclamações: O PROCON permite que os consumidores registrem suas queixas formalmente, o que pode levar a investigações e ações contra empresas infratoras.

Acompanhamento de processos: O órgão acompanha o andamento das reclamações e mediações, garantindo que os consumidores recebam o devido suporte.
''',
      buttonText: 'Próximo',
      onActionPressed: () {
        // ação para próxima tela ou função
      },
    );
  }
}
