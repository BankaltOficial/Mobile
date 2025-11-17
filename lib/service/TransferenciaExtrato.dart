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
    this.saldoAnterior = 0.0,
    this.saldoPosterior = 0.0,
  });

  /// Factory para API de Extrato antiga (formato com clienteEnvio/clienteRecebido)
  factory TransacaoExtrato.fromJson(Map<String, dynamic> json, int clienteLogadoId) {
    // Verificar se é da API antiga ou nova
    bool isApiAntiga = json.containsKey('clienteEnvio') || json.containsKey('clienteRecebido');
    bool isApiNova = json.containsKey('remetenteId') || json.containsKey('destinatarioId');

    if (isApiAntiga) {
      return _fromJsonApiAntiga(json, clienteLogadoId);
    } else if (isApiNova) {
      return _fromJsonApiNova(json, clienteLogadoId);
    } else {
      // Fallback para formato padrão
      return _fromJsonApiNova(json, clienteLogadoId);
    }
  }

  /// Parser para API antiga (formato original do seu backend)
  static TransacaoExtrato _fromJsonApiAntiga(Map<String, dynamic> json, int clienteLogadoId) {
    String tipoTransacaoBackend = json['tipoTransacao'] ?? 'TRANSFERENCIA';
    
    // Determinar se é envio ou recebimento
    bool isEnvio = json['clienteEnvio'] != null && 
                   json['clienteEnvio']['id'] == clienteLogadoId;
    
    // Mapear o tipo correto
    TipoTransacao tipo = _mapearTipo(tipoTransacaoBackend, isEnvio);
    
    // Criar descrição
    String descricao = _criarDescricaoApiAntiga(json, tipo, isEnvio);
    
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

  /// Parser para API nova (formato TransacaoModel)
  static TransacaoExtrato _fromJsonApiNova(Map<String, dynamic> json, int clienteLogadoId) {
    // Determinar se é enviado ou recebido baseado nos IDs
    bool ehEnviado = json['remetenteId'] == clienteLogadoId;
    bool ehRecebido = json['destinatarioId'] == clienteLogadoId;

    // Determinar o tipo de transação
    TipoTransacao tipo;
    String tipoString = (json['tipo'] ?? 'PIX').toString().toUpperCase();

    if (tipoString == 'PIX') {
      tipo = ehEnviado ? TipoTransacao.PIX_ENVIADO : TipoTransacao.PIX_RECEBIDO;
    } else if (tipoString == 'TRANSFERENCIA') {
      tipo = ehEnviado
          ? TipoTransacao.TRANSFERENCIA_ENVIADA
          : TipoTransacao.TRANSFERENCIA_RECEBIDA;
    } else if (tipoString == 'DEPOSITO') {
      tipo = TipoTransacao.DEPOSITO;
    } else if (tipoString == 'PAGAMENTO_CARTAO' || tipoString == 'PAGAMENTO') {
      tipo = TipoTransacao.PAGAMENTO_CARTAO;
    } else {
      tipo = ehEnviado ? TipoTransacao.PIX_ENVIADO : TipoTransacao.PIX_RECEBIDO;
    }

    // Criar descrição (já vem do backend ou criar uma)
    String descricao = json['descricao']?.toString() ?? _criarDescricaoApiNova(tipo, json);

    return TransacaoExtrato(
      id: json['id']?.toString() ?? '',
      tipo: tipo,
      valor: (json['valor'] as num?)?.toDouble() ?? 0.0,
      data: json['dataHora'] != null 
          ? DateTime.parse(json['dataHora'])
          : (json['data'] != null ? _parseDateTime(json['data']) : DateTime.now()),
      descricao: descricao,
      chavePix: json['chavePix'],
      contaDestino: json['contaDestino']?.toString() ?? 
                    (ehEnviado ? json['destinatarioId']?.toString() : null),
      contaOrigem: json['contaOrigem']?.toString() ?? 
                   (!ehEnviado ? json['remetenteId']?.toString() : null),
      numeroCartao: json['numeroCartao'],
      saldoAnterior: (json['saldoAnterior'] as num?)?.toDouble() ?? 0.0,
      saldoPosterior: (json['saldoPosterior'] as num?)?.toDouble() ?? 0.0,
    );
  }

  static TipoTransacao _mapearTipo(String tipoBackend, bool isEnvio) {
    switch (tipoBackend.toUpperCase()) {
      case 'PIX':
        return isEnvio ? TipoTransacao.PIX_ENVIADO : TipoTransacao.PIX_RECEBIDO;
      case 'TRANSFERENCIA':
        return isEnvio 
            ? TipoTransacao.TRANSFERENCIA_ENVIADA 
            : TipoTransacao.TRANSFERENCIA_RECEBIDA;
      case 'DEPOSITO':
        return TipoTransacao.DEPOSITO;
      case 'PAGAMENTO_CARTAO':
      case 'PAGAMENTO':
        return TipoTransacao.PAGAMENTO_CARTAO;
      default:
        return isEnvio 
            ? TipoTransacao.TRANSFERENCIA_ENVIADA 
            : TipoTransacao.TRANSFERENCIA_RECEBIDA;
    }
  }

  static String _criarDescricaoApiAntiga(Map<String, dynamic> json, TipoTransacao tipo, bool isEnvio) {
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

  static String _criarDescricaoApiNova(TipoTransacao tipo, Map<String, dynamic> json) {
    switch (tipo) {
      case TipoTransacao.PIX_ENVIADO:
        return 'PIX enviado';
      
      case TipoTransacao.PIX_RECEBIDO:
        return 'PIX recebido';
      
      case TipoTransacao.TRANSFERENCIA_ENVIADA:
        return 'Transferência enviada';
      
      case TipoTransacao.TRANSFERENCIA_RECEBIDA:
        return 'Transferência recebida';
      
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
      // Tentar formato ISO primeiro (2024-12-25T17:00:00)
      if (dataString.contains('T')) {
        return DateTime.parse(dataString);
      }
      
      // Formato brasileiro: "25/12/2000 17:00"
      final parts = dataString.split(' ');
      final dateParts = parts[0].split('/');
      final timeParts = parts.length > 1 ? parts[1].split(':') : ['0', '0'];

      return DateTime(
        int.parse(dateParts[2]),
        int.parse(dateParts[1]),
        int.parse(dateParts[0]),
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
    } catch (e) {
      print('Erro ao parsear data: $e para string: $dataString');
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tipo': tipo.name,
      'valor': valor,
      'data': data.toIso8601String(),
      'descricao': descricao,
      'chavePix': chavePix,
      'contaDestino': contaDestino,
      'contaOrigem': contaOrigem,
      'numeroCartao': numeroCartao,
      'saldoAnterior': saldoAnterior,
      'saldoPosterior': saldoPosterior,
    };
  }
}