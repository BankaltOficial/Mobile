// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/PersonalizedScreen.dart';
import 'package:flutter_application_1/PixScreen.dart';

class InicialScreen extends StatefulWidget {
  const InicialScreen({super.key});

  @override
  State<InicialScreen> createState() => _InicialScreenState();
}

Color mainBlue= const Color(0xFF353DAB);
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
        title: Text('bankalt', style: TextStyle(color: mainWhite, fontWeight: FontWeight.bold),),
        backgroundColor: mainBlue,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Text('Olá, Igor Suracci', style: TextStyle(fontSize: 18)),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/IgorSuracci.png'), // Substitua pela URL da imagem
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Saldo', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('R\$ 28.567,90', style: TextStyle(fontSize: 24)),
                ],
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              child: Text('Ver extrato >'),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PixScreen())
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBlue,

                ),
                child: Column( children: [
                  Image.asset("assets/icons/Pix.png", width: 40, height: 40),
                  Text("PIX", style: TextStyle(color: mainWhite)),
                ],
                )),

                ElevatedButton(onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PixScreen())
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
                child: Column( children: [
                  Icon(Icons.add_card, size: 40, color: mainWhite,),
                  Text("Cartões", style: TextStyle(color: mainWhite),),
                ],
                )),

                ElevatedButton(onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PixScreen())
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBlue,

                ),
                child: Column( children: [
                  Image.asset("assets/icons/Pix.png", width: 40, height: 40),
                  Text("PIX", style: TextStyle(color: mainWhite)),
                ],
                )),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PixScreen())
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBlue,

                ),
                child: Column( children: [
                  Image.asset("assets/icons/Pix.png", width: 40, height: 40),
                  Text("PIX"),
                ],
                )),

                ElevatedButton(onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PixScreen())
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBlue,

                ),
                child: Column( children: [
                  Image.asset("assets/icons/Pix.png", width: 40, height: 40),
                  Text("PIX"),
                ],
                )),

                ElevatedButton(onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PixScreen())
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBlue,

                ),
                child: Column( children: [
                  Image.asset("assets/icons/Pix.png", width: 40, height: 40),
                  Text("PIX"),
                ],
                ))
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PixScreen())
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBlue,

                ),
                child: Column( children: [
                  Image.asset("assets/icons/Pix.png", width: 40, height: 40),
                  Text("PIX"),
                ],
                )),
                ElevatedButton(onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PersonalizedScreen())
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainBlue,

                ),
                child: Column( children: [
                  Image.asset("assets/icons/Pix.png", width: 40, height: 40),
                  Text("Personalizar", style: TextStyle(color: mainWhite)),
                ],
                ))
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