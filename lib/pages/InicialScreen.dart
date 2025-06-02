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
import 'package:flutter_application_1/pages/SplashScreen.dart';
import 'package:flutter_application_1/pages/TransferenciaScreen.dart';
import 'package:flutter_application_1/pages/WelcomeScreen.dart';
import 'package:flutter_application_1/pages/BoletoScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/Sessao.dart';
import 'package:flutter_application_1/service/ColorsProvider.dart';
import 'package:provider/provider.dart';

class InicialScreen extends StatefulWidget {
  const InicialScreen({super.key});

  @override
  State<InicialScreen> createState() => _InicialScreenState();
}

String txtSaldo = saldo.toStringAsFixed(2).replaceAll('.', ',');
Usuario usuario = Sessao.getUsuario() ?? Usuario('Usuário', 'CPF não encontrado', '', '', '', '', '');
String nome = usuario.nome;
String cpf = usuario.cpf;
double saldo = usuario.saldo;
Icon iconVisibility = Icon(Icons.visibility);

class _InicialScreenState extends State<InicialScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<ColorProvider>(context);

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
                            color: AppColors.secondary, fontWeight: FontWeight.bold))),
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
                                color: AppColors.mainGray,
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
                                color: AppColors.mainGray,
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
                                                const BoletoScreen()));
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
                                color: AppColors.mainGray,
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
                                color: AppColors.mainGray,
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
                                                const TransferenciaScreen()));
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
                                color: AppColors.mainGray,
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
                                                const EmprestimoScreen()));
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
                                color: AppColors.mainGray,
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
                                color: AppColors.mainGray,
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
                                color: AppColors.mainGray,
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
