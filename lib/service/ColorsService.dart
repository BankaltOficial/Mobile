import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/Sessao.dart';

class ColorService {
  static const String baseUrl =
      "http://localhost:8080/apiCliente/atualizar"; // ajuste para sua API

  /// Carrega as cores do usuário a partir da API
  static Future<void> loadColors() async {
    Usuario? usuario = Sessao.getUsuario();
    if (usuario == null) return;

    final response = await http.get(Uri.parse("$baseUrl/${usuario.id}"));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      AppColors.main =
          _getColorFromHex(data["corPrincipal"]) ?? AppColors.defaultMain;
      AppColors.secondary =
          _getColorFromHex(data["corSecundaria"]) ?? AppColors.defaultSecondary;
      AppColors.tertiary =
          _getColorFromHex(data["corTerciaria"]) ?? AppColors.defaultTertiary;
      AppColors.isDarkMode = data["temaEscuro"] ?? false;
      AppColors.themeColor =
          AppColors.isDarkMode ? AppColors.darkMode : AppColors.lightMode;
    }
  }

  /// Salva as cores escolhidas na API
  static Future<bool> saveColors(
      Color main, Color secondary, Color tertiary) async {
    Usuario? usuario = Sessao.getUsuario();
    if (usuario == null) return false;

    final body = {
      "userId": usuario.id,
      "corPrincipal": _colorToHex(main),
      "corSecundaria": _colorToHex(secondary),
      "corTerciaria": _colorToHex(tertiary),
      "modo": AppColors.isDarkMode,
    };

    final response = await http.post(
      Uri.parse("$baseUrl/update"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    return response.statusCode == 200;
  }

  /// Salva apenas o tema (claro/escuro) na API
  static Future<bool> saveTheme(bool isDark) async {
    Usuario? usuario = Sessao.getUsuario();
    if (usuario == null) return false;

    final body = {
      "id": usuario.id,
      "modo": isDark,
    };

    final response = await http.patch(
      Uri.parse("$baseUrl/atualizar"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      AppColors.isDarkMode = isDark;
      AppColors.themeColor = isDark ? AppColors.darkMode : AppColors.lightMode;
      return true;
    }
    return false;
  }

  /// Atalho para alternar dark mode e salvar na API
  static Future<void> toggleDarkMode() async {
    final novoTema = !AppColors.isDarkMode;
    await saveTheme(novoTema);
  }

  // Helpers
  static String _colorToHex(Color color) =>
      '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';

  static Color? _getColorFromHex(String? hex) {
    if (hex == null || !hex.startsWith('#')) return null;
    return Color(int.parse(hex.substring(1), radix: 16));
  }

  static Future<void> setTheme(bool isDark) async {
    await saveTheme(isDark);
  }
}
