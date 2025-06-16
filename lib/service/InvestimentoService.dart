import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'Investimento.dart';
import 'Usuario.dart';
import 'UsuarioService.dart';

class InvestimentoService {
  static const String _investimentosKey = 'investimentos_lista';

  // Salvar todos os investimentos no SharedPreferences
  static Future<void> salvarInvestimentos(List<Investimento> investimentos) async {
    final prefs = await SharedPreferences.getInstance();
    
    List<Map<String, dynamic>> investimentosJson = investimentos
        .map((investimento) => investimento.toJson())
        .toList();
    
    String jsonString = jsonEncode(investimentosJson);
    await prefs.setString(_investimentosKey, jsonString);
  }

  // Carregar todos os investimentos do SharedPreferences
  static Future<List<Investimento>> carregarInvestimentos() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString(_investimentosKey);
    
    if (jsonString == null) {
      return [];
    }
    
    List<dynamic> jsonList = jsonDecode(jsonString);
    List<Investimento> investimentosCarregados = jsonList
        .map((json) => Investimento.fromJson(json))
        .toList();
    
    return investimentosCarregados;
  }

  // Realizar investimento
  static Future<bool> realizarInvestimento({
    required Usuario usuario,
    required String nomeAtivo,
    required String tipoAtivo,
    required double valor,
    required String resgateDisponivel,
  }) async {
    // Verificações
    if (valor <= 0) return false;
    if (usuario.saldo < valor) return false;

    try {
      // Carregar investimentos existentes
      List<Investimento> investimentos = await carregarInvestimentos();
      
      // Criar novo investimento (ID será gerado automaticamente)
      Investimento novoInvestimento = Investimento(
        nomeAtivo: nomeAtivo,
        tipoAtivo: tipoAtivo,
        valorInvestido: valor,
        dataInvestimento: DateTime.now(),
        resgateDisponivel: resgateDisponivel,
        usuarioId: usuario.id,
      );
      
      // Adicionar à lista
      investimentos.add(novoInvestimento);
      
      // Salvar investimentos
      await salvarInvestimentos(investimentos);
      
      // Debitar do saldo do usuário
      await UsuarioService.salvarSaldoUsuario(usuario.id, usuario.saldo - valor);
      
      return true;
    } catch (e) {
      print('Erro no investimento: $e');
      return false;
    }
  }

  // Realizar resgate
  static Future<bool> realizarResgate({
    required Usuario usuario,
    required Investimento investimento,
    required double valorResgate,
  }) async {
    // Verificações
    if (valorResgate <= 0) return false;
    if (valorResgate > investimento.valorInvestido) return false;
    if (!investimento.podeResgatar()) return false;

    try {
      // Carregar investimentos existentes
      List<Investimento> investimentos = await carregarInvestimentos();
      
      // Encontrar o investimento
      int index = investimentos.indexWhere((inv) => inv.id == investimento.id);
      if (index == -1) return false;
      
      // Se for resgate total, remover o investimento
      if (valorResgate >= investimento.valorInvestido) {
        investimentos.removeAt(index);
      } else {
        // Se for resgate parcial, atualizar o valor
        Investimento investimentoAtualizado = Investimento(
          id: investimento.id, // Manter o mesmo ID
          nomeAtivo: investimento.nomeAtivo,
          tipoAtivo: investimento.tipoAtivo,
          valorInvestido: investimento.valorInvestido - valorResgate,
          dataInvestimento: investimento.dataInvestimento,
          resgateDisponivel: investimento.resgateDisponivel,
          usuarioId: investimento.usuarioId,
        );
        investimentos[index] = investimentoAtualizado;
      }
      
      // Salvar investimentos
      await salvarInvestimentos(investimentos);
      
      // Creditar no saldo do usuário
      await UsuarioService.salvarSaldoUsuario(usuario.id, usuario.saldo + valorResgate);
      
      return true;
    } catch (e) {
      print('Erro no resgate: $e');
      return false;
    }
  }

  // Obter investimentos por usuário
  static Future<List<Investimento>> obterInvestimentosPorUsuario(int usuarioId) async {
    List<Investimento> todosInvestimentos = await carregarInvestimentos();
    return todosInvestimentos.where((inv) => inv.usuarioId == usuarioId).toList();
  }

  // Calcular total investido por usuário - CORRIGIDO
  static Future<double> calcularTotalInvestido(int usuarioId) async {
    List<Investimento> investimentosUsuario = await obterInvestimentosPorUsuario(usuarioId);
    // Garante que inv.valorInvestido é double
    return investimentosUsuario.fold<double>(0.0, (total, inv) => total + (inv.valorInvestido ?? 0.0));
  }

  // Agrupar investimentos por ativo
  static Future<Map<String, List<Investimento>>> agruparInvestimentosPorAtivo(int usuarioId) async {
    List<Investimento> investimentosUsuario = await obterInvestimentosPorUsuario(usuarioId);
    Map<String, List<Investimento>> agrupados = {};
    
    for (var investimento in investimentosUsuario) {
      if (!agrupados.containsKey(investimento.nomeAtivo)) {
        agrupados[investimento.nomeAtivo] = [];
      }
      agrupados[investimento.nomeAtivo]!.add(investimento);
    }
    
    return agrupados;
  }
}