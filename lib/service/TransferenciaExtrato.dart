import 'package:flutter_application_1/pages/ExtratoScreen.dart';

enum TipoTransacao {
  PIX_ENVIADO,
  PIX_RECEBIDO,
  TRANSFERENCIA_ENVIADA,
  TRANSFERENCIA_RECEBIDA,
  DEPOSITO,
  PAGAMENTO_CARTAO,
}

class TransacaoExtrato {
  final String id;
  final TipoTransacao tipo;
  final double valor;
  final DateTime data;
  final String descricao;
  final String? chavePix;
  final String? contaDestino;
  final String? contaOrigem;
  final String? numeroCartao;
  final double saldoAnterior;
  final double saldoPosterior;

  TransacaoExtrato({
    required this.id,
    required this.tipo,
    required this.valor,
    required this.data,
    required this.descricao,
    this.chavePix,
    this.contaDestino,
    this.contaOrigem,
    this.numeroCartao,
    required this.saldoAnterior,
    required this.saldoPosterior,
  });

  factory TransacaoExtrato.fromJson(Map<String, dynamic> json, bool envio) {
    // Se for envio -> tipo é negativo, se for recebido -> positivo
    TipoTransacao tipo = envio
        ? TipoTransacao.TRANSFERENCIA_ENVIADA
        : TipoTransacao.TRANSFERENCIA_RECEBIDA;

    return TransacaoExtrato(
      id: json['id'].toString(),
      tipo: tipo,
      valor: (json['valor'] as num).toDouble(),
      data: _parseDateTime(json['data']),
      descricao: envio
          ? 'Transferência para ${json['clienteRecebido']['nome']}'
          : 'Transferência recebida de ${json['clienteEnvio']['nome']}',
      chavePix: envio
          ? null
          : json['clienteEnvio']['pix'].isNotEmpty
              ? json['clienteEnvio']['pix'][0]['chave']
              : null,
      contaDestino: envio ? json['clienteRecebido']['id'].toString() : null,
      contaOrigem: envio ? null : json['clienteEnvio']['id'].toString(),
      numeroCartao: null,
      saldoAnterior: 0, // você pode calcular se tiver lógica de saldo
      saldoPosterior: 0,
    );
  }

  static DateTime _parseDateTime(String dataString) {
    // Formato esperado: "25/12/2000 17:00"
    final parts = dataString.split(' ');
    final dateParts = parts[0].split('/');
    final timeParts = parts[1].split(':');

    return DateTime(
      int.parse(dateParts[2]),
      int.parse(dateParts[1]),
      int.parse(dateParts[0]),
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
  }
}
