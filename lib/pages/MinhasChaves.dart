import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/PixScreen.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/Sessao.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MinhasChavesScreen extends StatefulWidget {
  @override
  _MinhasChavesScreenState createState() => _MinhasChavesScreenState();
}

class _MinhasChavesScreenState extends State<MinhasChavesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Usuario usuario = Sessao.getUsuario()!;
  String selectedKey = 'email';
  bool isUpdating = false;

  // Função para buscar o PIX do usuário
  Future<Map<String, dynamic>?> buscarPixDoUsuario(int clienteId) async {
    try {
      final url = Uri.parse(
          'http://localhost:8080/apiPix/buscarPorClienteId/$clienteId');

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      print("Buscar PIX - Status: ${response.statusCode}");
      print("Buscar PIX - Response: ${response.body}");

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print("Erro ao buscar PIX: $e");
      return null;
    }
  }

  // Função para atualizar a chave PIX via API
  Future<bool> atualizarChavePix(String chave, String tipo) async {
    Usuario? usuario = Sessao.getUsuario();
    if (usuario == null) {
      print("Usuário não logado");
      return false;
    }

    try {
      // Primeiro busca o PIX existente do usuário
      Map<String, dynamic>? pixExistente = await buscarPixDoUsuario(usuario.id);

      if (pixExistente != null && pixExistente['id'] != null) {
        // Se já existe um PIX, atualiza usando o ID do PIX
        final pixId = pixExistente['id'];
        final url = Uri.parse('http://localhost:8080/apiPix/atualizar/$pixId');

        final body = {
          "chave": chave,
          "tipo": tipo,
          // Inclui o cliente se necessário
          "cliente": {"id": usuario.id}
        };

        print("Atualizando PIX existente - ID: $pixId");
        print("URL: $url");
        print("Body: ${jsonEncode(body)}");

        final response = await http.put(
          url,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode(body),
        );

        print("Status atualização: ${response.statusCode}");
        print("Response: ${response.body}");

        if (response.statusCode == 200) {
          print("PIX atualizado com sucesso!");
          return true;
        } else {
          print("Erro ao atualizar PIX: ${response.statusCode}");
          return false;
        }
      } else {
        // Se não existe PIX, precisa criar um novo
        // Você precisará implementar o endpoint de criação no backend
        print("PIX não encontrado para o usuário. Necessário criar novo PIX.");

        // Tenta criar um novo PIX (assumindo que existe um endpoint para isso)
        final urlCriar = Uri.parse('http://localhost:8080/apiPix/criar');

        final body = {
          "clienteId": usuario.id,
          "chave": chave,
          "tipo": tipo,
        };

        print("Criando novo PIX");
        print("URL: $urlCriar");
        print("Body: ${jsonEncode(body)}");

        final response = await http.post(
          urlCriar,
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
          },
          body: jsonEncode(body),
        );

        print("Status criação: ${response.statusCode}");
        print("Response: ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          print("PIX criado com sucesso!");
          return true;
        } else {
          print("Erro ao criar PIX: ${response.statusCode}");
          return false;
        }
      }
    } catch (e) {
      print("Erro na requisição PIX: $e");
      return false;
    }
  }

  // Função para processar a atualização da chave PIX
  Future<void> _processarAtualizacao() async {
    if (isUpdating) return;

    setState(() {
      isUpdating = true;
    });

    String novaChave;
    String tipoChave;

    // Determina a nova chave e o tipo baseado na seleção
    switch (selectedKey) {
      case 'email':
        novaChave = usuario.email;
        tipoChave = 'EMAIL';
        break;
      case 'telefone':
        novaChave = usuario.telefone;
        tipoChave = 'TELEFONE';
        break;
      case 'cpf':
        novaChave = usuario.cpf;
        tipoChave = 'CPF';
        break;
      default:
        novaChave = usuario.email;
        tipoChave = 'EMAIL';
        break;
    }

    // Chama a API para atualizar a chave PIX
    bool sucesso = await atualizarChavePix(novaChave, tipoChave);

    setState(() {
      isUpdating = false;
    });

    if (sucesso) {
      // Atualiza localmente apenas se a API retornar sucesso
      usuario.chavePix = novaChave;
      Sessao.atualizarUsuario(usuario);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Chave PIX atualizada com sucesso!'),
          backgroundColor: AppColors.defaultTertiary,
          duration: Duration(seconds: 3),
        ),
      );

      // Atualiza a interface para mostrar a nova chave
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao atualizar chave PIX. Tente novamente.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
          title: 'Minhas Chaves',
          scaffoldKey: _scaffoldKey,
          onBackPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PixScreen(),
              ),
            );
          }),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          SizedBox(height: 40),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'Escolha qual será sua\nchave PIX',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.invertMode,
                      height: 1.3,
                    ),
                  ),

                  SizedBox(height: 40),

                  // Email option
                  _buildKeyOption(
                    'email',
                    'Email',
                    usuario.email,
                    Icons.email_outlined,
                  ),

                  SizedBox(height: 16),

                  // Phone option
                  _buildKeyOption(
                    'telefone',
                    'Telefone',
                    usuario.telefone,
                    Icons.phone_outlined,
                  ),

                  SizedBox(height: 16),

                  // CPF option
                  _buildKeyOption(
                    'cpf',
                    'CPF',
                    usuario.cpf,
                    Icons.person_outline,
                  ),

                  SizedBox(height: 40),

                  // Current key section
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.mainWhite,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.key,
                              color: AppColors.main,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Sua chave atual é ',
                              style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.main,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          usuario.chavePix.isNotEmpty
                              ? usuario.chavePix
                              : 'Nenhuma chave cadastrada',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: usuario.chavePix.isNotEmpty
                                ? Colors.black87
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40),
                ],
              ),
            ),
          ),

          // Loading indicator
          if (isUpdating)
            Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.main),
              ),
            ),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: isUpdating ? null : _processarAtualizacao,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isUpdating ? Colors.grey[400] : AppColors.main,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  elevation: isUpdating ? 0 : null,
                ),
                child: Text(
                  isUpdating ? "Atualizando..." : "Continuar",
                  style: TextStyle(fontSize: 15, color: AppColors.mainWhite),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: isUpdating
                    ? null
                    : () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const PixScreen()),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isUpdating ? Colors.grey[400] : AppColors.mainRed,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                  elevation: isUpdating ? 0 : null,
                ),
                child: const Text(
                  "Cancelar",
                  style: TextStyle(fontSize: 15, color: AppColors.mainWhite),
                ),
              ),
            ],
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildKeyOption(
      String key, String title, String value, IconData icon) {
    bool isSelected = selectedKey == key;

    return GestureDetector(
      onTap: isUpdating
          ? null
          : () {
              setState(() {
                selectedKey = key;
              });
            },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.mainWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.main : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.main : Colors.grey[400]!,
                  width: 2,
                ),
                color: isSelected ? AppColors.main : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.circle,
                      size: 8,
                      color: AppColors.mainWhite,
                    )
                  : null,
            ),
            SizedBox(width: 16),
            Icon(
              icon,
              size: 24,
              color: isUpdating ? Colors.grey[400] : AppColors.mainGray,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isUpdating ? Colors.grey[600] : Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: isUpdating ? Colors.grey[400] : AppColors.mainGray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
