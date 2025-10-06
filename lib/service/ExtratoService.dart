import 'dart:convert';
import 'package:flutter_application_1/service/TransferenciaExtrato.dart';
import 'package:http/http.dart' as http;

class ExtratoService {
  static const String baseUrl = 'http://localhost:8080/apiExtrato';

  static Future<List<TransacaoExtrato>> buscarTransacoes(int clienteId) async {
    try {
      // Buscar TODAS as transações do cliente (enviadas e recebidas)
      final url = Uri.parse('$baseUrl/cliente/$clienteId');
      
      final response = await http.get(url);

      print('Status Code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        List<dynamic> lista = jsonDecode(response.body);
        
        // Converter todas as transações
        List<TransacaoExtrato> transacoes = lista
            .map((json) => TransacaoExtrato.fromJson(json, clienteId))
            .toList();

        // Ordenar por data decrescente (mais recente primeiro)
        transacoes.sort((a, b) => b.data.compareTo(a.data));

        // Calcular saldos (do mais antigo para o mais recente)
        _calcularSaldos(transacoes);

        return transacoes;
      } else {
        print('Erro na requisição: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Erro ao buscar transações: $e');
      return [];
    }
  }

  static Future<List<TransacaoExtrato>> buscarTransacoesPorTipo(
      int clienteId, String tipo) async {
    try {
      final url = Uri.parse('$baseUrl/cliente/$clienteId/tipo/$tipo');
      
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> lista = jsonDecode(response.body);
        
        List<TransacaoExtrato> transacoes = lista
            .map((json) => TransacaoExtrato.fromJson(json, clienteId))
            .toList();

        transacoes.sort((a, b) => b.data.compareTo(a.data));
        _calcularSaldos(transacoes);

        return transacoes;
      } else {
        return [];
      }
    } catch (e) {
      print('Erro ao buscar transações por tipo: $e');
      return [];
    }
  }

  static void _calcularSaldos(List<TransacaoExtrato> transacoes) {
    if (transacoes.isEmpty) return;

    // Ordenar por data crescente temporariamente para calcular os saldos
    List<TransacaoExtrato> transacoesOrdenadas = List.from(transacoes);
    transacoesOrdenadas.sort((a, b) => a.data.compareTo(b.data));

    double saldoAtual = 0;

    // Calcular saldo inicial baseado na primeira transação
    // Aqui você pode buscar o saldo real do banco se preferir
    
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
      TransacaoExtrato? transacaoComSaldo = transacoesOrdenadas.firstWhere(
        (t) => t.id == id,
      );
      transacoes[i] = transacaoComSaldo;
    }
  }

  static bool _isTransacaoPositiva(TipoTransacao tipo) {
    return tipo == TipoTransacao.PIX_RECEBIDO ||
        tipo == TipoTransacao.TRANSFERENCIA_RECEBIDA ||
        tipo == TipoTransacao.DEPOSITO;
  }
}