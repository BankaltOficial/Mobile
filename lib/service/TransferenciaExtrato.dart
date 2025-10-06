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

  factory TransacaoExtrato.fromJson(Map<String, dynamic> json, int clienteLogadoId) {
    String tipoTransacaoBackend = json['tipoTransacao'] ?? 'TRANSFERENCIA';
    
    // Determinar se é envio ou recebimento
    bool isEnvio = json['clienteEnvio'] != null && 
                   json['clienteEnvio']['id'] == clienteLogadoId;
    
    // Mapear o tipo correto
    TipoTransacao tipo = _mapearTipo(tipoTransacaoBackend, isEnvio);
    
    // Criar descrição
    String descricao = _criarDescricao(json, tipo, isEnvio);
    
    return TransacaoExtrato(
      id: json['id'].toString(),
      tipo: tipo,
      valor: (json['valor'] as num).toDouble(),
      data: _parseDateTime(json['data']),
      descricao: descricao,
      chavePix: json['chavePix'],
      contaDestino: isEnvio && json['clienteRecebido'] != null
          ? json['clienteRecebido']['id'].toString()
          : null,
      contaOrigem: !isEnvio && json['clienteEnvio'] != null
          ? json['clienteEnvio']['id'].toString()
          : null,
      numeroCartao: json['numeroCartao'],
      saldoAnterior: 0,
      saldoPosterior: 0,
    );
  }

  static TipoTransacao _mapearTipo(String tipoBackend, bool isEnvio) {
    switch (tipoBackend) {
      case 'PIX':
        return isEnvio ? TipoTransacao.PIX_ENVIADO : TipoTransacao.PIX_RECEBIDO;
      case 'TRANSFERENCIA':
        return isEnvio 
            ? TipoTransacao.TRANSFERENCIA_ENVIADA 
            : TipoTransacao.TRANSFERENCIA_RECEBIDA;
      case 'DEPOSITO':
        return TipoTransacao.DEPOSITO;
      case 'PAGAMENTO_CARTAO':
        return TipoTransacao.PAGAMENTO_CARTAO;
      default:
        return isEnvio 
            ? TipoTransacao.TRANSFERENCIA_ENVIADA 
            : TipoTransacao.TRANSFERENCIA_RECEBIDA;
    }
  }

  static String _criarDescricao(Map<String, dynamic> json, TipoTransacao tipo, bool isEnvio) {
    // Se já tem descrição personalizada no backend, usar ela
    if (json['descricao'] != null && json['descricao'].toString().isNotEmpty) {
      return json['descricao'];
    }

    // Criar descrição baseada no tipo
    switch (tipo) {
      case TipoTransacao.PIX_ENVIADO:
        String destinatario = json['clienteRecebido']?['nome'] ?? 'Desconhecido';
        return 'PIX enviado para $destinatario';
      
      case TipoTransacao.PIX_RECEBIDO:
        String remetente = json['clienteEnvio']?['nome'] ?? 'Desconhecido';
        return 'PIX recebido de $remetente';
      
      case TipoTransacao.TRANSFERENCIA_ENVIADA:
        String destinatario = json['clienteRecebido']?['nome'] ?? 'Desconhecido';
        return 'Transferência para $destinatario';
      
      case TipoTransacao.TRANSFERENCIA_RECEBIDA:
        String remetente = json['clienteEnvio']?['nome'] ?? 'Desconhecido';
        return 'Transferência de $remetente';
      
      case TipoTransacao.DEPOSITO:
        return 'Depósito realizado';
      
      case TipoTransacao.PAGAMENTO_CARTAO:
        return 'Pagamento com cartão';
      
      default:
        return 'Transação';
    }
  }

  static DateTime _parseDateTime(String dataString) {
    try {
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
    } catch (e) {
      print('Erro ao parsear data: $e');
      return DateTime.now();
    }
  }
}