import 'dart:math';

class Usuario {
  static int _idCounter = 1;

  final int _id;
  String _nome;
  String _email;
  String _cpf;
  String _rg;
  String _dataNascimento;
  String _telefone;
  String _senha;
  double _saldo;
  int _score;
  int _ponto;
  final String _numeroCartao;
  final String _cvv;
  final String _validadeCartao;
  String _chavePix;
  String _corPrincipal;
  String _corSecundaria;
  String _corTerciaria;
  bool _temaEscuro;

  Usuario(this._nome, this._email, this._cpf, this._rg, this._dataNascimento,
      this._telefone, this._senha,
      {String corPrincipal = '#353DAB',
      String corSecundaria = '#027BD4',
      String corTerciaria = '#04A95C',
      bool temaEscuro = false})
      : _id = _idCounter++,
        _saldo = 100,
        _score = 0,
        _ponto = 0,
        _corPrincipal = corPrincipal,
        _corSecundaria = corSecundaria,
        _corTerciaria = corTerciaria,
        _numeroCartao = _gerarNumeroCartao(),
        _cvv = _gerarCvv(),
        _validadeCartao = _gerarValidadeCartao(),
        _chavePix = _email,
        _temaEscuro = temaEscuro;

  // Construtor para criar usuário a partir de JSON
  Usuario.fromJson(Map<String, dynamic> json)
      : _id = json['id'],
        _nome = json['nome'],
        _email = json['email'],
        _cpf = json['cpf'],
        _rg = json['rg'],
        _dataNascimento = json['dataNascimento'],
        _telefone = json['telefone'],
        _senha = json['senha'],
        _saldo = json['saldo'].toDouble(),
        _score = json['score'],
        _ponto = json['ponto'],
        _numeroCartao = json['numeroCartao'],
        _cvv = json['cvv'],
        _validadeCartao = json['validadeCartao'],
        _chavePix = json['chavePix'],
        _corPrincipal = json['corPrincipal'],
        _corSecundaria = json['corSecundaria'],
        _corTerciaria = json['corTerciaria'],
        _temaEscuro = json['temaEscuro'];

  // Getters
  int get id => _id;
  String get nome => _nome;
  String get email => _email;
  String get cpf => _cpf;
  String get rg => _rg;
  String get dataNascimento => _dataNascimento;
  String get telefone => _telefone;
  String get senha => _senha;
  double get saldo => _saldo;
  int get score => _score;
  int get ponto => _ponto;
  String get numeroCartao => _numeroCartao;
  String get cvv => _cvv;
  String get validadeCartao => _validadeCartao;
  String get chavePix => _chavePix;
  String get corPrincipal => _corPrincipal;
  String get corSecundaria => _corSecundaria;
  String get corTerciaria => _corTerciaria;
  bool get temaEscuro => _temaEscuro;

  // Setters
  set nome(String value) => _nome = value;
  set email(String value) => _email = value;
  set cpf(String value) => _cpf = value;
  set rg(String value) => _rg = value;
  set dataNascimento(String value) => _dataNascimento = value;
  set telefone(String value) => _telefone = value;
  set senha(String value) => _senha = value;
  set saldo(double value) => _saldo = value;
  set score(int value) => _score = value;
  set ponto(int value) => _ponto = value;
  set chavePix(String value) => _chavePix = value;
  set corPrincipal(String value) => _corPrincipal = value;
  set corSecundaria(String value) => _corSecundaria = value;
  set corTerciaria(String value) => _corTerciaria = value;
  set temaEscuro(bool value) => _temaEscuro = value;

  void depositar(double valor) {
    if (valor > 0) {
      _saldo += valor;
    }
  }

  void pix(double valor, Usuario destino) {
    if (valor > 0 && _saldo >= valor) {
      _saldo -= valor;
      destino._receber(valor);
      _score += 10;
    }
  }

  void pixPorChave(String chavePix, double valor) {
    try {
      Usuario destino = usuarios.firstWhere((u) => u.chavePix == chavePix);
      pix(valor, destino);
    } catch (e) {
      throw Exception('Chave Pix não encontrada');
    }
  }

  void transferir(double valor, Usuario destino) {
    if (valor > 0 && _saldo >= valor) {
      _saldo -= valor;
      destino._receber(valor);
      _score += 1;
    }
  }

  void _receber(double valor) {
    if (valor > 0) {
      _saldo += valor;
    }
  }

