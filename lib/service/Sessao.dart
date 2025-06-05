
import 'package:flutter_application_1/service/Usuario.dart';

class Sessao {
  static Usuario? usuarioAtual;

  static void salvarUsuario(Usuario usuario) {
    usuarioAtual = usuario;
    print("Usuário salvo na sessão: ${usuario.nome}");
  }

  static void limparUsuario() {
    usuarioAtual = null;
    print("Usuário limpo da sessão");
  }
  
  static void atualizarUsuario(Usuario usuario) {
    if (usuarioAtual != null) {
      usuarioAtual = usuario;
    }
  }

  static void logout() {
    usuarioAtual = null;
  }

  static bool isUsuarioLogado() {
    return usuarioAtual != null;
  }

  static Usuario? getUsuario() {
    if (usuarioAtual == null) {
      return Usuario('Usuário', 'CPF não encontrado', '', '', '', '', '');
    }
    return usuarioAtual;
  }
}