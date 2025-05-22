// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'inicialScreen.dart';

class InvestimentoScreen extends StatefulWidget {
  const InvestimentoScreen({super.key});

  @override
  State<InvestimentoScreen> createState() => _InvestimentoScreenState();
}

class _InvestimentoScreenState extends State<InvestimentoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: mainPurple,
        elevation: 0,
        title:Column(children: [ 
          Row(  
          children: [
          IconButton(onPressed: () {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => const InicialScreen(),));
          }, icon: Icon(
            Icons.menu,
            color: mainWhite,
            )
          ),
            Expanded(child: Center(child:
            Text(
            'bankalt',
            style: TextStyle(
            color: mainWhite,
            fontWeight: FontWeight.bold
          ),
        ),),),
        ],
        ),
        SizedBox(height:15),
        Row(children: [ 
          IconButton(onPressed: () {
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => const InicialScreen(),));
          }, icon: Icon(
            Icons.arrow_back,
            color: mainWhite,
            )
          ),
          Expanded(child: Center(child:
          Text(
          'Investimentos',
          style: TextStyle(color: mainWhite),
        ),),),
         ],)
        ]
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: mainPurpleWeak,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Total investido',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'R\$ 350,90',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      )
    );
  }
}