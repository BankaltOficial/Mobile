// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/pages/InvestimentoScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';

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
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: AppColors.theme,
      key: scaffoldKey,
      appBar: CustomAppBar(
        title: 'Resgate',
        scaffoldKey: scaffoldKey,
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const InvestimentoScreen()),
          );
        },
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  
                },
                child: Container(
                  margin: EdgeInsets.only(top: 20),
                  padding: EdgeInsets.all(16),
                  width: 300,
                  height: 100,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.main,
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
                          color: AppColors.invertMode
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
                    color: AppColors.invertMode
                  )),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  controller: _valorController,
                  validator: (value) {
                    final cleaned = value?.replaceAll(RegExp(r'[^0-9,]'), '');
                    if (cleaned == null || cleaned.isEmpty) {
                      return 'Digite um valor válido';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    final cleaned = value.replaceAll(RegExp(r'[A-Za-z]'), '');
                    if (value != cleaned) {
                      _valorController.text = cleaned;
                      _valorController.selection = TextSelection.fromPosition(
                        TextPosition(offset: cleaned.length),
                      );
                    }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  decoration: InputDecoration(
                    constraints: BoxConstraints(
                      minHeight: 40,
                      maxHeight: 40,
                      minWidth: 150,
                      maxWidth: 320,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 1, horizontal: 1),
                  ),
                  keyboardType: TextInputType.numberWithOptions(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.main,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(16),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                        fillColor: MaterialStateProperty.all(AppColors.invertModeMain),
                      ),
                      Text(
                        'Resgatar hoje',
                        style: TextStyle(fontSize: 16, color: AppColors.invertMode),
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
                        fillColor: MaterialStateProperty.all(AppColors.invertModeMain),
                      ),
                      Text(
                        'Agendar resgate',
                        style: TextStyle(fontSize: 16, color: AppColors.invertMode),
                      ),
                    ],
                  ),
                ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
