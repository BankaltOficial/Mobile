import 'package:shared_preferences/shared_preferences.dart';

Future<void> salvarSaldo(double saldo) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setDouble('saldo_usuario', saldo);
}

Future<double> carregarSaldo() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getDouble('saldo_usuario') ?? 100.0;
}

Future<void> salvarScore(int score) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('score_usuario', score);
}