  void pagarComCartao(double valor) {
    if (valor > 0 && _saldo >= valor) {
      _saldo -= valor;
      _score += 5;
    }
  }

  // Converter usuário para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'nome': _nome,
      'email': _email,
      'cpf': _cpf,
      'rg': _rg,
      'dataNascimento': _dataNascimento,
      'telefone': _telefone,
      'senha': _senha,
      'saldo': _saldo,
      'score': _score,
      'ponto': _ponto,
      'numeroCartao': _numeroCartao,
      'cvv': _cvv,
      'validadeCartao': _validadeCartao,
      'chavePix': _chavePix,
      'corPrincipal': _corPrincipal,
      'corSecundaria': _corSecundaria,
      'corTerciaria': _corTerciaria,
      'temaEscuro': _temaEscuro,
    };
  }

  static String _gerarNumeroCartao() {
    final random = Random();
    final numeros = List.generate(16, (_) => random.nextInt(10));
    return List.generate(4, (i) => numeros.sublist(i * 4, (i + 1) * 4).join())
        .join(' ');
  }

  static String _gerarCvv() {
    final random = Random();
    return List.generate(3, (_) => random.nextInt(10)).join();
  }

  static String _gerarValidadeCartao() {
    final agora = DateTime.now();
    final validade = DateTime(agora.year + 5, agora.month);
    final mes = validade.month.toString().padLeft(2, '0');
    final ano = validade.year.toString();
    return '$mes/$ano';
  }
}

String formatarData(DateTime data) {
  String dia = data.day.toString().padLeft(2, '0');
  String mes = data.month.toString().padLeft(2, '0');
  String ano = data.year.toString();
  return '$dia/$mes/$ano';
}

List<Usuario> usuarios = [
  Usuario(
    'Gabigol',
    'gabigol@email.com',
    '123.456.789-00',
    '12.345.678-9',
    formatarData(DateTime(1995, 4, 10)),
    '(11) 91234-5678',
    '123',
  ),
  Usuario(
    'Flakes',
    'flakes@email.com',
    '555.555.555-55',
    '55.555.555-5',
    formatarData(DateTime(1995, 4, 10)),
    '(11) 91234-5625',
    '123',
  ),
  Usuario(
    'João',
    'joao@email.com',
    '111.111.111-11',
    '11.111.111-1',
    '01/01/2000',
    '(11) 91234-5678',
    'senha123',
    temaEscuro: false,
  ),
  Usuario(
    'Igor Suracci',
    'igor@email.com',
    '333.333.333-33',
    '45.678.912-3',
    formatarData(DateTime(2000, 1, 5)),
    '(31) 93456-7890',
    '23',
    temaEscuro: true,
  ),
];

bool encontrarUsuarioPorCpf(String cpf) {
  return usuarios.any((u) => u.cpf == cpf);
}

Usuario verificarUsuarioPorCpf(String cpf) {
  try {
    return usuarios.firstWhere((u) => u.cpf == cpf);
  } catch (e) {
    throw Exception('Usuário não encontrado com este CPF');
  }
}

Usuario verificarUsuarioPorRg(String rg) {
  try {
    return usuarios.firstWhere((u) => u.rg == rg);
  } catch (e) {
    throw Exception('Usuário não encontrado com este RG');
  }
}

Usuario verificarUsuarioPorEmail(String email) {
  try {
    return usuarios.firstWhere((u) => u.email == email);
  } catch (e) {
    throw Exception('Usuário não encontrado com este email');
  }
}

Usuario verificarUsuarioPorTelefone(String telefone) {
  try {
    return usuarios.firstWhere((u) => u.telefone == telefone);
  } catch (e) {
    throw Exception('Usuário não encontrado com este telefone');
  }
}

Usuario login(String cpf, String senha) {
  Usuario usuario = verificarUsuarioPorCpf(cpf);
  if (usuario.senha == senha) {
    return usuario;
  } else {
    throw Exception('CPF ou senha inválidos');
  }
}

void cadastrarUsuario(Usuario usuario) {
  if (usuarios.any((u) => u.cpf == usuario.cpf)) {
    throw Exception('Usuário já cadastrado com este CPF');
  }
  if (usuarios.any((u) => u.rg == usuario.rg)) {
    throw Exception('Usuário já cadastrado com este RG');
  }
  if (usuarios.any((u) => u.email == usuario.email)) {
    throw Exception('Usuário já cadastrado com este email');
  }
  usuarios.add(usuario);
}