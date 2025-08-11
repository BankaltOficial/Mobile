import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'Usuario.dart';

class UsuarioService {
  static const String _usuariosKey = 'usuarios_lista';
  static const String _usuarioLogadoKey = 'usuario_logado_id';

  // Salvar todos os usuários no SharedPreferences
  static Future<void> salvarUsuarios(List<Usuario> usuarios) async {
    final prefs = await SharedPreferences.getInstance();
    
    // Converter lista de usuários para JSON
    List<Map<String, dynamic>> usuariosJson = usuarios.map((usuario) => {
      'id': usuario.id,
      'nome': usuario.nome,
      'email': usuario.email,
      'cpf': usuario.cpf,
      'rg': usuario.rg,
      'dataNascimento': usuario.dataNascimento,
      'telefone': usuario.telefone,
      'senha': usuario.senha,
      'saldo': usuario.saldo,
      'score': usuario.score,
      'ponto': usuario.ponto,
      'numeroCartao': usuario.numeroCartao,
      'cvv': usuario.cvv,
      'validadeCartao': usuario.validadeCartao,
      'chavePix': usuario.chavePix,
      'corPrincipal': usuario.corPrincipal,
      'corSecundaria': usuario.corSecundaria,
      'corTerciaria': usuario.corTerciaria,
      'temaEscuro': usuario.temaEscuro,
    }).toList();
    
    String jsonString = jsonEncode(usuariosJson);
    await prefs.setString(_usuariosKey, jsonString);
    print('Usuários salvos: ${usuarios.length} usuários');
  }

