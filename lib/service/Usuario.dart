import 'dart:math';

class Usuario {
  static int _idCounter = 1;

  final int _id;
  String _nome;
  String _email;
  String _cpf;
  String _rg;
  String _dataNascimento;
  String _celular;
  String _senha;
  double _saldo = 100;
  int _score = 0;
  int _ponto = 0;
  final String _numeroCartao;
  final String _cvv;
  final String _validadeCartao;

  Usuario(
    this._nome,
    this._email,
    this._cpf,
    this._rg,
    this._dataNascimento,
    this._celular,
    this._senha,
    //double saldo = 100.0,
  )   : _id = _idCounter++,
        _numeroCartao = _gerarNumeroCartao(),
        _cvv = _gerarCvv(),
        _validadeCartao = _gerarValidadeCartao();

  int get id => _id;
  String get nome => _nome;
  String get email => _email;
  String get cpf => _cpf;
  String get rg => _rg;
  String get dataNascimento => _dataNascimento;
  String get celular => _celular;
  String get senha => _senha;
  double get saldo => _saldo;
  int get score => _score;
  int get ponto => _ponto;
  String get numeroCartao => _numeroCartao;
  String get cvv => _cvv;
  String get validadeCartao => _validadeCartao;

  set nome(String value) => _nome = value;
  set email(String value) => _email = value;
  set cpf(String value) => _cpf = value;
  set rg(String value) => _rg = value;
  set dataNascimento(String value) => _dataNascimento = value;
  set celular(String value) => _celular = value;
  set senha(String value) => _senha = value;
  set saldo(double value) => _saldo = value;
  set score(int value) => _score = value;
  set ponto(int value) => _ponto = value;

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

  static String _gerarNumeroCartao() {
    final random = Random();
    return List.generate(16, (_) => random.nextInt(10)).join();
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
    '(11) 91234-5678',
    '123',
  ),
  Usuario("João", "jp@gmail.com", "111.111.111-11", "11.111.111-1",
      "11/11/1111", "(31) 93456-7890", "123"),
  Usuario(
    'Igor Suracci',
    'igor@email.com',
    '333.333.333-33',
    '45.678.912-3',
    formatarData(DateTime(2000, 1, 5)),
    '(31) 93456-7890',
    '23',
  ),
];

bool encontrarUsuarioPorCpf (String cpf) {
  if (usuarios.firstWhere((u) => u.cpf == cpf) != null) {
    return true;
  }
  return false;
}

Usuario verificarUsuarioPorCpf(String cpf) {
  try {
    return usuarios.firstWhere((u) => u.cpf == cpf);
  } catch (e) {
    throw Exception('Usuário já cadastrado com este CPF');
  }
}

Usuario verificarUsuarioPorRg(String rg) {
  try {
    return usuarios.firstWhere((u) => u.rg == rg);
  } catch (e) {
    throw Exception('Usuário já cadastrado com este CPF');
  }
}

Usuario verificarUsuarioPorEmail(String email) {
  try {
    return usuarios.firstWhere((u) => u.email == email);
  } catch (e) {
    throw Exception('Usuário já cadastrado com este CPF');
  }
}

Usuario login(String cpf, String senha) {
  Usuario? usuario = verificarUsuarioPorCpf(cpf);
  if (usuario != null && usuario.senha == senha) {
    return usuario;
  } else {
    throw Exception('CPF ou senha inválidos');
  }
}

void cadastrarUsuario(Usuario usuario) {
  if (verificarUsuarioPorCpf(usuario.cpf) != null) {
    throw Exception('Usuário já cadastrado com este CPF');
  }
  if (verificarUsuarioPorRg(usuario.rg) != null) {
    throw Exception('Usuário já cadastrado com este RG');
  }
  if (verificarUsuarioPorEmail(usuario.email) != null) {
    throw Exception('Usuário já cadastrado com este email');
  }
  usuarios.add(usuario);
}
