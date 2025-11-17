import 'dart:convert';
import 'package:flutter_application_1/service/TransferenciaExtrato.dart';
import 'package:http/http.dart' as http;

class ExtratoService {
  // URLs das APIs
  static const String baseUrlExtrato = 'http://localhost:8080/apiExtrato';
  static const String baseUrlTransacao = 'http://localhost:8080/apiTransacao';
  // Para emulador Android: 'http://10.0.2.2:8080/...'

  /// Busca transações com fallback entre APIs
  /// Tenta primeiro a API de Extrato (antiga), depois a API de Transação (nova)
  static Future<List<TransacaoExtrato>> buscarTransacoes(int clienteId) async {
    try {
      print('Buscando transações para cliente: $clienteId');

      // TENTATIVA 1: Buscar da API de Extrato (se existir)
      try {
        final urlExtrato = Uri.parse('$baseUrlExtrato/cliente/$clienteId');
        final responseExtrato = await http.get(
          urlExtrato,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ).timeout(Duration(seconds: 5));

        print('API Extrato - Status: ${responseExtrato.statusCode}');

        if (responseExtrato.statusCode == 200) {
          List<dynamic> lista = jsonDecode(responseExtrato.body);
          
          List<TransacaoExtrato> transacoes = lista
              .map((json) => TransacaoExtrato.fromJson(json, clienteId))
              .toList();

          transacoes.sort((a, b) => b.data.compareTo(a.data));
          _calcularSaldos(transacoes);

          print('✅ Transações carregadas da API Extrato: ${transacoes.length}');
          return transacoes;
        }
      } catch (eExtrato) {
        print('⚠️ API Extrato não disponível: $eExtrato');
        // Continua para tentar a API de Transação
      }

      // TENTATIVA 2: Buscar da API de Transação (nova)
      try {
        final urlTransacao = Uri.parse('$baseUrlTransacao/historico/$clienteId');
        final responseTransacao = await http.get(
          urlTransacao,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ).timeout(Duration(seconds: 5));

        print('API Transação - Status: ${responseTransacao.statusCode}');

        if (responseTransacao.statusCode == 200) {
          List<dynamic> lista = jsonDecode(responseTransacao.body);
          
          List<TransacaoExtrato> transacoes = lista
              .map((json) => TransacaoExtrato.fromJson(json, clienteId))
              .toList();

          transacoes.sort((a, b) => b.data.compareTo(a.data));
          _calcularSaldos(transacoes);

          print('✅ Transações carregadas da API Transação: ${transacoes.length}');
          return transacoes;
        } else if (responseTransacao.statusCode == 404) {
          print('ℹ️ Nenhuma transação encontrada');
          return [];
        }
      } catch (eTransacao) {
        print('⚠️ API Transação não disponível: $eTransacao');
      }

      // Se ambas falharam
      print('❌ Nenhuma API disponível');
      return [];

    } catch (e) {
      print('❌ Erro geral ao buscar transações: $e');
      return [];
    }
  }

  /// Busca transações por tipo específico
  static Future<List<TransacaoExtrato>> buscarTransacoesPorTipo(
      int clienteId, String tipo) async {
    try {
      // TENTATIVA 1: API de Extrato
      try {
        final urlExtrato = Uri.parse('$baseUrlExtrato/cliente/$clienteId/tipo/$tipo');
        final responseExtrato = await http.get(
          urlExtrato,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ).timeout(Duration(seconds: 5));

        if (responseExtrato.statusCode == 200) {
          List<dynamic> lista = jsonDecode(responseExtrato.body);
          
          List<TransacaoExtrato> transacoes = lista
              .map((json) => TransacaoExtrato.fromJson(json, clienteId))
              .toList();

          transacoes.sort((a, b) => b.data.compareTo(a.data));
          _calcularSaldos(transacoes);

          return transacoes;
        }
      } catch (e) {
        print('API Extrato não disponível para busca por tipo: $e');
      }

      // TENTATIVA 2: Buscar todas da API de Transação e filtrar localmente
      List<TransacaoExtrato> todasTransacoes = await buscarTransacoes(clienteId);
      
      return todasTransacoes.where((transacao) {
        switch (tipo.toUpperCase()) {
          case 'PIX':
            return transacao.tipo == TipoTransacao.PIX_ENVIADO ||
                transacao.tipo == TipoTransacao.PIX_RECEBIDO;
          case 'TRANSFERENCIA':
            return transacao.tipo == TipoTransacao.TRANSFERENCIA_ENVIADA ||
                transacao.tipo == TipoTransacao.TRANSFERENCIA_RECEBIDA;
          case 'DEPOSITO':
            return transacao.tipo == TipoTransacao.DEPOSITO;
          case 'PAGAMENTO':
          case 'PAGAMENTO_CARTAO':
            return transacao.tipo == TipoTransacao.PAGAMENTO_CARTAO;
          default:
            return true;
        }
      }).toList();

    } catch (e) {
      print('Erro ao buscar transações por tipo: $e');
      return [];
    }
  }

