class Investimento {
  final String _id;
  final String _nomeAtivo;
  final String _tipoAtivo;
  final double _valorInvestido;
  final DateTime _dataInvestimento;
  final String _resgateDisponivel;
  final int _usuarioId;

  Investimento({
    String? id, // Opcional para permitir geração automática
    required String nomeAtivo,
    required String tipoAtivo,
    required double valorInvestido,
    required DateTime dataInvestimento,
    required String resgateDisponivel,
    required int usuarioId,
  }) : _id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       _nomeAtivo = nomeAtivo,
       _tipoAtivo = tipoAtivo,
       _valorInvestido = valorInvestido,
       _dataInvestimento = dataInvestimento,
       _resgateDisponivel = resgateDisponivel,
       _usuarioId = usuarioId;

  // Construtor para criar investimento a partir de JSON
  Investimento.fromJson(Map<String, dynamic> json)
      : _id = json['id'].toString(), // Garantir que seja String
        _nomeAtivo = json['nomeAtivo'],
        _tipoAtivo = json['tipoAtivo'],
        _valorInvestido = json['valorInvestido'].toDouble(),
        _dataInvestimento = DateTime.parse(json['dataInvestimento']),
        _resgateDisponivel = json['resgateDisponivel'],
        _usuarioId = json['usuarioId'];

  // Getters
  String get id => _id; // Mudou de int para String
  String get nomeAtivo => _nomeAtivo;
  String get tipoAtivo => _tipoAtivo;
  double get valorInvestido => _valorInvestido;
  DateTime get dataInvestimento => _dataInvestimento;
  String get resgateDisponivel => _resgateDisponivel;
  int get usuarioId => _usuarioId;

  // Método para verificar se pode resgatar
  bool podeResgatar() {
    if (_resgateDisponivel.toLowerCase().contains('imediato')) {
      return true;
    }

    // Verificar D+2 (renda variável)
    if (_resgateDisponivel.toLowerCase().contains('d+2')) {
      DateTime dataLiberacao = _dataInvestimento.add(Duration(days: 2));
      return DateTime.now().isAfter(dataLiberacao);
    }

    // Se tem uma data específica (formato dd/MM/yyyy)
    if (_resgateDisponivel.contains('/')) {
      try {
        List<String> parts = _resgateDisponivel.split('/');
        if (parts.length == 3) {
          int dia = int.parse(parts[0]);
          int mes = int.parse(parts[1]);
          int ano = int.parse(parts[2]);
          DateTime dataResgate = DateTime(ano, mes, dia);
          return DateTime.now().isAfter(dataResgate);
        }
      } catch (e) {
        return false;
      }
    }

    // Se tem um período em dias
    final regex = RegExp(r'(\d+)\s*dias');
    final match = regex.firstMatch(_resgateDisponivel);
    if (match != null) {
      final dias = int.tryParse(match.group(1) ?? '');
      if (dias != null) {
        DateTime dataLiberacao = _dataInvestimento.add(Duration(days: dias));
        return DateTime.now().isAfter(dataLiberacao);
      }
    }

    // Se tem um ano específico
    final regexAno = RegExp(r'(\d{4})');
    final matchAno = regexAno.firstMatch(_resgateDisponivel);
    if (matchAno != null) {
      final ano = int.tryParse(matchAno.group(1) ?? '');
      if (ano != null) {
        DateTime dataResgate = DateTime(ano, 12, 31);
        return DateTime.now().isAfter(dataResgate);
      }
    }

    return false;
  }

  // Converter investimento para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'nomeAtivo': _nomeAtivo,
      'tipoAtivo': _tipoAtivo,
      'valorInvestido': _valorInvestido,
      'dataInvestimento': _dataInvestimento.toIso8601String(),
      'resgateDisponivel': _resgateDisponivel,
      'usuarioId': _usuarioId,
    };
  }
}

// Lista global de investimentos
List<Investimento> investimentos = [];