  // Carregar todos os usuários do SharedPreferences
  static Future<List<Usuario>> carregarUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_usuariosKey);
    
    if (jsonString == null) {
      // Se não há dados salvos, retorna a lista padrão e salva
      print('Nenhum usuário salvo encontrado, carregando lista padrão');
      await salvarUsuarios(usuarios);
      return usuarios;
    }
    
    try {
      List<dynamic> jsonList = jsonDecode(jsonString);
      List<Usuario> usuariosCarregados = jsonList.map((json) => 
        Usuario.fromJson(json as Map<String, dynamic>)
      ).toList();
      
      // Atualiza a lista global
      usuarios.clear();
      usuarios.addAll(usuariosCarregados);
      
      print('Usuários carregados: ${usuariosCarregados.length} usuários');
      return usuariosCarregados;
    } catch (e) {
      print('Erro ao decodificar usuários: $e');
      // Em caso de erro, retorna lista padrão
      await salvarUsuarios(usuarios);
      return usuarios;
    }
  }

  // Autenticar usuário (login)
  static Future<Usuario?> autenticarUsuario(String cpf, String senha) async {
    try {
      List<Usuario> todosUsuarios = await carregarUsuarios();
      
      for (Usuario usuario in todosUsuarios) {
        if (usuario.cpf == cpf && usuario.senha == senha) {
          await salvarUsuarioLogado(usuario.id);
          print('Login realizado com sucesso: ${usuario.nome}');
          return usuario;
        }
      }
      
      print('Credenciais inválidas para CPF: $cpf');
      return null;
    } catch (e) {
      print('Erro na autenticação: $e');
      return null;
    }
  }

  // Verificar se CPF já existe
  static Future<bool> cpfJaExiste(String cpf) async {
    try {
      List<Usuario> todosUsuarios = await carregarUsuarios();
      
      for (Usuario usuario in todosUsuarios) {
        if (usuario.cpf == cpf) {
          return true;
        }
      }
      
      return false;
    } catch (e) {
      print('Erro ao verificar CPF: $e');
      return false;
    }
  }

  // Verificar se email já existe
  static Future<bool> emailJaExiste(String email) async {
    try {
      List<Usuario> todosUsuarios = await carregarUsuarios();
      
      for (Usuario usuario in todosUsuarios) {
        if (usuario.email.toLowerCase() == email.toLowerCase()) {
          return true;
        }
      }
      
      return false;
    } catch (e) {
      print('Erro ao verificar email: $e');
      return false;
    }
  }

  // Adicionar novo usuário
  static Future<bool> adicionarUsuario(Usuario novoUsuario) async {
    try {
      // Verificar se CPF ou email já existem
      if (await cpfJaExiste(novoUsuario.cpf)) {
        print('Erro: CPF já cadastrado');
        return false;
      }
      
      if (await emailJaExiste(novoUsuario.email)) {
        print('Erro: Email já cadastrado');
        return false;
      }

      List<Usuario> todosUsuarios = await carregarUsuarios();
      
      // Gerar ID único
      if (todosUsuarios.isNotEmpty) {
      }
      
      todosUsuarios.add(novoUsuario);
      await salvarUsuarios(todosUsuarios);
      
      print('Usuário adicionado com sucesso: ${novoUsuario.nome}');
      return true;
    } catch (e) {
      print('Erro ao adicionar usuário: $e');
      return false;
    }
  }

  // Buscar usuário por chave PIX
  static Future<Usuario?> buscarUsuarioPorChavePix(String chavePix) async {
    try {
      List<Usuario> todosUsuarios = await carregarUsuarios();
      
      for (Usuario usuario in todosUsuarios) {
        if (usuario.chavePix == chavePix) {
          print('Usuário encontrado por chave PIX: ${usuario.nome}');
          return usuario;
        }
      }
      
      print('Usuário não encontrado para chave PIX: $chavePix');
      return null;
    } catch (e) {
      print('Erro ao buscar usuário por chave PIX: $e');
      return null;
    }
  }

  // Obter saldo de um usuário específico
  static Future<double> obterSaldoUsuario(int usuarioId) async {
    List<Usuario> todosUsuarios = await carregarUsuarios();
    
    for (Usuario usuario in todosUsuarios) {
      if (usuario.id == usuarioId) {
        return usuario.saldo;
      }
    }
    
    // Se não encontrar o usuário, retorna 0.0
    return 0.0;
  }

  // Obter usuário por ID
  static Future<Usuario?> obterUsuarioPorId(int usuarioId) async {
    try {
      List<Usuario> todosUsuarios = await carregarUsuarios();
      
      for (Usuario usuario in todosUsuarios) {
        if (usuario.id == usuarioId) {
          print('Usuário encontrado por ID $usuarioId: ${usuario.nome}');
          return usuario;
        }
      }
      
      print('Usuário com ID $usuarioId não encontrado');
      return null;
    } catch (e) {
      print('Erro ao obter usuário por ID: $e');
      return null;
    }
  }

  // Salvar saldo de um usuário específico
  static Future<void> salvarSaldoUsuario(int usuarioId, double novoSaldo) async {
    List<Usuario> todosUsuarios = await carregarUsuarios();
    
    // Encontrar e atualizar o usuário
    for (Usuario usuario in todosUsuarios) {
      if (usuario.id == usuarioId) {
        usuario.saldo = novoSaldo;
        print('Saldo atualizado para usuário ${usuario.nome}: R\$ $novoSaldo');
        break;
      }
    }
    
    // Salvar a lista atualizada
    await salvarUsuarios(todosUsuarios);
  }

  // Salvar score de um usuário específico
  static Future<void> salvarScoreUsuario(int usuarioId, int novoScore) async {
    List<Usuario> todosUsuarios = await carregarUsuarios();
    
    // Encontrar e atualizar o usuário
    for (Usuario usuario in todosUsuarios) {
      if (usuario.id == usuarioId) {
        usuario.score = novoScore;
        print('Score atualizado para usuário ${usuario.nome}: $novoScore');
        break;
      }
    }
    
    // Salvar a lista atualizada
    await salvarUsuarios(todosUsuarios);
  }

  // Atualizar usuário completo
  static Future<void> atualizarUsuario(Usuario usuarioAtualizado) async {
    List<Usuario> todosUsuarios = await carregarUsuarios();
    
    // Encontrar e substituir o usuário
    for (int i = 0; i < todosUsuarios.length; i++) {
      if (todosUsuarios[i].id == usuarioAtualizado.id) {
        todosUsuarios[i] = usuarioAtualizado;
        print('Usuário atualizado: ${usuarioAtualizado.nome}');
        break;
      }
    }
    
    // Salvar a lista atualizada
    await salvarUsuarios(todosUsuarios);
  }

  // Realizar transferência com persistência
  static Future<bool> realizarTransferencia({
    required Usuario remetente,
    required Usuario destinatario,
    required double valor,
  }) async {
    // Verificações
    if (valor <= 0) {
      print('Erro: Valor inválido para transferência');
      return false;
    }
    if (remetente.saldo < valor) {
      print('Erro: Saldo insuficiente');
      return false;
    }
    if (remetente.id == destinatario.id) {
      print('Erro: Não é possível transferir para si mesmo');
      return false;
    }

    try {
      // Carregar usuários atualizados
      List<Usuario> todosUsuarios = await carregarUsuarios();
      
      // Encontrar usuários na lista carregada
      Usuario? remetenteAtualizado;
      Usuario? destinatarioAtualizado;
      
      for (Usuario usuario in todosUsuarios) {
        if (usuario.id == remetente.id) {
          remetenteAtualizado = usuario;
        }
        if (usuario.id == destinatario.id) {
          destinatarioAtualizado = usuario;
        }
      }
      
      if (remetenteAtualizado == null || destinatarioAtualizado == null) {
        print('Erro: Usuários não encontrados para transferência');
        return false;
      }
      
      // Realizar a transferência
      remetenteAtualizado.saldo -= valor;
      destinatarioAtualizado.saldo += valor;
      remetenteAtualizado.score += 1;
      
      print('Transferência realizada: R\$ $valor de ${remetenteAtualizado.nome} para ${destinatarioAtualizado.nome}');
      
      // Salvar mudanças
      await salvarUsuarios(todosUsuarios);
      
      return true;
    } catch (e) {
      print('Erro na transferência: $e');
      return false;
    }
  }

  // Realizar PIX com persistência
  static Future<bool> realizarPix({
    required Usuario remetente,
    required Usuario destinatario,
    required double valor,
  }) async {
    // Verificações
    if (valor <= 0) {
      print('Erro: Valor inválido para PIX');
      return false;
    }
    if (remetente.saldo < valor) {
      print('Erro: Saldo insuficiente para PIX');
      return false;
    }
    if (remetente.id == destinatario.id) {
      print('Erro: Não é possível fazer PIX para si mesmo');
      return false;
    }

    try {
      // Carregar usuários atualizados
      List<Usuario> todosUsuarios = await carregarUsuarios();
      
      // Encontrar usuários na lista carregada
      Usuario? remetenteAtualizado;
      Usuario? destinatarioAtualizado;
      
      for (Usuario usuario in todosUsuarios) {
        if (usuario.id == remetente.id) {
          remetenteAtualizado = usuario;
        }
        if (usuario.id == destinatario.id) {
          destinatarioAtualizado = usuario;
        }
      }
      
      if (remetenteAtualizado == null || destinatarioAtualizado == null) {
        print('Erro: Usuários não encontrados para PIX');
        return false;
      }
      
      // Realizar o PIX
      remetenteAtualizado.saldo -= valor;
      destinatarioAtualizado.saldo += valor;
      remetenteAtualizado.score += 10;
      
      print('PIX realizado: R\$ $valor de ${remetenteAtualizado.nome} para ${destinatarioAtualizado.nome}');
      
      // Salvar mudanças
      await salvarUsuarios(todosUsuarios);
      
      return true;
    } catch (e) {
      print('Erro no PIX: $e');
      return false;
    }
  }

  // Adicionar saldo ao usuário (simulação de depósito)
  static Future<bool> adicionarSaldo(int usuarioId, double valor) async {
    if (valor <= 0) {
      print('Erro: Valor inválido para depósito');
      return false;
    }

    try {
      List<Usuario> todosUsuarios = await carregarUsuarios();
      
      for (Usuario usuario in todosUsuarios) {
        if (usuario.id == usuarioId) {
          usuario.saldo += valor;
          print('Saldo adicionado: R\$ $valor para ${usuario.nome}');
          break;
        }
      }
      
      await salvarUsuarios(todosUsuarios);
      return true;
    } catch (e) {
      print('Erro ao adicionar saldo: $e');
      return false;
    }
  }

  // Salvar ID do usuário logado
  static Future<void> salvarUsuarioLogado(int usuarioId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_usuarioLogadoKey, usuarioId);
    print('Usuário logado salvo: ID $usuarioId');
  }

  // Carregar ID do usuário logado
  static Future<int?> carregarUsuarioLogado() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      int? usuarioId = prefs.getInt(_usuarioLogadoKey);
      if (usuarioId != null) {
        print('ID do usuário logado carregado: $usuarioId');
      } else {
        print('Nenhum usuário logado encontrado');
      }
      return usuarioId;
    } catch (e) {
      print('Erro ao carregar usuário logado: $e');
      return null;
    }
  }

  // Obter usuário logado completo
  static Future<Usuario?> obterUsuarioLogado() async {
    try {
      int? usuarioId = await carregarUsuarioLogado();
      if (usuarioId == null) {
        print('Nenhum usuário logado');
        return null;
      }
      
      Usuario? usuario = await obterUsuarioPorId(usuarioId);
      if (usuario != null) {
        print('Usuário logado obtido: ${usuario.nome}');
      } else {
        print('Usuário logado não encontrado na lista');
      }
      
      return usuario;
    } catch (e) {
      print('Erro ao obter usuário logado: $e');
      return null;
    }
  }

  // Limpar dados do usuário logado (logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usuarioLogadoKey);
    print('Logout realizado');
  }

  // Inicializar dados (chamar no início do app)
  static Future<void> inicializar() async {
    print('Inicializando UsuarioService...');
    await carregarUsuarios();
    print('UsuarioService inicializado');
  }

  // ===== MÉTODOS DE DEBUG =====

  // Método para debug - verificar estado do usuário logado
  static Future<void> debugUsuarioLogado() async {
    print('=== DEBUG USUÁRIO LOGADO ===');
    
    try {
      // Verificar se há ID salvo
      int? usuarioId = await carregarUsuarioLogado();
      print('ID do usuário logado: $usuarioId');
      
      if (usuarioId == null) {
        print('PROBLEMA: Nenhum usuário logado salvo');
        return;
      }
      
      // Verificar se o usuário existe na lista
      List<Usuario> usuarios = await carregarUsuarios();
      print('Total de usuários na lista: ${usuarios.length}');
      
      // Mostrar todos os IDs disponíveis
      print('IDs disponíveis:');
      for (Usuario u in usuarios) {
        print('  - ID: ${u.id}, Nome: ${u.nome}');
      }
      
      // Tentar encontrar o usuário
      Usuario? usuarioEncontrado = await obterUsuarioPorId(usuarioId);
      if (usuarioEncontrado != null) {
        print('✅ Usuário encontrado: ${usuarioEncontrado.nome}');
        print('   Saldo: R\$ ${usuarioEncontrado.saldo}');
        print('   Email: ${usuarioEncontrado.email}');
      } else {
        print('❌ PROBLEMA: Usuário com ID $usuarioId não encontrado');
      }
      
    } catch (e) {
      print('❌ ERRO no debug: $e');
    }
    
    print('=== FIM DEBUG ===');
  }

  // Método para forçar login (temporário para testes)
  static Future<bool> forcarLogin(String cpf, String senha) async {
    try {
      print('Tentando login forçado com CPF: $cpf');
      List<Usuario> usuarios = await carregarUsuarios();
      
      Usuario? usuario;
      for (Usuario u in usuarios) {
        if (u.cpf == cpf && u.senha == senha) {
          usuario = u;
          break;
        }
      }
      
      if (usuario == null) {
        print('❌ Usuário não encontrado para login forçado');
        return false;
      }
      
      await salvarUsuarioLogado(usuario.id);
      print('✅ Login forçado realizado para: ${usuario.nome}');
      return true;
    } catch (e) {
      print('❌ Erro ao forçar login: $e');
      return false;
    }
  }

  // Método para limpar todos os dados (reset completo)
  static Future<void> resetarDados() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_usuariosKey);
      await prefs.remove(_usuarioLogadoKey);
      
      // Recarregar lista padrão
      await carregarUsuarios();
      
      print('✅ Dados resetados com sucesso');
    } catch (e) {
      print('❌ Erro ao resetar dados: $e');
    }
  }

  // Método para verificar integridade dos dados
  static Future<void> verificarIntegridade() async {
    print('=== VERIFICAÇÃO DE INTEGRIDADE ===');
    
    try {
      // Verificar SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      String? usuariosJson = prefs.getString(_usuariosKey);
      int? usuarioLogadoId = prefs.getInt(_usuarioLogadoKey);
      
      print('SharedPreferences:');
      print('  - Usuários salvos: ${usuariosJson != null ? 'SIM' : 'NÃO'}');
      print('  - Usuário logado: ${usuarioLogadoId ?? 'NENHUM'}');
      
      // Verificar lista de usuários
      List<Usuario> usuarios = await carregarUsuarios();
      print('Lista de usuários:');
      print('  - Total: ${usuarios.length}');
      for (Usuario u in usuarios) {
        print('  - ${u.id}: ${u.nome} (CPF: ${u.cpf}, Saldo: R\$ ${u.saldo})');
      }
      
      // Verificar consistência do usuário logado
      if (usuarioLogadoId != null) {
        Usuario? usuarioLogado = await obterUsuarioPorId(usuarioLogadoId);
        if (usuarioLogado != null) {
          print('✅ Usuário logado válido: ${usuarioLogado.nome}');
        } else {
          print('❌ PROBLEMA: ID do usuário logado não existe na lista');
        }
      }
      
      // Verificar duplicatas de CPF
      Set<String> cpfs = {};
      List<String> cpfsDuplicados = [];
      for (Usuario u in usuarios) {
        if (cpfs.contains(u.cpf)) {
          cpfsDuplicados.add(u.cpf);
        }
        cpfs.add(u.cpf);
      }
      
      if (cpfsDuplicados.isNotEmpty) {
        print('❌ PROBLEMA: CPFs duplicados encontrados: $cpfsDuplicados');
      } else {
        print('✅ Todos os CPFs são únicos');
      }
      
      // Verificar duplicatas de email
      Set<String> emails = {};
      List<String> emailsDuplicados = [];
      for (Usuario u in usuarios) {
        String emailLower = u.email.toLowerCase();
        if (emails.contains(emailLower)) {
          emailsDuplicados.add(u.email);
        }
        emails.add(emailLower);
      }
      
      if (emailsDuplicados.isNotEmpty) {
        print('❌ PROBLEMA: Emails duplicados encontrados: $emailsDuplicados');
      } else {
        print('✅ Todos os emails são únicos');
      }
      
      print('✅ Verificação de integridade concluída');
      
    } catch (e) {
      print('❌ ERRO na verificação de integridade: $e');
    }
    
    print('=== FIM VERIFICAÇÃO ===');
  }

  // Obter estatísticas dos usuários
  static Future<Map<String, dynamic>> obterEstatisticas() async {
    try {
      List<Usuario> usuarios = await carregarUsuarios();
      
      if (usuarios.isEmpty) {
        return {
          'totalUsuarios': 0,
          'saldoTotal': 0.0,
          'scoreTotal': 0,
          'maiorSaldo': 0.0,
          'menorSaldo': 0.0,
          'maiorScore': 0,
          'usuarioMaiorSaldo': null,
          'usuarioMaiorScore': null,
        };
      }
      
      double saldoTotal = usuarios.fold(0.0, (sum, u) => sum + u.saldo);
      int scoreTotal = usuarios.fold(0, (sum, u) => sum + u.score);
      
      Usuario usuarioMaiorSaldo = usuarios.reduce((a, b) => a.saldo > b.saldo ? a : b);
      Usuario usuarioMenorSaldo = usuarios.reduce((a, b) => a.saldo < b.saldo ? a : b);
      Usuario usuarioMaiorScore = usuarios.reduce((a, b) => a.score > b.score ? a : b);
      
      return {
        'totalUsuarios': usuarios.length,
        'saldoTotal': saldoTotal,
        'scoreTotal': scoreTotal,
        'saldoMedio': saldoTotal / usuarios.length,
        'scoreMedio': scoreTotal / usuarios.length,
        'maiorSaldo': usuarioMaiorSaldo.saldo,
        'menorSaldo': usuarioMenorSaldo.saldo,
        'maiorScore': usuarioMaiorScore.score,
        'usuarioMaiorSaldo': usuarioMaiorSaldo.nome,
        'usuarioMenorSaldo': usuarioMenorSaldo.nome,
        'usuarioMaiorScore': usuarioMaiorScore.nome,
      };
    } catch (e) {
      print('Erro ao obter estatísticas: $e');
      return {};
    }
  }

  // Método para listar todos os usuários (útil para debug)
  static Future<void> listarTodosUsuarios() async {
    try {
      List<Usuario> usuarios = await carregarUsuarios();
      print('=== LISTA COMPLETA DE USUÁRIOS ===');
      print('Total: ${usuarios.length} usuários');
      
      for (int i = 0; i < usuarios.length; i++) {
        Usuario u = usuarios[i];
        print('${i + 1}. ${u.nome}');
        print('   ID: ${u.id}');
        print('   CPF: ${u.cpf}');
        print('   Email: ${u.email}');
        print('   Saldo: R\$ ${u.saldo.toStringAsFixed(2)}');
        print('   Score: ${u.score}');
        print('   Chave PIX: ${u.chavePix}');
        print('   ---');
      }
      
      print('=== FIM DA LISTA ===');
    } catch (e) {
      print('Erro ao listar usuários: $e');
    }
  }

  static final UsuarioService _instance = UsuarioService._internal();
  factory UsuarioService() => _instance;
  UsuarioService._internal();

  Usuario? _usuarioAtual;

  // Getter para o usuário atual
  Usuario? get usuarioAtual => _usuarioAtual;

  // Método para fazer login
  void fazerLogin(Usuario usuario) {
    _usuarioAtual = usuario;
  }

  // Método para fazer logout
  void fazerLogout() {
    _usuarioAtual = null;
  }

  // Método para verificar se há um usuário logado
  bool get isLogado => _usuarioAtual != null;

  // Método para salvar alterações nos dados pessoais
  void salvarDadosPessoais(String novoNome, String novaData) {
    if (_usuarioAtual != null) {
      _usuarioAtual!.nome = novoNome;
      _usuarioAtual!.dataNascimento = novaData;
    }
  }

  // Método para buscar usuário por ID na lista global
  Usuario? buscarUsuarioPorId(int id) {
    try {
      return usuarios.firstWhere((u) => u.id == id);
    } catch (e) {
      return null;
    }
  }

  // Método para sincronizar com a lista global de usuários
  void sincronizarComListaGlobal() {
    if (_usuarioAtual != null) {
      int index = usuarios.indexWhere((u) => u.id == _usuarioAtual!.id);
      if (index != -1) {
        usuarios[index] = _usuarioAtual!;
      }
    }
  }

  static isSessionValid() {}
}