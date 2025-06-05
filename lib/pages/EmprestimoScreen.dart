// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/pages/CardsScreen.dart';
import 'package:flutter_application_1/pages/InicialScreen.dart';
import 'package:flutter_application_1/pages/InvestimentoScreen.dart';
import 'package:flutter_application_1/pages/PixScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';

class EmprestimoScreen extends StatefulWidget {
  const EmprestimoScreen({super.key});

  @override
  State<EmprestimoScreen> createState() => _EmprestimoScreenState();
}

class _EmprestimoScreenState extends State<EmprestimoScreen> {
  double loanAmount = 15000.00;
  double interestRate = 7.97;
  int installments = 3;
  double installmentValue = 39.850;
  String paymentDay = "10";

  @override
  Widget build(BuildContext context) {
    double totalAmount = loanAmount + (loanAmount * interestRate / 100);
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        title: 'Empréstimo',
        scaffoldKey: scaffoldKey,
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const InicialScreen()),
          );
        },
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
            
              Center(
                child: Column(
                  children: [
                    Text(
                      'R\$ ${loanAmount.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: AppColors.main,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.main,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Simular empréstimo',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.invertModeGray,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 30),
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tipo de empréstimo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.invertMode,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Pessoal',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.mainGray,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Taxa = ${interestRate.toStringAsFixed(2)}%',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.main,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              SizedBox(height: 25),
              
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.main,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'R\$119.550,00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 25),
              
              Text(
                'Número de parcelas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.invertMode,
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '3x de R\$39.850',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.mainGray,
                  ),
                ),
              ),
              
              SizedBox(height: 25),
              
              Text(
                'Datas para parcelas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.invertMode,
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Todo mês dia $paymentDay',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.mainGray,
                  ),
                ),
              ),
              
              SizedBox(height: 40),
              
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirmar Empréstimo'),
                          content: Text('Deseja confirmar o empréstimo de R\$ ${loanAmount.toStringAsFixed(2).replaceAll('.', ',')}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Empréstimo solicitado com sucesso!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.main,
                              ),
                              child: Text('Confirmar', style: TextStyle(color: Colors.white),),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.main,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Confirmar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
