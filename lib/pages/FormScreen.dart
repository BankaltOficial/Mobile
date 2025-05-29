// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/TermsScreen.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/pages/inicialScreen.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();

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
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: mainWhite),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const TermsScreen(),
                ),
              );
            },
          ),
          title: Text(
            'bankalt',
            style: TextStyle(color: mainWhite, fontWeight: FontWeight.bold),
          ),
          backgroundColor: mainPurple,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Container(
            color: mainLightPurple,
            padding: const EdgeInsets.all(40),
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
                          color: mainPurple,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Text(
                        "Nome completo*",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: mainPurple,
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
                        "Email*",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: mainPurple,
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
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Celular*",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: mainPurple,
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
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu celular';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Data de nascimento*",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: mainPurple,
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
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira sua data de nascimento';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "CPF*",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: mainPurple,
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
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu CPF';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "RG*",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: mainPurple,
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
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira seu RG';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Senha*",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: mainPurple,
                        ),
                      ),
                      TextFormField(
                        controller: senhaController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        style: const TextStyle(color: Colors.black),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira sua senha';
                          }
                          return null;
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
                          backgroundColor: mainPurple,
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
