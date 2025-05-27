import 'package:flutter_application_1/Usuario.dart';

class Sessao {
  static Usuario? usuarioAtual;

  static void salvarUsuario(Usuario usuario) {
    usuarioAtual = usuario;
  }

  static void limparUsuario() {
    usuarioAtual = null;
  }

  static Usuario? getUsuario() {
    return usuarioAtual;
  }
}