import 'dart:math';

import 'package:flutter_application_1/service/UsuarioService.dart';

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
  
  // Campos de endereço separados (alinhados com EnderecoModel)
  String _rua;
  String _estado;
  String _numero;
  String _cidade;
  String _bairro;
  String _cep;
  String _complemento;
  
  // Campos do cliente
  String _sexo;
  String _estadoCivil;
  bool _possuiComorbidade;
  String _comorbidades;
  bool _possuiTEA;
  String _nivelSuporteTEA;

  // Construtor principal
  Usuario(
    this._nome,
    this._email,
    this._cpf,
    this._dataNascimento,
    this._telefone,
    this._rg,
    this._senha, {
    String sexo = '',
    String estadoCivil = '',
    String rua = '',
    String estado = '',
    String numero = '',
    String cidade = '',
    String bairro = '',
    String cep = '',
    String complemento = '',
    bool possuiComorbidade = false,
    String comorbidades = '',
    bool possuiTEA = false,
    String nivelSuporteTEA = '',
    String corPrincipal = '#353DAB',
    String corSecundaria = '#027BD4',
    String corTerciaria = '#04A95C',
    bool temaEscuro = false,
  })  : _id = _idCounter++,
        _saldo = 100,
        _score = 0,
        _ponto = 0,
        _sexo = sexo,
        _estadoCivil = estadoCivil,
        _rua = rua,
        _estado = estado,
        _numero = numero,
        _cidade = cidade,
        _bairro = bairro,
        _cep = cep,
        _complemento = complemento,
        _possuiComorbidade = possuiComorbidade,
        _comorbidades = comorbidades,
        _possuiTEA = possuiTEA,
        _nivelSuporteTEA = nivelSuporteTEA,
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
    required String sexo,
    required String estadoCivil,
    required String rua,
    required String estado,
    required String numero,
    required String cidade,
    required String bairro,
    required String cep,
    required String complemento,
    required bool possuiComorbidade,
    required String comorbidades,
    required bool possuiTEA,
    required String nivelSuporteTEA,
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
        _temaEscuro = temaEscuro,
        _sexo = sexo,
        _estadoCivil = estadoCivil,
        _rua = rua,
        _estado = estado,
        _numero = numero,
        _cidade = cidade,
        _bairro = bairro,
        _cep = cep,
        _complemento = complemento,
        _possuiComorbidade = possuiComorbidade,
        _comorbidades = comorbidades,
        _possuiTEA = possuiTEA,
        _nivelSuporteTEA = nivelSuporteTEA;

  // Factory constructor para criar Usuario a partir de JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    int id = json['id'] as int;

    if (id >= _idCounter) {
      _idCounter = id + 1;
    }

    // Extrair dados do endereço se existir
    Map<String, dynamic>? endereco = json['endereco'];
    
    return Usuario._fromJson(
      id: id,
      nome: json['nome'] ?? '',
      email: json['email'] ?? '',
      cpf: json['cpf'] ?? '',
      rg: json['rg'] ?? '',
      dataNascimento: json['datanascimento1'] ?? '',
      telefone: json['telefone'] ?? '',
      senha: json['senha'] ?? '',
      saldo: (json['rendaInvestimento']?['saldo'] as num?)?.toDouble() ?? 0.0,
      score: 0,
      ponto: 0,
      numeroCartao: json['cartaoModel'] != null &&
              (json['cartaoModel'] as List).isNotEmpty
          ? json['cartaoModel'][0]['numero'] ?? ''
          : '',
      cvv: json['cartaoModel'] != null &&
              (json['cartaoModel'] as List).isNotEmpty
          ? json['cartaoModel'][0]['cvv'] ?? ''
          : '',
      validadeCartao: json['cartaoModel'] != null &&
              (json['cartaoModel'] as List).isNotEmpty
          ? json['cartaoModel'][0]['datavalidade'] ?? ''
          : '',
      chavePix: json['pix'] != null && (json['pix'] as List).isNotEmpty
          ? json['pix'][0]['chave'] ?? ''
          : '',
      corPrincipal: json['corPrimaria'] ?? '#353DAB',
      corSecundaria: json['corSecundaria'] ?? '#027BD4',
      corTerciaria: json['corTerciaria'] ?? '#04A95C',
      temaEscuro: (json['modo'] as String?)?.toLowerCase() == 'dark',
      sexo: json['sexo'] ?? '',
      estadoCivil: json['estadoCivil'] ?? '',
      rua: endereco?['rua'] ?? '',
      estado: endereco?['estado'] ?? '',
      numero: endereco?['numero'] ?? '',
      cidade: endereco?['cidade'] ?? '',
      bairro: endereco?['bairro'] ?? '',
      cep: endereco?['cep'] ?? '',
      complemento: endereco?['complemento'] ?? '',
      possuiComorbidade: json['comorbidade'] != null && json['comorbidade'] != '',
      comorbidades: json['comorbidade'] ?? '',
      possuiTEA: json['nivelSuporte'] != null && json['nivelSuporte'] != '',
      nivelSuporteTEA: json['nivelSuporte'] ?? '',
    );
  }

  // Método para converter Usuario para JSON (formato da API)
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'nome': _nome,
      'email': _email,
      'cpf': _cpf,
      'rg': _rg,
      'datanascimento1': _dataNascimento,
      'telefone': _telefone,
      'celular': _telefone, // Usando telefone também como celular
      'senha': _senha,
      'sexo': _sexo,
      'estadoCivil': _estadoCivil,
      'modo': _temaEscuro ? 'dark' : 'light',
      'comorbidade': _possuiComorbidade ? _comorbidades : '',
      'nivelSuporte': _possuiTEA ? _nivelSuporteTEA : '',
      'corPrimaria': _corPrincipal,
      'corSecundaria': _corSecundaria,
      'corTerciaria': _corTerciaria,
      'endereco': {
        'rua': _rua,
        'estado': _estado,
        'numero': _numero,
        'cidade': _cidade,
        'bairro': _bairro,
        'cep': _cep,
        'complemento': _complemento,
      },
      'rendaInvestimento': {
        'saldo': _saldo,
      },
      'cartaoModel': [
        {
          'numero': _numeroCartao,
          'cvv': _cvv,
          'datavalidade': _validadeCartao,
        }
      ],
      'pix': [
        {
          'chave': _chavePix,
        }
      ],
    };
  }

  // Getters originais
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

  // Getters para campos de endereço
  String get rua => _rua;
  String get estado => _estado;
  String get numero => _numero;
  String get cidade => _cidade;
  String get bairro => _bairro;
  String get cep => _cep;
  String get complemento => _complemento;
  
  // Getter para endereço completo
  String get enderecoCompleto {
    List<String> partes = [];
    if (_rua.isNotEmpty) partes.add(_rua);
    if (_numero.isNotEmpty) partes.add(_numero);
    if (_bairro.isNotEmpty) partes.add(_bairro);
    if (_cidade.isNotEmpty) partes.add(_cidade);
    if (_estado.isNotEmpty) partes.add(_estado);
    if (_cep.isNotEmpty) partes.add('CEP: $_cep');
    return partes.join(', ');
  }

  // Getters para campos do cliente
  String get sexo => _sexo;
  String get estadoCivil => _estadoCivil;
  bool get possuiComorbidade => _possuiComorbidade;
  String get comorbidades => _comorbidades;
  bool get possuiTEA => _possuiTEA;
  String get nivelSuporteTEA => _nivelSuporteTEA;

  // Setters originais
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

  // Setters para campos de endereço
  set rua(String value) => _rua = value;
  set estado(String value) => _estado = value;
  set numero(String value) => _numero = value;
  set cidade(String value) => _cidade = value;
  set bairro(String value) => _bairro = value;
  set cep(String value) => _cep = value;
  set complemento(String value) => _complemento = value;

  // Setters para campos do cliente
  set sexo(String value) => _sexo = value;
  set estadoCivil(String value) => _estadoCivil = value;
  set possuiComorbidade(bool value) => _possuiComorbidade = value;
  set comorbidades(String value) => _comorbidades = value;
  set possuiTEA(bool value) => _possuiTEA = value;
  set nivelSuporteTEA(String value) => _nivelSuporteTEA = value;

  // Métodos de transação (mantidos sem alteração)
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

