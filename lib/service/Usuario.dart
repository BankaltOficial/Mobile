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

  // Construtor principal
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

  // Construtor privado para fromJson
  Usuario._fromJson({
    required int id,
    required String nome,
    required String email,
    required String cpf,
    required String rg,
    required String dataNascimento,
    required String telefone,
    required String senha,
    required double saldo,
    required int score,
    required int ponto,
    required String numeroCartao,
    required String cvv,
    required String validadeCartao,
    required String chavePix,
    required String corPrincipal,
    required String corSecundaria,
    required String corTerciaria,
    required bool temaEscuro,
  })  : _id = id,
        _nome = nome,
        _email = email,
        _cpf = cpf,
        _rg = rg,
        _dataNascimento = dataNascimento,
        _telefone = telefone,
        _senha = senha,
        _saldo = saldo,
        _score = score,
        _ponto = ponto,
        _numeroCartao = numeroCartao,
        _cvv = cvv,
        _validadeCartao = validadeCartao,
        _chavePix = chavePix,
        _corPrincipal = corPrincipal,
        _corSecundaria = corSecundaria,
        _corTerciaria = corTerciaria,
        _temaEscuro = temaEscuro;

  // Factory constructor para criar Usuario a partir de JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    // Atualizar o _idCounter se necessário para evitar conflitos
    int id = json['id'] as int;
    if (id >= _idCounter) {
      _idCounter = id + 1;
    }

    return Usuario._fromJson(
      id: id,
      nome: json['nome'] as String,
      email: json['email'] as String,
      cpf: json['cpf'] as String,
      rg: json['rg'] as String,
      dataNascimento: json['dataNascimento'] as String,
      telefone: json['telefone'] as String,
      senha: json['senha'] as String,
      saldo: (json['saldo'] as num).toDouble(),
      score: json['score'] as int,
      ponto: json['ponto'] as int,
      numeroCartao: json['numeroCartao'] as String,
      cvv: json['cvv'] as String,
      validadeCartao: json['validadeCartao'] as String,
      chavePix: json['chavePix'] as String,
      corPrincipal: json['corPrincipal'] as String? ?? '#353DAB',
      corSecundaria: json['corSecundaria'] as String? ?? '#027BD4',
      corTerciaria: json['corTerciaria'] as String? ?? '#04A95C',
      temaEscuro: json['temaEscuro'] as bool? ?? false,
    );
  }

  // Método para converter Usuario para JSON
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

  // Métodos de transação
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

  // Métodos auxiliares para geração de dados do cartão
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

  @override
  String toString() {
    return 'Usuario{id: $_id, nome: $_nome, email: $_email, cpf: $_cpf, saldo: $_saldo}';
  }
}

// Função auxiliar para formatação de data
String formatarData(DateTime data) {
  String dia = data.day.toString().padLeft(2, '0');
  String mes = data.month.toString().padLeft(2, '0');
  String ano = data.year.toString();
  return '$dia/$mes/$ano';
}

// Lista de usuários padrão
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
    '965.511.320-57',
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

// Funções auxiliares
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