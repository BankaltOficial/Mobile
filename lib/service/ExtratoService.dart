import 'dart:convert';
import 'package:flutter_application_1/service/TransferenciaExtrato.dart';
import 'package:http/http.dart' as http;
import 'Usuario.dart'; // já existente

class ExtratoService {
  static Future<List<TransacaoExtrato>> buscarTransacoes(int clienteId) async {
    try {
      final urlEnvio =
          Uri.parse('http://localhost:8080/apiExtrato/clienteEnvio/$clienteId');
      final urlRecebido = Uri.parse(
          'http://localhost:8080/apiExtrato/clienteRecebido/$clienteId');

      final responseEnvio = await http.get(urlEnvio);
      final responseRecebido = await http.get(urlRecebido);

      print('Response body: ${responseEnvio.body}');
      print('Response body: ${responseRecebido.body}');

      List<TransacaoExtrato> transacoes = [];

      if (responseEnvio.statusCode == 200) {
        List<dynamic> listaEnvio = jsonDecode(responseEnvio.body);
        transacoes.addAll(
            listaEnvio.map((json) => TransacaoExtrato.fromJson(json, true)));
      }

      if (responseRecebido.statusCode == 200) {
        List<dynamic> listaRecebido = jsonDecode(responseRecebido.body);
        transacoes.addAll(listaRecebido
            .map((json) => TransacaoExtrato.fromJson(json, false)));
      }

      // Ordenar por data decrescente
      transacoes.sort((a, b) => b.data.compareTo(a.data));

      return transacoes;
    } catch (e) {
      print('Erro ao buscar transações: $e');
      return [];
    }
  }
}
