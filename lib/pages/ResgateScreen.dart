// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/CardsScreen.dart';
import 'package:flutter_application_1/pages/InicialScreen.dart';
import 'package:flutter_application_1/pages/InvestimentoScreen.dart';
import 'package:flutter_application_1/pages/PixScreen.dart';
import 'package:flutter_application_1/service/ColorsProvider.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:provider/provider.dart';

class ResgateScreen extends StatefulWidget {
  const ResgateScreen({super.key});

  @override
  State<ResgateScreen> createState() => _ResgateScreenState();
}

class _ResgateScreenState extends State<ResgateScreen> {
  String? _resgateOption;

  final MoneyMaskedTextController _valorController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    initialValue: 0.0,
    leftSymbol: 'R\$ ',
    );

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<ColorProvider>(context);
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                            builder: (context) => const InvestimentoScreen()),
                      );
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Resgate',
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
                color: gray,
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
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InvestimentoScreen()),
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.all(16),
                  width: 300,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: mainPurple,
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'CDB Meu porquinho',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                ),
                ),
                ),
                SizedBox(
                  height: 20,
                ),

                Text("Quanto você quer regatar?",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),

                SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    controller: _valorController,
                    onTap: () {
                    },
                    decoration: InputDecoration(
                      constraints: BoxConstraints(
                        minHeight: 40,
                        maxHeight: 40,
                        minWidth: 150,
                        maxWidth: 150,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: mainPurple,
                    ),
                  ),
                ),
                Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Row(
                  children: [
                    Radio<String>(
                      value: 'hoje',
                      groupValue: _resgateOption,
                      onChanged: (value) {
                        setState(() {
                          _resgateOption = value!;
                        });
                      },
                    ),
                    Text(
                      'Resgatar hoje',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(width: 20),
                Row(
                children: [
                  Radio<String>(
                    value: 'agendar',
                    groupValue: _resgateOption,
                    onChanged: (value) {
                      setState(() {
                        _resgateOption = value!;
                      });
                    },
                  ),
                  Text(
                    'Agendar resgate',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}