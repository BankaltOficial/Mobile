// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/WelcomeScreen.dart';
import 'inicialScreen.dart';
import 'InvestirScreen.dart';

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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'R\$ 350,90',
                      style: TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => const WelcomeScreen(),));
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                  CircleAvatar(
                    backgroundColor: mainPurple,
                    radius: 45,
                    child: Icon(
                      Icons.attach_money,
                      color: mainWhite,
                      size: 45,
                      ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text("Investir", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    SizedBox(height: 10,),
                    Text("Aplique seu dinheiro de forma segura e prática,\npara alcançar seus objetivos financeiros.", style: TextStyle(fontSize: 14),)
                    ]
                    ,)
                ],),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => const WelcomeScreen(),));
              },
              child: Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                  CircleAvatar(
                    backgroundColor: mainPurple,
                    radius: 45,
                    child: Icon(
                      Icons.person,
                      color: mainWhite,
                      size: 50,
                      ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text("Perfil de investidor", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    SizedBox(height: 10,),
                    Text("Identifique seu perfil financeiro, recomendando \ninvestimentos alinhados ao seu nível de \nexperiência e tolerância ao risco.", style: TextStyle(fontSize: 14),)
                    ]
                    ,)
                ],),
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => const WelcomeScreen(),));
              },
              child: Container(
                padding: EdgeInsets.all(20),
                child: Row(
                  children: [
                  CircleAvatar(
                    backgroundColor: mainPurple,
                    radius: 45,
                    child: Icon(
                      Icons.hide_image,
                      color: mainWhite,
                      size: 45,
                      ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                    Text("Resgate", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
                    SizedBox(height: 10,),
                    Text("Retirar o valor investido de forma rápida e \nfácil, diretamente para a sua conta.", style: TextStyle(fontSize: 14),)
                    ]
                    ,)
                ],),
              ),
            ),
        ],
      ),
      )
    );
  }
}