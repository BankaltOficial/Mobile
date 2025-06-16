import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/UsuarioService.dart';

class Sessao {
  static Usuario? usuarioAtual;

  // Salvar usuário na sessão e marcar como logado no SharedPreferences
  static Future<void> salvarUsuario(Usuario usuario) async {
    usuarioAtual = usuario;
    await UsuarioService.salvarUsuarioLogado(usuario.id);
    print("Usuário salvo na sessão: ${usuario.nome}");
  }

  // Carregar usuário da sessão baseado no SharedPreferences
  static Future<void> carregarUsuarioLogado() async {
    try {
      int? usuarioId = await UsuarioService.carregarUsuarioLogado();
      if (usuarioId != null) {
        Usuario? usuario = await UsuarioService.obterUsuarioPorId(usuarioId);
        if (usuario != null) {
          usuarioAtual = usuario;
          print("Usuário carregado na sessão: ${usuario.nome}");
        } else {
          print("Usuário com ID $usuarioId não encontrado");
          usuarioAtual = null;
        }
      } else {
        print("Nenhum usuário logado encontrado");
        usuarioAtual = null;
      }
    } catch (e) {
      print("Erro ao carregar usuário logado: $e");
      usuarioAtual = null;
    }
  }

  // Atualizar usuário na sessão e persistir no SharedPreferences
  static Future<void> atualizarUsuario(Usuario usuario) async {
    if (usuarioAtual != null && usuarioAtual!.id == usuario.id) {
      usuarioAtual = usuario;
      await UsuarioService.atualizarUsuario(usuario);
      print("Usuário atualizado na sessão: ${usuario.nome}");
    }
  }

  // Recarregar dados do usuário atual do SharedPreferences
  static Future<void> recarregarUsuario() async {
    if (usuarioAtual != null) {
      try {
        Usuario? usuarioAtualizado = await UsuarioService.obterUsuarioPorId(usuarioAtual!.id);
        if (usuarioAtualizado != null) {
          usuarioAtual = usuarioAtualizado;
          print("Usuário recarregado: ${usuarioAtualizado.nome}, Saldo: R\$ ${usuarioAtualizado.saldo}");
        }
      } catch (e) {
        print("Erro ao recarregar usuário: $e");
      }
    }
  }

  // Logout - limpar sessão e SharedPreferences
  static Future<void> logout() async {
    usuarioAtual = null;
    await UsuarioService.logout();
    print("Usuário deslogado");
  }

  // Limpar apenas a sessão (sem afetar SharedPreferences)
  static void limparUsuario() {
    usuarioAtual = null;
    print("Usuário limpo da sessão");
  }

  // Verificar se há usuário logado
  static bool isUsuarioLogado() {
    return usuarioAtual != null;
  }

  // Obter usuário atual
  static Usuario? getUsuario() {
    return usuarioAtual;
  }

  // Obter usuário atual com fallback
  static Usuario getUsuarioOuDefault() {
    if (usuarioAtual == null) {
      return Usuario('Usuário', 'CPF não encontrado', '', '', '', '', '');
    }
    return usuarioAtual!;
  }

  // Inicializar a sessão (chamar no início do app)
  static Future<void> inicializar() async {
    print("Inicializando sessão...");
    await carregarUsuarioLogado();
    print("Sessão inicializada");
  }

  // Método para realizar login
  static Future<bool> realizarLogin(String cpf, String senha) async {
    try {
      Usuario? usuario = await UsuarioService.autenticarUsuario(cpf, senha);
      if (usuario != null) {
        await salvarUsuario(usuario);
        return true;
      }
      return false;
    } catch (e) {
      print("Erro no login: $e");
      return false;
    }
  }

  // Debug - verificar estado da sessão
  static Future<void> debugSessao() async {
    print("=== DEBUG SESSÃO ===");
    print("Usuário em memória: ${usuarioAtual?.nome ?? 'NENHUM'}");
    
    int? usuarioIdSalvo = await UsuarioService.carregarUsuarioLogado();
    print("ID salvo no SharedPreferences: ${usuarioIdSalvo ?? 'NENHUM'}");
    
    if (usuarioAtual != null) {
      print("Dados do usuário atual:");
      print("  - ID: ${usuarioAtual!.id}");
      print("  - Nome: ${usuarioAtual!.nome}");
      print("  - CPF: ${usuarioAtual!.cpf}");
      print("  - Saldo: R\$ ${usuarioAtual!.saldo}");
      print("  - Score: ${usuarioAtual!.score}");
    }
    
    print("=== FIM DEBUG ===");
  }
}