// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/Sessao.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_application_1/pages/inicialScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/ColorsService.dart';
import 'package:flutter_application_1/service/ColorsProvider.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PersonalizedScreen extends StatefulWidget {
  const PersonalizedScreen({super.key});

  @override
  State<PersonalizedScreen> createState() => _PersonalizedScreenState();
}

class _PersonalizedScreenState extends State<PersonalizedScreen> {
  Color mainColor = AppColors.main;
  Color secondaryColor = AppColors.secondary;
  Color tertiaryColor = AppColors.tertiary;
  bool isDarkMode = AppColors.isDarkMode;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();
    _carregarConfiguracoes();
  }

  // 🔹 Testa apenas a atualização do modo
  Future<bool> _testarAtualizacaoApenasModo(String modo) async {
    Usuario? usuario = Sessao.getUsuario();
    if (usuario == null) return false;

    try {
      final url = Uri.parse('http://localhost:8080/apiCliente/atualizar');
      final body = {
        "id": usuario.id,
        "modo": modo,
      };

      print("=== TESTE: APENAS MODO ===");
      print("Body teste: ${jsonEncode(body)}");

      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("Status teste modo: ${response.statusCode}");
      print("Response teste: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("Erro no teste de modo: $e");
      return false;
    }
  }

  // 🔹 Carrega configurações do usuário do backend
  Future<void> _carregarConfiguracoes() async {
    Usuario? usuario = Sessao.getUsuario();
    if (usuario == null) return;

    try {
      final url = Uri.parse(
          'http://localhost:8080/apiCliente/buscarporcpf/${usuario.cpf}');
      final response = await http.get(url);

      print("Carregando configurações - Status: ${response.statusCode}");

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final userData = jsonDecode(response.body);
        print("Dados do usuário carregados: $userData");

        setState(() {
          // Cores
          if (userData['corPrimaria'] != null) {
            try {
              String corHex = userData['corPrimaria'].replaceAll('#', '');
              mainColor = Color(int.parse('FF$corHex', radix: 16));
            } catch (e) {
              print("Erro ao converter cor primária: $e");
            }
          }

          if (userData['corSecundaria'] != null) {
            try {
              String corHex = userData['corSecundaria'].replaceAll('#', '');
              secondaryColor = Color(int.parse('FF$corHex', radix: 16));
            } catch (e) {
              print("Erro ao converter cor secundária: $e");
            }
          }

          if (userData['corTerciaria'] != null) {
            try {
              String corHex = userData['corTerciaria'].replaceAll('#', '');
              tertiaryColor = Color(int.parse('FF$corHex', radix: 16));
            } catch (e) {
              print("Erro ao converter cor terciária: $e");
            }
          }

          // Tema
          if (userData['modo'] != null) {
            bool modoEscuro = userData['modo'] == 'Dark';
            isDarkMode = modoEscuro;
            print(
                "Modo carregado do backend: ${userData['modo']} -> $isDarkMode");
          }
        });
      }
    } catch (e) {
      print("Erro ao carregar configurações: $e");
    }
  }

  // 🔹 Atualiza no backend
  Future<bool> atualizarCoresETemaCliente(String corPrimaria,
      String corSecundaria, String corTerciaria, String modo) async {
    Usuario? usuario = Sessao.getUsuario();
    if (usuario == null) {
      print("Usuário não logado");
      return false;
    }

    try {
      final url = Uri.parse('http://localhost:8080/apiCliente/atualizar');
      final body = {
        "id": usuario.id,
        "corPrimaria": corPrimaria,
        "corSecundaria": corSecundaria,
        "corTerciaria": corTerciaria,
        "modo": modo,
      };

      print("=== REQUISIÇÃO DE ATUALIZAÇÃO ===");
      print("Body completo: ${jsonEncode(body)}");

      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      print("Status: ${response.statusCode}");
      print("Resposta: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("Erro na requisição: $e");
      return false;
    }
  }

  // 🔹 Processa atualização completa
  Future<void> _processarAtualizacao() async {
    if (isUpdating) return;

    setState(() => isUpdating = true);

    Usuario? usuario = Sessao.getUsuario();
    if (usuario == null) {
      setState(() => isUpdating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Usuário não encontrado!"),
            backgroundColor: Colors.red),
      );
      return;
    }

    String corPrimaria =
        '#${mainColor.value.toRadixString(16).substring(2).toUpperCase()}';
    String corSecundaria =
        '#${secondaryColor.value.toRadixString(16).substring(2).toUpperCase()}';
    String corTerciaria =
        '#${tertiaryColor.value.toRadixString(16).substring(2).toUpperCase()}';
    String modo = isDarkMode ? "Dark" : "Light";

    print("=== PREPARANDO ATUALIZAÇÃO ===");
    print("Modo a ser enviado: $modo");

    // Testa atualização só de modo
    await _testarAtualizacaoApenasModo(modo);

    // Atualiza no backend
    bool sucesso = await atualizarCoresETemaCliente(
        corPrimaria, corSecundaria, corTerciaria, modo);

    if (sucesso) {
      final provider = Provider.of<ColorProvider>(context, listen: false);

      // Atualiza objeto usuário local
      usuario.corPrincipal = corPrimaria;
      usuario.corSecundaria = corSecundaria;
      usuario.corTerciaria = corTerciaria;
      usuario.temaEscuro = isDarkMode;
      Sessao.atualizarUsuario(usuario);

      // Aplica globalmente
      AppColors.main = mainColor;
      AppColors.secondary = secondaryColor;
      AppColors.tertiary = tertiaryColor;
      AppColors.isDarkMode = isDarkMode;

      provider.setColors(mainColor, secondaryColor, tertiaryColor);
      provider.setTheme(isDarkMode);

      await ColorService.saveColors(mainColor, secondaryColor, tertiaryColor);
      await ColorService.saveTheme(isDarkMode);

      setState(() => isUpdating = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Configurações salvas com sucesso!"),
          backgroundColor: AppColors.defaultTertiary,
        ),
      );

      await Future.delayed(Duration(milliseconds: 500));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const InicialScreen()),
      );
    } else {
      setState(() => isUpdating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro ao salvar cores e tema. Tente novamente."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // 🔹 Picker de cores
  void pickColor(Color currentColor, ValueChanged<Color> onColorChanged) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Escolha uma cor"),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: onColorChanged,
          ),
        ),
        actions: [
          TextButton(
            child: Text("Fechar"),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: "Personalizar",
        scaffoldKey: _scaffoldKey,
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const InicialScreen()),
          );
        },
      ),
      drawer: const CustomDrawer(),
      backgroundColor: AppColors.themeColor,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              Text(
                "Escolha as cores do seu aplicativo",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.invertModeGray,
                ),
              ),
              const SizedBox(height: 30),

              // Seletor de cores
              buildColorSelector("Principal", mainColor, () {
                if (!isUpdating)
                  pickColor(mainColor, (c) => setState(() => mainColor = c));
              }),
              const SizedBox(height: 20),
              buildColorSelector("Secundária", secondaryColor, () {
                if (!isUpdating)
                  pickColor(secondaryColor,
                      (c) => setState(() => secondaryColor = c));
              }),
              const SizedBox(height: 20),
              buildColorSelector("Terciária", tertiaryColor, () {
                if (!isUpdating)
                  pickColor(
                      tertiaryColor, (c) => setState(() => tertiaryColor = c));
              }),

              const SizedBox(height: 30),

              if (isUpdating) ...[
                CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(mainColor)),
                const SizedBox(height: 10),
                Text("Salvando configurações...",
                    style: TextStyle(color: AppColors.invertModeGray)),
                const SizedBox(height: 20),
              ],

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: isUpdating ? null : _processarAtualizacao,
                    style: ElevatedButton.styleFrom(backgroundColor: mainColor),
                    child: Text(isUpdating ? "Salvando..." : "Continuar",
                        style: TextStyle(color: AppColors.mainWhite)),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: isUpdating
                        ? null
                        : () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const InicialScreen())),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainRed),
                    child: Text("Cancelar",
                        style: TextStyle(color: AppColors.mainWhite)),
                  ),
                ],
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.palette, color: AppColors.invertModeGray),
                  const SizedBox(width: 10),
                  Text(isDarkMode ? "Modo Escuro" : "Modo Claro",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.invertModeGray)),
                  const SizedBox(width: 10),
                  Switch(
                    value: isDarkMode,
                    activeColor: AppColors.secondary,
                    inactiveThumbColor: AppColors.main,
                    onChanged: isUpdating
                        ? null
                        : (v) => setState(() {
                              isDarkMode = v;
                              print("Switch alterado para $isDarkMode");
                            }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🔹 Construtor de seletor de cor
  Widget buildColorSelector(String title, Color color, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 150,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.invertModeGray, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(title,
                    style: TextStyle(
                        color: AppColors.invertModeGray, fontSize: 18)),
                const SizedBox(height: 10),
                Text(
                  '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 50),
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(12)),
        ),
      ],
    );
  }
}
