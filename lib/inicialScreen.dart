// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/PersonalizedScreen.dart';
import 'package:flutter_application_1/PixScreen.dart';

class InicialScreen extends StatefulWidget {
  const InicialScreen({super.key});

  @override
  State<InicialScreen> createState() => _InicialScreenState();
}

Color mainBlue = const Color(0xFF353DAB);
Color mainBlueWeak = const Color.fromARGB(51, 53, 61, 171);
Color mainWhite = const Color(0xFFFFFFFF);
Color gray = const Color(0xFF828282);
Color mainYellow = const Color(0xFFFFC700);
Color mainLightPurple = const Color(0xFFCBCBE5);

class _InicialScreenState extends State<InicialScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'bankalt',
          style: TextStyle(color: mainWhite, fontWeight: FontWeight.bold),
        ),
        backgroundColor: mainBlue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Olá, Igor Suracci', style: TextStyle(fontSize: 27)),
                CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/images/IgorSuracci.png'),
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
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Seu saldo', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          IconButton(onPressed: (){
                            
                          }, icon: Icon(Icons.visibility, color: mainBlue, size: 25)),
                        ],
                      ),
                      Text('R\$ 28.567,90', style: TextStyle(fontSize: 24)),
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
                child: Text("Ver extrato >", style: TextStyle(fontWeight: FontWeight.bold))),
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
                                  backgroundColor: mainBlue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
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
                                            const PixScreen()));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: mainBlue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
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
                                  backgroundColor: mainBlue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
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
                                            const PixScreen()));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: mainBlue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
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
                                  backgroundColor: mainBlue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
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
                                  backgroundColor: mainBlue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
                              child: Image.asset("assets/icons/Emprestimo.png",
                                  width: 50, height: 50),
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
                                    builder: (context) => const PixScreen()));
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: mainBlue,
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
                                  backgroundColor: mainBlue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
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
    );
  }

  Widget _buildButton(String text, IconData icon) {
    return ElevatedButton(
      onPressed: () {}, // Adicione a funcionalidade aqui
      child: Column(
        children: [
          Icon(icon),
          Text(text),
        ],
      ),
    );
  }
}
