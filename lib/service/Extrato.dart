import 'Usuario.dart';

class Extrato {
  final int id;
  final double valor;
  final DateTime data;
  final Usuario clienteEnvio;
  final Usuario clienteRecebido;

  Extrato({
    required this.id,
    required this.valor,
    required this.data,
    required this.clienteEnvio,
    required this.clienteRecebido,
  });

  factory Extrato.fromJson(Map<String, dynamic> json) {
    return Extrato(
      id: json['id'] as int,
      valor: (json['valor'] as num).toDouble(),
      data: DateTime.parse(_parseDateTime(json['data'])),
      clienteEnvio: Usuario.fromJson(json['clienteEnvio']),
      clienteRecebido: Usuario.fromJson(json['clienteRecebido']),
    );
  }

  static String _parseDateTime(String dataString) {
    // Formato esperado: "25/12/2000 17:00"
    final parts = dataString.split(' ');
    final dateParts = parts[0].split('/');
    final timeParts = parts[1].split(':');

    return '${dateParts[2].padLeft(4, '0')}-${dateParts[1].padLeft(2, '0')}-${dateParts[0].padLeft(2, '0')}T${timeParts[0].padLeft(2, '0')}:${timeParts[1].padLeft(2, '0')}:00';
  }
}
