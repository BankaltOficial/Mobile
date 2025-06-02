// ignore: file_names
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, file_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/inicialScreen.dart';
import 'package:flutter_application_1/pages/TermsScreen.dart';
import 'package:flutter_application_1/pages/DescricaoScreen.dart';
import 'package:flutter_application_1/pages/SobreNosScreen.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/Sessao.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

TextEditingController cpfController = TextEditingController();
TextEditingController passwordController = TextEditingController();
bool _senhaVisivel = false;

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var cpfMask = MaskTextInputFormatter(
        mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 200,
          backgroundColor: AppColors.main,
          title: Image.asset('assets/images/LogoTitulo.png',
              height: 200, width: 200),
          centerTitle: true,
        ),
        body: ListView(children: [
          Column(children: [
            Container(
              color: AppColors.mainWeak,
              padding: EdgeInsets.all(15),
              child: Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Acesse sua conta",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.main,
                                fontWeight: FontWeight.bold,
                                fontSize: 17)),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("CPF",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: AppColors.main,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: cpfController,
                          inputFormatters: [cpfMask],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Preencha todos os campos antes de continuar";
                            } else if (value.length != 14) {
                              return "O CPF deve ter exatamente 11 dígitos";
                            }

                            return null;
                          },
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: '000.000.000-00',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.all(8)),
                        ),
                        SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Senha",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: AppColors.main,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 15),
                        TextFormField(
                          controller: passwordController,
                          obscureText: !_senhaVisivel,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Preencha todos os campos antes de continuar";
                            } // voltar novamente quando for validar a senha

                            return null;
                          },
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _senhaVisivel
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _senhaVisivel = !_senhaVisivel;
                                  });
                                },
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: '*******',
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              contentPadding: EdgeInsets.all(8)),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              String cpf = cpfController.text;
                              String senha = passwordController.text;
                              Usuario? usuario = buscarUsuarioPorCpf(cpf);
                              if (usuario != null && usuario.senha == senha) {
                                Sessao.salvarUsuario(usuario);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Login Feito com Sucesso')),
                                );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => InicialScreen()));
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('CPF ou senha incorretos')),
                                );
                                return;
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.main,
                            foregroundColor: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 140, vertical: 15),
                            textStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          child: const Text('ENTRAR'),
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const TermsScreen()));
                                  },
                                  child: Text(
                                    "Não tem uma conta?",
                                    style: TextStyle(
                                        color: AppColors.main,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ]),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                                onPressed: () {},
                                child: Text(
                                  "Esqueceu a senha?",
                                  style: TextStyle(color: AppColors.mainGray),
                                )),
                          )
                        ]),
                      ])),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Contato",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text("@bankalt.ofc"),
                      Text("projetobankalt@gmail.com"),
                    ],
                  ),

                  // Coluna de telefone
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Se preferir ligue",
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text("(19) 99819-3930"),
                      Text("(19) 97157-3019"),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SobreNosScreen()));
                      }, child: Text(
                        "Sobre o Projeto",
                        style: TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,),
                      ))
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(onPressed: (){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DescricaoScreen()));
                      }, child: Text(
                        "Descrição do Projeto",
                        style: TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.bold,),
                      ))
                    ],
                  ),
                ],
              ),
            )
          ])
        ]));
  }
}
