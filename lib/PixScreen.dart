// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class PixScreen extends StatefulWidget {
  const PixScreen({super.key});

  @override
  State<PixScreen> createState() => _PixScreenState();
}

class _PixScreenState extends State<PixScreen> {
  
Color mainBlue= const Color(0xFF353DAB);
Color mainBlueWeak = const Color.fromARGB(51, 53, 61, 171);
Color mainWhite = const Color(0xFFFFFFFF);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("PIX", style: TextStyle(color: mainWhite),),
        centerTitle: true,
        backgroundColor: mainBlue,
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: Column(
          children: [
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,  
        children: [
          Expanded(
            flex: 1,
            child: ElevatedButton(onPressed: () {
        },
        style: ElevatedButton.styleFrom(
          side: BorderSide(color: mainBlue, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          )
        ),
         child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.account_balance_wallet_outlined, size: 60, color: mainBlue),
            SizedBox(height: 10),
            Text("Pagar", style: TextStyle(fontSize: 20, color: mainBlue)),
          ],
        )
        ),
        ),
        SizedBox(width: 10),
        Expanded(
           flex: 1,
          child: ElevatedButton(onPressed: () {
        }, 
        style: ElevatedButton.styleFrom(
          side: BorderSide(color: mainBlue, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.qr_code, size: 60, color: mainBlue),
            SizedBox(height: 10),
            Text("Receber", style: TextStyle(fontSize: 20, color: mainBlue)),
          ],
        )
        )
        )
      ]
      ),
      SizedBox(height: 10),
      ElevatedButton(onPressed:() {
      }, 
      style: ElevatedButton.styleFrom(
          side: BorderSide(color: mainBlue, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          )
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Text("Minhas chaves", style: TextStyle(fontSize: 20, color: mainBlue)),
        Icon(Icons.key_rounded, size: 60, color: mainBlue),
      ],)),
      SizedBox(height: 30,),
      Text("Registre sua chave", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
      Text("Não tem uma chave ainda?"),
      Text("Cadastre agora!"),
      SizedBox(height: 30),
      ElevatedButton(onPressed: () {
      }, 
      style: ElevatedButton.styleFrom(
        backgroundColor: mainBlue
      ),
      child: Text("Cadastrar", style: TextStyle(color: mainWhite),))
      ],),
      )
    );
  }
}