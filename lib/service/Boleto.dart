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

  get codigo => this._codigo;

  set codigo(value) => this._codigo = value;

  get total => this._total;

  set total(value) => this._total = value;

  double get valorPago => this._valorPago;

  set valorPago(double value) => this._valorPago = value;
}

List<Boleto> boletos = [
  Boleto('Flakes', '555.555.555-55', 12345, 0, 1000),
  Boleto('Igor Suracci', '333.333.333-33', 222222, 150, 5000),
  Boleto('João Pedro Fabiano', '111.111.111-11', 333333, 300, 2000),
];

Boleto buscarBoleto(int codigo) {
  try {
    return boletos.firstWhere((b) => b.codigo == codigo);
  } catch (e) {
    throw Exception('Boleto não encontrado');
  }
}
