// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/CardsScreen.dart';
import 'package:flutter_application_1/EducationScreen.dart';
import 'package:flutter_application_1/InvestimentoScreen.dart';
import 'package:flutter_application_1/PersonalizedScreen.dart';
import 'package:flutter_application_1/PixScreen.dart';
import 'package:flutter_application_1/SplashScreen.dart';
import 'WelcomeScreen.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/colors_provider.dart';
import 'package:flutter_application_1/Usuario.dart';
import 'package:flutter_application_1/Sessao.dart';
import 'package:provider/provider.dart';

class InicialScreen extends StatefulWidget {
  const InicialScreen({super.key});

  @override
  State<InicialScreen> createState() => _InicialScreenState();
}

Color mainPurple = AppColors.main;
Color mainPurpleWeak = const Color.fromARGB(51, 53, 61, 171);
Color mainWhite = AppColors.mainWhite;
Color gray = const Color(0xFF828282);
Color grayBlue = const Color(0xFF495057);
Color mainBlue = AppColors.secondary;
Color mainYellow = const Color(0xFFFFC700);
Color mainLightPurple = const Color(0xFFCBCBE5);
Color mainGreen = AppColors.tertiary;
double saldo = 28567.90;
String txtSaldo = saldo.toStringAsFixed(2).replaceAll('.', ',');
Usuario usuario = Sessao.getUsuario() ?? Usuario('Usuário','CPF não encontrado', '', '', '', '', '');
String nome = usuario.nome;
String cpf = usuario.cpf;
Icon iconVisibility = Icon(Icons.visibility);

class _InicialScreenState extends State<InicialScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<ColorProvider>(context);

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: mainPurple,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.menu, color: mainWhite),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'bankalt',
                        style: TextStyle(
                          color: mainWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: mainWhite),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const WelcomeScreen()),
                      );
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Pagina inicial',
                        style: TextStyle(
                          color: mainWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: colors.main,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: mainWhite,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home_filled),
                title: Text('Página inicial'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InicialScreen()),
                  );
                },
              ),
              ListTile(
                leading: Image.asset("assets/icons/pixColorido.png",
                    width: 20, height: 20),
                title: Text('PIX'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PixScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.bar_chart),
                title: Text('Investimentos'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InvestimentoScreen()),
                  );
                },
              ),
              ListTile(
                leading: Image.asset("assets/icons/cartoesColorido.png",
                    height: 30, width: 30),
                title: Text('Cartões'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CardsScreen()),
                  );
                },
              ),
              Divider(
                color: Colors.grey,
                height: 1,
                thickness: 1,
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Configurações'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CardsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Olá, $nome', style: TextStyle(fontSize: 27)),
                    SizedBox(width: 15),
                    CircleAvatar(
                      radius: 40,
                      backgroundImage:
                          AssetImage('assets/images/IgorSuracci.png'),
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
                          color: lightPurple,
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
                                        fontWeight: FontWeight.bold)),
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
                                        color: colors.main, size: 25)),
                              ],
                            ),
                            Text('R\$ $txtSaldo',
                                style: TextStyle(fontSize: 24)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PixScreen()));
                    },
                    child: Text("Ver extrato >",
                        style: TextStyle(
                            color: mainBlue, fontWeight: FontWeight.bold))),
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
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PixScreen()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: colors.main,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: Image.asset("assets/icons/Pix.png",
                                      width: 50, height: 50),
                                ))),
                        SizedBox(height: 5),
                        Text("Pix",
                            style: TextStyle(
                                color: gray,
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
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const CardsScreen()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: colors.main,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: Image.asset("assets/icons/Cartoes.png",
                                      width: 50, height: 50),
                                ))),
                        SizedBox(height: 5),
                        Text("Cartões",
                            style: TextStyle(
                                color: gray,
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
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PixScreen()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: colors.main,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: Image.asset("assets/icons/Boleto.png",
                                      width: 50, height: 50),
                                ))),
                        SizedBox(height: 5),
                        Text("Boleto",
                            style: TextStyle(
                                color: gray,
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
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const InvestimentoScreen()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: colors.main,
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
                                color: gray,
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
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PixScreen()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: colors.main,
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
                                color: gray,
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
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PixScreen()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: colors.main,
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
                                color: gray,
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
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const EducationScreen()));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: colors.main,
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
                                color: gray,
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
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const PersonalizedScreen()));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: colors.main,
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
                                color: gray,
                                fontSize: 16.5,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]));
  }
}