  /// Busca apenas transações enviadas
  static Future<List<TransacaoExtrato>> buscarTransacoesEnviadas(
      int clienteId) async {
    try {
      final url = Uri.parse('$baseUrlTransacao/enviadas/$clienteId');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> lista = jsonDecode(response.body);
        
        List<TransacaoExtrato> transacoes = lista
            .map((json) => TransacaoExtrato.fromJson(json, clienteId))
            .toList();

        transacoes.sort((a, b) => b.data.compareTo(a.data));
        _calcularSaldos(transacoes);

        return transacoes;
      }
      return [];
    } catch (e) {
      print('Erro ao buscar transações enviadas: $e');
      return [];
    }
  }

  /// Busca apenas transações recebidas
  static Future<List<TransacaoExtrato>> buscarTransacoesRecebidas(
      int clienteId) async {
    try {
      final url = Uri.parse('$baseUrlTransacao/recebidas/$clienteId');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> lista = jsonDecode(response.body);
        
        List<TransacaoExtrato> transacoes = lista
            .map((json) => TransacaoExtrato.fromJson(json, clienteId))
            .toList();

        transacoes.sort((a, b) => b.data.compareTo(a.data));
        _calcularSaldos(transacoes);

        return transacoes;
      }
      return [];
    } catch (e) {
      print('Erro ao buscar transações recebidas: $e');
      return [];
    }
  }

  /// Calcula os saldos anterior e posterior de cada transação
  static void _calcularSaldos(List<TransacaoExtrato> transacoes) {
    if (transacoes.isEmpty) return;

    // Ordenar por data crescente temporariamente para calcular os saldos
    List<TransacaoExtrato> transacoesOrdenadas = List.from(transacoes);
    transacoesOrdenadas.sort((a, b) => a.data.compareTo(b.data));

    double saldoAtual = 0;

    // Se a primeira transação já tem saldo anterior definido, usar ele
    if (transacoesOrdenadas.first.saldoAnterior > 0) {
      saldoAtual = transacoesOrdenadas.first.saldoAnterior;
    }

    for (int i = 0; i < transacoesOrdenadas.length; i++) {
      TransacaoExtrato transacao = transacoesOrdenadas[i];
      
      double saldoAnterior = saldoAtual;
      
      // Atualizar saldo baseado no tipo de transação
      if (_isTransacaoPositiva(transacao.tipo)) {
        saldoAtual += transacao.valor;
      } else {
        saldoAtual -= transacao.valor;
      }
      
      // Criar nova instância com os saldos calculados
      transacoesOrdenadas[i] = TransacaoExtrato(
        id: transacao.id,
        tipo: transacao.tipo,
        valor: transacao.valor,
        data: transacao.data,
        descricao: transacao.descricao,
        chavePix: transacao.chavePix,
        contaDestino: transacao.contaDestino,
        contaOrigem: transacao.contaOrigem,
        numeroCartao: transacao.numeroCartao,
        saldoAnterior: saldoAnterior,
        saldoPosterior: saldoAtual,
      );
    }

    // Atualizar a lista original com os saldos calculados
    for (int i = 0; i < transacoes.length; i++) {
      String id = transacoes[i].id;
      TransacaoExtrato transacaoComSaldo = transacoesOrdenadas.firstWhere(
        (t) => t.id == id,
      );
      transacoes[i] = transacaoComSaldo;
    }
  }

  /// Verifica se a transação aumenta o saldo (é positiva)
  static bool _isTransacaoPositiva(TipoTransacao tipo) {
    return tipo == TipoTransacao.PIX_RECEBIDO ||
        tipo == TipoTransacao.TRANSFERENCIA_RECEBIDA ||
        tipo == TipoTransacao.DEPOSITO;
  }

  /// Busca saldo atual do cliente
  static Future<double> buscarSaldoAtual(int clienteId) async {
    try {
      final url = Uri.parse('http://localhost:8080/apiCliente/$clienteId');
      
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dados = jsonDecode(response.body);
        return (dados['saldo'] as num?)?.toDouble() ?? 0.0;
      }
      return 0.0;
    } catch (e) {
      print('Erro ao buscar saldo: $e');
      return 0.0;
    }
  }
}