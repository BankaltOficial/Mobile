// ignore_for_file: unnecessary_this, file_names

class Usuario {
  String _nome;
  String _email;
  String _cpf;
  String _rg;
  String _dataNascimento;
  String _celular;
  String _senha;

  Usuario(this._nome, this._email, this._cpf, this._rg, this._dataNascimento,
      this._celular, this._senha);

  get nome => this._nome;

  set nome(value) => this._nome = value;

  get email => this._email;

  set email(value) => this._email = value;

  get cpf => this._cpf;

  set cpf(value) => this._cpf = value;

  get rg => this._rg;

  set rg(value) => this._rg = value;

  get dataNascimento => this._dataNascimento;

  set dataNascimento(value) => this._dataNascimento = value;

  get celular => this._celular;

  set celular(value) => this._celular = value;

  get senha => this._senha;

  set senha(value) => this._senha = value;
}

List<Usuario> usuarios = [
    Usuario(
      'Alice Martins',
      'alice.martins@email.com',
      '123.456.789-00',
      '12.345.678-9',
      formatarData(DateTime(1995, 4, 10)),
      '(11) 91234-5678',
      'senhaSegura123',
    ),
    Usuario(
      'Bruno Silva',
      'bruno.silva@email.com',
      '987.654.321-00',
      '98.765.432-1',
      formatarData(DateTime(1988, 9, 23)),
      '(21) 99876-5432',
      'brunoPass@2024',
    ),
    Usuario(
      'Carla Souza',
      'carla.souza@email.com',
      '456.789.123-00',
      '45.678.912-3',
      formatarData(DateTime(2000, 1, 5)),
      '(31) 93456-7890',
      'carla2025!',
    ),
  ];

String formatarData(DateTime data) {
  String dia = data.day.toString().padLeft(2, '0');
  String mes = data.month.toString().padLeft(2, '0');
  String ano = data.year.toString();
  return '$dia/$mes/$ano';
}


Usuario? buscarUsuarioPorCpf(String cpf) {
  try {
    return usuarios.firstWhere((u) => u.cpf == cpf);
  } catch (e) {
    return null;
  }
}

Usuario? buscarUsuarioPorRg(String rg) {
  try {
    return usuarios.firstWhere((u) => u.rg == rg);
  } catch (e) {
    return null;
  }
}

Usuario? buscarUsuarioPorEmail(String email) {
  try {
    return usuarios.firstWhere((u) => u.email == email);
  } catch (e) {
    return null;
  }
}

Usuario login(String cpf, String senha) {
  Usuario? usuario = buscarUsuarioPorCpf(cpf);
  if (usuario != null && usuario.senha == senha) {
    return usuario;
  } else {
    throw Exception('CPF ou senha inválidos');
  }
}

void cadastrarUsuario(Usuario usuario) {
  if (buscarUsuarioPorCpf(usuario.cpf) != null) {
    throw Exception('Usuário já cadastrado com este CPF');
  }
  if (buscarUsuarioPorRg(usuario.rg) != null) {
    throw Exception('Usuário já cadastrado com este RG');
  }
  if (buscarUsuarioPorEmail(usuario.email) != null) {
    throw Exception('Usuário já cadastrado com este email');
  }
  usuarios.add(usuario);
}