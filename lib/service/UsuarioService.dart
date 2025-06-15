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
  }

  // Carregar todos os usuários do SharedPreferences
  static Future<List<Usuario>> carregarUsuarios() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_usuariosKey);
    
    if (jsonString == null) {
      // Se não há dados salvos, retorna a lista padrão e salva
      await salvarUsuarios(usuarios);
      return usuarios;
    }
    
    List<dynamic> jsonList = jsonDecode(jsonString);
    List<Usuario> usuariosCarregados = jsonList.map((json) => 
      Usuario.fromJson(json)
    ).toList();
    
    // Atualiza a lista global
    usuarios.clear();
    usuarios.addAll(usuariosCarregados);
    
    return usuariosCarregados;
  }

  // Salvar saldo de um usuário específico
  static Future<void> salvarSaldoUsuario(int usuarioId, double novoSaldo) async {
    List<Usuario> todosUsuarios = await carregarUsuarios();
    
    // Encontrar e atualizar o usuário
    for (Usuario usuario in todosUsuarios) {
      if (usuario.id == usuarioId) {
        usuario.saldo = novoSaldo;
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
    if (valor <= 0) return false;
    if (remetente.saldo < valor) return false;
    if (remetente.id == destinatario.id) return false;

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
        return false;
      }
      
      // Realizar a transferência
      remetenteAtualizado.saldo -= valor;
      destinatarioAtualizado.saldo += valor;
      remetenteAtualizado.score += 1;
      
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
    if (valor <= 0) return false;
    if (remetente.saldo < valor) return false;
    if (remetente.id == destinatario.id) return false;

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
        return false;
      }
      
      // Realizar o PIX
      remetenteAtualizado.saldo -= valor;
      destinatarioAtualizado.saldo += valor;
      remetenteAtualizado.score += 10;
      
      // Salvar mudanças
      await salvarUsuarios(todosUsuarios);
      
      return true;
    } catch (e) {
      print('Erro no PIX: $e');
      return false;
    }
  }

  // Salvar ID do usuário logado
  static Future<void> salvarUsuarioLogado(int usuarioId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_usuarioLogadoKey, usuarioId);
  }

  // Carregar ID do usuário logado
  static Future<int?> carregarUsuarioLogado() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_usuarioLogadoKey);
  }

  // Limpar dados do usuário logado (logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usuarioLogadoKey);
  }

  // Inicializar dados (chamar no início do app)
  static Future<void> inicializar() async {
    await carregarUsuarios();
  }
}