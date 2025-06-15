// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/pages/CardsScreen.dart';
import 'package:flutter_application_1/pages/EducationScreen.dart';
import 'package:flutter_application_1/pages/EmprestimoScreen.dart';
import 'package:flutter_application_1/pages/InvestimentoScreen.dart';
import 'package:flutter_application_1/pages/PersonalizedScreen.dart';
import 'package:flutter_application_1/pages/PixScreen.dart';
import 'package:flutter_application_1/pages/TransferenciaScreen.dart';
import 'package:flutter_application_1/pages/WelcomeScreen.dart';
import 'package:flutter_application_1/pages/BoletoScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/UsuarioService.dart';
import 'package:flutter_application_1/service/Sessao.dart';

class InicialScreen extends StatefulWidget {
  const InicialScreen({super.key});

  @override
  State<InicialScreen> createState() => _InicialScreenState();
}

class _InicialScreenState extends State<InicialScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Usuario usuario = Sessao.getUsuario() ??
      Usuario('Usuário', 'CPF não encontrado', '', '', '', '', '');

  Icon iconVisibility = Icon(Icons.visibility);
  String txtSaldo = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _inicializarDados();
  }

  // Método para inicializar e carregar dados atualizados
  Future<void> _inicializarDados() async {
    try {
      // Inicializar o UsuarioService
      await UsuarioService.inicializar();
      
      // Carregar dados atualizados do usuário
      await _carregarDadosUsuario();
    } catch (e) {
      print('Erro ao inicializar dados: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Método para carregar dados atualizados do usuário
  Future<void> _carregarDadosUsuario() async {
    try {
      // Carregar lista atualizada de usuários
      List<Usuario> usuariosAtualizados = await UsuarioService.carregarUsuarios();
      
      // Encontrar o usuário atual na lista atualizada
      Usuario? usuarioAtualizado = usuariosAtualizados.firstWhere(
        (u) => u.id == usuario.id,
        orElse: () => usuario,
      );
      
      setState(() {
        usuario = usuarioAtualizado;
        txtSaldo = usuario.saldo.toStringAsFixed(2).replaceAll('.', ',');
        
        // Se o saldo estiver oculto, manter oculto
        if (iconVisibility.icon == Icons.visibility_off) {
          txtSaldo = '**********';
        }
      });
      
    } catch (e) {
      print('Erro ao carregar dados do usuário: $e');
    }
  }

  // Método para atualizar saldo quando retornar de outras telas
  Future<void> _atualizarSaldo() async {
    await _carregarDadosUsuario();
  }

  @override
  Widget build(BuildContext context) {
    String nome = usuario.nome;
    double saldo = usuario.saldo;

    if (isLoading) {
      return Scaffold(
        backgroundColor: AppColors.themeColor,
        body: Center(
          child: CircularProgressIndicator(
            color: AppColors.main,
          ),
        ),
      );
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
            title: 'Pagina Inicial',
            scaffoldKey: _scaffoldKey,
            onBackPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const WelcomeScreen(),
                ),
              );
            }),
        drawer: CustomDrawer(),
        backgroundColor: AppColors.themeColor,
        body: RefreshIndicator(
          onRefresh: _atualizarSaldo,
          color: AppColors.main,
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Olá, $nome', style: TextStyle(fontSize: 27, color: AppColors.invertMode)),
                      SizedBox(width: 15),
                      Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    '',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: Icon(
                                          Icons.person,
                                          size: 50,
                                          color: Colors.grey[600],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                    ],
                  ),
                  SizedBox(height: 25),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        height: 125,
                        child: Image.asset(
                          'assets/images/LogoBANKALTsemfundo1.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(
                        height: 120,
                        width: 250,
                        child: Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.mainLight,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Saldo',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold, 
                                          color: AppColors.invertMode)),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          iconVisibility = iconVisibility.icon ==
                                                  Icons.visibility
                                              ? Icon(Icons.visibility_off)
                                              : Icon(Icons.visibility);
                                          if (iconVisibility.icon ==
                                              Icons.visibility_off) {
                                            txtSaldo = '**********';
                                          } else {
                                            txtSaldo = saldo
                                                .toStringAsFixed(2)
                                                .replaceAll('.', ',');
                                          }
                                        });
                                      },
                                      icon: Icon(iconVisibility.icon,
                                          color: AppColors.main, size: 25)),
                                ],
                              ),
                              Text('R\$ $txtSaldo',
                                  style: TextStyle(fontSize: 24, color: AppColors.invertMode)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  TextButton(
                      onPressed: () async {
                        final result = await Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PixScreen()));
                        // Atualizar saldo quando retornar
                        if (result == true) {
                          _atualizarSaldo();
                        }
                      },
                      child: Text("Ver extrato >",
                          style: TextStyle(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold))),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  height: 75,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final result = await Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PixScreen()));
                                      // Atualizar saldo quando retornar
                                      if (result == true) {
                                        _atualizarSaldo();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.main,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    child: Image.asset("assets/icons/Pix.png",
                                        width: 50, height: 50),
                                  ))),
                          SizedBox(height: 5),
                          Text("Pix",
                              style: TextStyle(
                                  color: AppColors.invertModeGray,
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  height: 75,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final result = await Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const CardsScreen()));
                                      if (result == true) {
                                        _atualizarSaldo();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.main,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    child: Image.asset("assets/icons/Cartoes.png",
                                        width: 50, height: 50),
                                  ))),
                          SizedBox(height: 5),
                          Text("Cartões",
                              style: TextStyle(
                                  color: AppColors.invertModeGray,
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  height: 75,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final result = await Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const BoletoScreen()));
                                      if (result == true) {
                                        _atualizarSaldo();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.main,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    child: Image.asset("assets/icons/Boleto.png",
                                        width: 50, height: 50),
                                  ))),
                          SizedBox(height: 5),
                          Text("Boleto",
                              style: TextStyle(
                                  color: AppColors.invertModeGray,
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  height: 75,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final result = await Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const InvestimentoScreen()));
                                      if (result == true) {
                                        _atualizarSaldo();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.main,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    child: Image.asset(
                                        "assets/icons/Investimento.png",
                                        width: 50,
                                        height: 50),
                                  ))),
                          SizedBox(height: 5),
                          Text("Investimentos",
                              style: TextStyle(
                                  color: AppColors.invertModeGray,
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  height: 75,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final result = await Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const TransferenciaScreen()));
                                      // Atualizar saldo quando retornar da transferência
                                      if (result == true) {
                                        _atualizarSaldo();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.main,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    child: Image.asset(
                                        "assets/icons/Transferencia.png",
                                        width: 50,
                                        height: 50),
                                  ))),
                          SizedBox(height: 5),
                          Text("Transferência",
                              style: TextStyle(
                                  color: AppColors.invertModeGray,
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  height: 75,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final result = await Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const EmprestimoScreen()));
                                      if (result == true) {
                                        _atualizarSaldo();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.main,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    child: Image.asset(
                                        "assets/icons/Emprestimo.png",
                                        width: 50,
                                        height: 50),
                                  ))),
                          SizedBox(height: 5),
                          Text("Empréstimo",
                              style: TextStyle(
                                  color: AppColors.invertModeGray,
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              height: 75,
                              child: ElevatedButton(
                                onPressed: () async {
                                  final result = await Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const EducationScreen()));
                                  if (result == true) {
                                    _atualizarSaldo();
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.main,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10))),
                                child: Image.asset("assets/icons/Estudos.png",
                                    width: 50, height: 50),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text("Educação",
                              style: TextStyle(
                                  color: AppColors.invertModeGray,
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  height: 75,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final result = await Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const PersonalizedScreen()));
                                      if (result == true) {
                                        _atualizarSaldo();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.main,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    child: Image.asset(
                                        "assets/icons/Personalizacao.png",
                                        width: 50,
                                        height: 50),
                                  ))),
                          SizedBox(height: 5),
                          Text("Personalização",
                              style: TextStyle(
                                  color: AppColors.invertModeGray,
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ));
  }
}