// Lista de usuários padrão (atualizada com os novos campos)
List<Usuario> usuarios = [
  Usuario(
    'Gabigol',
    'gabigol@email.com',
    '123.456.789-00',
    formatarData(DateTime(1995, 4, 10)),
    '(11) 91234-5678',
    '12.345.678-9',
    '123',
    sexo: 'Masculino',
    estado: 'SP',
    cidade: 'São Paulo',
    rua: 'Rua das Flores',
    numero: '123',
    bairro: 'Jardins',
    cep: '01234-567',
  ),
  Usuario(
    'Flakes',
    'flakes@email.com',
    '965.511.320-57',
    formatarData(DateTime(1995, 4, 10)),
    '(11) 91234-5625',
    '55.555.555-5',
    '123',
    sexo: 'Masculino',
    estado: 'RJ',
    cidade: 'Rio de Janeiro',
    rua: 'Av. Copacabana',
    numero: '456',
    bairro: 'Copacabana',
    cep: '22070-011',
  ),
  Usuario(
    'João',
    'joao@email.com',
    '111.111.111-11',
    '01/01/2000',
    '(11) 91234-5678',
    '11.111.111-1',
    'senha123',
    sexo: 'Masculino',
    estado: 'MG',
    cidade: 'Belo Horizonte',
    rua: 'Rua dos Inconfidentes',
    numero: '789',
    bairro: 'Centro',
    cep: '30140-120',
    temaEscuro: false,
  ),
  Usuario(
    'Igor Suracci',
    'igor@email.com',
    '333.333.333-33',
    formatarData(DateTime(2000, 1, 5)),
    '(31) 93456-7890',
    '45.678.912-3',
    '23',
    sexo: 'Masculino',
    estado: 'MG',
    cidade: 'Belo Horizonte',
    rua: 'Av. Afonso Pena',
    numero: '1010',
    bairro: 'Centro',
    cep: '30130-001',
    temaEscuro: true,
  ),
];

// Funções auxiliares (mantidas sem alteração)
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

Future<void> cadastrarUsuario(Usuario usuario) async {
  // Verificações locais primeiro (mantendo a lógica original)
  if (usuarios.any((u) => u.cpf == usuario.cpf)) {
    throw Exception('Usuário já cadastrado com este CPF');
  }
  if (usuarios.any((u) => u.rg == usuario.rg)) {
    throw Exception('Usuário já cadastrado com este RG');
  }
  if (usuarios.any((u) => u.email == usuario.email)) {
    throw Exception('Usuário já cadastrado com este email');
  }
  
  // Adicionar localmente (mantendo comportamento original)
  usuarios.add(usuario);
  
  // Tentar cadastrar na API também
  try {
    Map<String, dynamic> resultado = await UsuarioService.cadastrarUsuarioCompleto(usuario);
    if (!resultado['success']) {
      // Se falhar na API, ainda mantém o cadastro local mas informa o erro
      print('Aviso: Falha ao cadastrar na API: ${resultado['message']}');
    }
  } catch (e) {
    // Se der erro na conexão, ainda mantém o cadastro local
    print('Aviso: Erro de conexão com API: $e');
  }
}