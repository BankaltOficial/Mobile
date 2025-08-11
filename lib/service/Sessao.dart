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
      // Atualizar a instância em memória
      usuarioAtual = usuario;
      
      // Persistir no SharedPreferences através do UsuarioService
      await UsuarioService.atualizarUsuario(usuario);
      
      print("Usuário atualizado na sessão e persistido: ${usuario.nome}");
      print("Dados atualizados - Nome: ${usuario.nome}, Data: ${usuario.dataNascimento}");
    } else {
      print("Erro: Tentativa de atualizar usuário diferente do atual");
    }
  }

  // Método específico para atualizar dados pessoais
  static Future<bool> atualizarDadosPessoais(String novoNome, String novaDataNascimento) async {
    if (usuarioAtual == null) {
      print("Erro: Nenhum usuário logado para atualizar");
      return false;
    }

    try {
      // Validações
      if (novoNome.trim().isEmpty) {
        print("Erro: Nome não pode estar vazio");
        return false;
      }

      if (novaDataNascimento.isEmpty) {
        print("Erro: Data de nascimento não pode estar vazia");
        return false;
      }

      // Atualizar os dados do usuário atual
      usuarioAtual!.nome = novoNome.trim();
      usuarioAtual!.dataNascimento = novaDataNascimento;

      // Persistir as alterações
      await UsuarioService.atualizarUsuario(usuarioAtual!);

      print("Dados pessoais atualizados com sucesso:");
      print("  - Nome: ${usuarioAtual!.nome}");
      print("  - Data de nascimento: ${usuarioAtual!.dataNascimento}");

      return true;
    } catch (e) {
      print("Erro ao atualizar dados pessoais: $e");
      return false;
    }
  }

  // Recarregar dados do usuário atual do SharedPreferences
  static Future<void> recarregarUsuario() async {
    if (usuarioAtual != null) {
      try {
        Usuario? usuarioAtualizado = await UsuarioService.obterUsuarioPorId(usuarioAtual!.id);
        if (usuarioAtualizado != null) {
          usuarioAtual = usuarioAtualizado;
          print("Usuário recarregado: ${usuarioAtualizado.nome}");
          print("Dados recarregados - Nome: ${usuarioAtualizado.nome}, Data: ${usuarioAtualizado.dataNascimento}, Saldo: R\$ ${usuarioAtualizado.saldo}");
        } else {
          print("Erro: Usuário não encontrado ao recarregar");
        }
      } catch (e) {
        print("Erro ao recarregar usuário: $e");
      }
    } else {
      print("Erro: Nenhum usuário para recarregar");
    }
  }

  // Sincronizar dados do usuário com o SharedPreferences
  static Future<void> sincronizarDados() async {
    if (usuarioAtual != null) {
      try {
        // Buscar os dados mais recentes do SharedPreferences
        Usuario? usuarioMaisRecente = await UsuarioService.obterUsuarioPorId(usuarioAtual!.id);
        
        if (usuarioMaisRecente != null) {
          // Comparar e atualizar se necessário
          bool precisaAtualizar = false;
          
          if (usuarioAtual!.nome != usuarioMaisRecente.nome) {
            print("Nome diferente detectado. Atual: ${usuarioAtual!.nome}, Persistido: ${usuarioMaisRecente.nome}");
            precisaAtualizar = true;
          }
          
          if (usuarioAtual!.dataNascimento != usuarioMaisRecente.dataNascimento) {
            print("Data diferente detectada. Atual: ${usuarioAtual!.dataNascimento}, Persistido: ${usuarioMaisRecente.dataNascimento}");
            precisaAtualizar = true;
          }
          
          if (precisaAtualizar) {
            usuarioAtual = usuarioMaisRecente;
            print("Sessão sincronizada com dados persistidos");
          }
        }
      } catch (e) {
        print("Erro ao sincronizar dados: $e");
      }
    }
  }

  // Logout - limpar sessão e SharedPreferences
  static Future<void> logout() async {
    if (usuarioAtual != null) {
      print("Fazendo logout do usuário: ${usuarioAtual!.nome}");
    }
    usuarioAtual = null;
    await UsuarioService.logout();
    print("Usuário deslogado");
  }

  // Limpar apenas a sessão (sem afetar SharedPreferences)
  static void limparUsuario() {
    if (usuarioAtual != null) {
      print("Limpando usuário da sessão: ${usuarioAtual!.nome}");
    }
    usuarioAtual = null;
    print("Usuário limpo da sessão");
  }

  // Verificar se há usuário logado
  static bool isUsuarioLogado() {
    bool logado = usuarioAtual != null;
    if (logado) {
      print("Usuário logado: ${usuarioAtual!.nome}");
    } else {
      print("Nenhum usuário logado na sessão");
    }
    return logado;
  }

  // Obter usuário atual
  static Usuario? getUsuario() {
    return usuarioAtual;
  }

  // Obter usuário atual com fallback
  static Usuario getUsuarioOuDefault() {
    if (usuarioAtual == null) {
      print("Retornando usuário padrão pois não há usuário logado");
      return Usuario('Usuário', 'CPF não encontrado', '', '', '', '', '');
    }
    return usuarioAtual!;
  }

  // Inicializar a sessão (chamar no início do app)
  static Future<void> inicializar() async {
    print("Inicializando sessão...");
    await carregarUsuarioLogado();
    if (usuarioAtual != null) {
      print("Sessão inicializada com usuário: ${usuarioAtual!.nome}");
    } else {
      print("Sessão inicializada sem usuário logado");
    }
  }

  // Método para realizar login
  static Future<bool> realizarLogin(String cpf, String senha) async {
    try {
      Usuario? usuario = await UsuarioService.autenticarUsuario(cpf, senha);
      if (usuario != null) {
        await salvarUsuario(usuario);
        print("Login realizado com sucesso para: ${usuario.nome}");
        return true;
      } else {
        print("Falha no login - credenciais inválidas");
      }
      return false;
    } catch (e) {
      print("Erro no login: $e");
      return false;
    }
  }

  // Validar se a sessão ainda é válida
  static Future<bool> validarSessao() async {
    if (usuarioAtual == null) {
      print("Sessão inválida: Nenhum usuário em memória");
      return false;
    }

    try {
      // Verificar se o usuário ainda existe no SharedPreferences
      Usuario? usuarioValidado = await UsuarioService.obterUsuarioPorId(usuarioAtual!.id);
      if (usuarioValidado == null) {
        print("Sessão inválida: Usuário não encontrado no SharedPreferences");
        limparUsuario();
        return false;
      }

      // Verificar se o ID salvo no SharedPreferences corresponde ao usuário atual
      int? usuarioIdSalvo = await UsuarioService.carregarUsuarioLogado();
      if (usuarioIdSalvo != usuarioAtual!.id) {
        print("Sessão inválida: ID do usuário logado não corresponde");
        limparUsuario();
        return false;
      }

      print("Sessão válida para usuário: ${usuarioAtual!.nome}");
      return true;
    } catch (e) {
      print("Erro ao validar sessão: $e");
      limparUsuario();
      return false;
    }
  }

  // Debug - verificar estado da sessão
  static Future<void> debugSessao() async {
    print("=== DEBUG SESSÃO ===");
    print("Usuário em memória: ${usuarioAtual?.nome ?? 'NENHUM'}");
    
    if (usuarioAtual != null) {
      print("Dados do usuário atual na sessão:");
      print("  - ID: ${usuarioAtual!.id}");
      print("  - Nome: ${usuarioAtual!.nome}");
      print("  - CPF: ${usuarioAtual!.cpf}");
      print("  - Data de nascimento: ${usuarioAtual!.dataNascimento}");
      print("  - Email: ${usuarioAtual!.email}");
      print("  - Saldo: R\$ ${usuarioAtual!.saldo}");
      print("  - Score: ${usuarioAtual!.score}");
    }
    
    try {
      int? usuarioIdSalvo = await UsuarioService.carregarUsuarioLogado();
      print("ID salvo no SharedPreferences: ${usuarioIdSalvo ?? 'NENHUM'}");
      
      if (usuarioIdSalvo != null) {
        Usuario? usuarioPersistido = await UsuarioService.obterUsuarioPorId(usuarioIdSalvo);
        if (usuarioPersistido != null) {
          print("Dados do usuário persistido:");
          print("  - ID: ${usuarioPersistido.id}");
          print("  - Nome: ${usuarioPersistido.nome}");
          print("  - Data de nascimento: ${usuarioPersistido.dataNascimento}");
          print("  - Saldo: R\$ ${usuarioPersistido.saldo}");
          
          // Comparar dados
          if (usuarioAtual != null) {
            bool dadosIguais = usuarioAtual!.nome == usuarioPersistido.nome &&
                              usuarioAtual!.dataNascimento == usuarioPersistido.dataNascimento &&
                              usuarioAtual!.saldo == usuarioPersistido.saldo;
            
            if (dadosIguais) {
              print("✅ Dados da sessão estão sincronizados com o SharedPreferences");
            } else {
              print("⚠️  ATENÇÃO: Dados da sessão diferem do SharedPreferences");
              print("   Sessão - Nome: ${usuarioAtual!.nome}, Data: ${usuarioAtual!.dataNascimento}");
              print("   Persistido - Nome: ${usuarioPersistido.nome}, Data: ${usuarioPersistido.dataNascimento}");
            }
          }
        } else {
          print("❌ PROBLEMA: Usuário com ID $usuarioIdSalvo não encontrado no SharedPreferences");
        }
      }
    } catch (e) {
      print("❌ ERRO ao buscar dados persistidos: $e");
    }
    
    print("=== FIM DEBUG ===");
  }

  // Método para forçar sincronização completa
  static Future<void> forcarSincronizacao() async {
    print("Forçando sincronização completa...");
    
    if (usuarioAtual == null) {
      print("Nenhum usuário para sincronizar");
      return;
    }

    try {
      // Salvar o usuário atual no SharedPreferences
      await UsuarioService.atualizarUsuario(usuarioAtual!);
      
      // Recarregar da fonte de dados para confirmar
      await recarregarUsuario();
      
      print("Sincronização forçada concluída");
    } catch (e) {
      print("Erro na sincronização forçada: $e");
    }
  }

  // Método utilitário para obter dados específicos
  static Map<String, dynamic> obterDadosPessoais() {
    if (usuarioAtual == null) {
      return {
        'nome': '',
        'dataNascimento': '',
        'email': '',
        'cpf': '',
      };
    }

    return {
      'nome': usuarioAtual!.nome,
      'dataNascimento': usuarioAtual!.dataNascimento,
      'email': usuarioAtual!.email,
      'cpf': usuarioAtual!.cpf,
    };
  }

  // Método para verificar se há alterações pendentes
  static Future<bool> temAlteracoesPendentes() async {
    if (usuarioAtual == null) return false;

    try {
      Usuario? usuarioPersistido = await UsuarioService.obterUsuarioPorId(usuarioAtual!.id);
      if (usuarioPersistido == null) return false;

      return usuarioAtual!.nome != usuarioPersistido.nome ||
             usuarioAtual!.dataNascimento != usuarioPersistido.dataNascimento;
    } catch (e) {
      print("Erro ao verificar alterações pendentes: $e");
      return false;
    }
  }
}