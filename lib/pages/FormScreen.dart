// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/TermsScreen.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/pages/inicialScreen.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_application_1/components/AppBar.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _obscureText = true;

  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController celularController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController rgController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  var celularMask = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  var dataNascimentoMask = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  var cpfMask = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  var rgMask = MaskTextInputFormatter(
      mask: '##.###.###-#', filter: {"#": RegExp(r'[0-9]')});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: _scaffoldKey,
        appBar: SimpleCustomAppBar(
          title: 'Cadastro',
          showBackButton: true,
          onBackPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const TermsScreen(),
              ),
            );
          },
        ),
        body: SingleChildScrollView(
          child: Container(
            color: AppColors.mainLightPurple,
            padding: const EdgeInsets.all(40),
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "DADOS PESSOAIS",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppColors.main,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        "Nome completo",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.main,
                        ),
                      ),
                      TextFormField(
                        controller: nomeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        style: const TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu nome completo';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.main,
                        ),
                      ),
                      TextFormField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          style: const TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Por favor, insira seu email';
                            }
                            final emailRegex =
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value.trim())) {
                              return 'Insira um email válido';
                            }
                            return null;
                          }),
                      const SizedBox(height: 20),
                      Text(
                        "Celular",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.main,
                        ),
                      ),
                      TextFormField(
                        controller: celularController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        inputFormatters: [celularMask],
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor, insira seu celular';
                          }
                          if (value.replaceAll(RegExp(r'\D'), '').length < 11) {
                            return 'Insira um número de celular válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Data de nascimento",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.main,
                        ),
                      ),
                      TextFormField(
                          controller: dataController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          inputFormatters: [dataNascimentoMask],
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: Colors.black),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Por favor, insira sua data de nascimento';
                            }
                            final parts = value.split('/');
                            if (parts.length != 3)
                              return 'Formato inválido (dd/mm/aaaa)';
                            final day = int.tryParse(parts[0]);
                            final month = int.tryParse(parts[1]);
                            final year = int.tryParse(parts[2]);
                            if (day == null || month == null || year == null)
                              return 'Data inválida';

                            try {
                              final date = DateTime(year, month, day);
                              if (date.isAfter(DateTime.now()))
                                return 'Data no futuro é inválida';
                            } catch (_) {
                              return 'Data inválida';
                            }
                            return null;
                          }),
                      const SizedBox(height: 20),
                      Text(
                        "CPF",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.main,
                        ),
                      ),
                      TextFormField(
                        controller: cpfController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        inputFormatters: [cpfMask],
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor, insira seu CPF';
                          }

                          String cpf = value.replaceAll(RegExp(r'\D'), '');
                          if (cpf.length != 11 ||
                              RegExp(r'^(\d)\1*$').hasMatch(cpf)) {
                            return 'CPF inválido';
                          }

                          List<int> digits =
                              cpf.split('').map(int.parse).toList();

                          int sum1 = 0;
                          for (int i = 0; i < 9; i++) {
                            sum1 += digits[i] * (10 - i);
                          }
                          int firstVerifier = (sum1 * 10) % 11;
                          if (firstVerifier == 10) firstVerifier = 0;
                          if (digits[9] != firstVerifier) {
                            return 'CPF inválido';
                          }

                          int sum2 = 0;
                          for (int i = 0; i < 10; i++) {
                            sum2 += digits[i] * (11 - i);
                          }
                          int secondVerifier = (sum2 * 10) % 11;
                          if (secondVerifier == 10) secondVerifier = 0;
                          if (digits[10] != secondVerifier) {
                            return 'CPF inválido';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "RG",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.main,
                        ),
                      ),
                      TextFormField(
                        controller: rgController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        inputFormatters: [rgMask],
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Por favor, insira seu RG';
                          }

                          String rg = value.replaceAll(RegExp(r'\D'), '');
                          if (rg.length < 7 || rg.length > 9) {
                            return 'RG inválido';
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                        Text(
                        "Senha",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.main,
                        ),
                      ),
                        StatefulBuilder(
                          builder: (context, setStateSB) {
                            return TextFormField(
                              controller: senhaController,
                              obscureText: _obscureText,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureText
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: AppColors.main,
                                  ),
                                  onPressed: () {
                                    setStateSB(() {
                                      _obscureText = !_obscureText;
                                    });
                                  },
                                ),
                              ),
                              style: const TextStyle(color: Colors.black),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Por favor, insira sua senha';
                                }
                                if (value.length < 6) {
                                  return 'A senha deve ter no mínimo 6 caracteres';
                                }
                                return null;
                              },
                            );
                          },
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Usuario u = Usuario(
                              nomeController.text,
                              emailController.text,
                              cpfController.text,
                              dataController.text,
                              celularController.text,
                              rgController.text,
                              senhaController.text,
                            );
                            cadastrarUsuario(u);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Dados enviados com sucesso!')),
                            );
                            usuarios.forEach((usuario) {
                              print('--- Usuário ---');
                              print('Nome: ${usuario.nome}');
                              print('Email: ${usuario.email}');
                              print('CPF: ${usuario.cpf}');
                              print('RG: ${usuario.rg}');
                              print('Nascimento: ${usuario.dataNascimento}');
                              print('Celular: ${usuario.celular}');
                              print('Senha: ${usuario.senha}');
                              print('----------------');
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.main,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 20),
                        ),
                        child: const Text(
                          "Continuar",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
