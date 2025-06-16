class Boleto {
  String _nomePagante;
  String _cpfPagante;
  int _codigo;
  double _valorPago;
  double _total;

  Boleto(this._nomePagante, this._cpfPagante, this._codigo, this._valorPago,
      this._total);

  String get nomePagante => this._nomePagante;
  set nomePagante(String value) => this._nomePagante = value;

  String get cpfPagante => this._cpfPagante;
  set cpfPagante(String value) => this._cpfPagante = value;

  int get codigo => this._codigo;
  set codigo(int value) => this._codigo = value;

  double get total => this._total;
  set total(double value) => this._total = value;

  double get valorPago => this._valorPago;
  set valorPago(double value) => this._valorPago = value;

  // Método para calcular valor restante
  double get valorRestante => this._total - this._valorPago;

  // Método para verificar se está quitado
  bool get isQuitado => this._valorPago >= this._total;

  // Método para realizar pagamento parcial
  bool pagarValor(double valor) {
    if (valor <= 0) return false;
    if (this._valorPago >= this._total) return false; // Já está quitado
    
    double novoValorPago = this._valorPago + valor;
    
    // Não permite pagar mais que o total
    if (novoValorPago > this._total) {
      this._valorPago = this._total;
    } else {
      this._valorPago = novoValorPago;
    }
    
    return true;
  }

  // Método para verificar se um valor pode ser pago
  bool podeReceberPagamento(double valor) {
    if (valor <= 0) return false;
    if (this._valorPago >= this._total) return false;
    return true;
  }

  // Método para obter o valor máximo que pode ser pago
  double get valorMaximoPagamento => this._total - this._valorPago;

  // Método toString para debug
  @override
  String toString() {
    return 'Boleto{nomePagante: $_nomePagante, cpfPagante: $_cpfPagante, codigo: $_codigo, valorPago: $_valorPago, total: $_total, valorRestante: $valorRestante, isQuitado: $isQuitado}';
  }
}

// Lista global de boletos para simulação
List<Boleto> boletos = [
  Boleto('Flakes', '555.555.555-55', 1234567890, 0, 1000),
  Boleto('Igor Suracci', '333.333.333-33', 2222222222, 150, 5000),
  Boleto('João Pedro Fabiano', '111.111.111-11', 3333333333, 300, 2000),
  Boleto('Maria Clara', '444.444.444-44', 4444444444, 0, 1500),
  Boleto('Flakes', '555.555.555-55', 5555555555, 200, 3000),
  Boleto('Igor Suracci', '333.333.333-33', 6666666666, 200, 4000),
];

// Função para buscar boleto por código
Boleto buscarBoleto(int codigo) {
  try {
    return boletos.firstWhere((b) => b.codigo == codigo);
  } catch (e) {
    throw Exception('Boleto não encontrado');
  }
}

// Função para processar pagamento
bool processarPagamento(int codigoBoleto, double valorPagamento) {
  try {
    Boleto boleto = buscarBoleto(codigoBoleto);
    return boleto.pagarValor(valorPagamento);
  } catch (e) {
    return false;
  }
}

// Função para atualizar boleto na lista (simula persistência)
void atualizarBoleto(Boleto boletoAtualizado) {
  for (int i = 0; i < boletos.length; i++) {
    if (boletos[i].codigo == boletoAtualizado.codigo) {
      boletos[i] = boletoAtualizado;
      break;
    }
  }
}

// Função para listar todos os boletos (útil para debug)
List<Boleto> listarTodosBoletos() {
  return List.from(boletos);
}