import 'package:flutter/material.dart';

class Welcomescreen2 extends StatefulWidget {
  const Welcomescreen2({super.key});

  @override
  State<Welcomescreen2> createState() => _Welcomescreen2State();
}

Color colorbluetitle = Color(0xFF353DAB);

class _Welcomescreen2State extends State<Welcomescreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      toolbarHeight: 250,
        backgroundColor: colorbluetitle,
        title: Image.asset('assets/images/LogoTitulo.png', height: 30, width: 30,),
        centerTitle: true,
),
      body: Center(child: Column(children: [
            Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text("Acesse sua conta"),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 30),
            child: Text("Item 2"),
          ),
          Text("Item 3"),
      ],),),
      );
  }
}