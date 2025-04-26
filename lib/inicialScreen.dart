// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class InicialScreen extends StatefulWidget {
  const InicialScreen({super.key});

  @override
  State<InicialScreen> createState() => _InicialScreenState();
}

Color mainBlue= const Color(0xFF353DAB);
Color mainBlueWeak = const Color.fromARGB(51, 53, 61, 171);
Color mainWhite = const Color(0xFFFFFFFF);

class _InicialScreenState extends State<InicialScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('bankalt', style: TextStyle(color: mainWhite),),
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
              onPressed: () {}, // Adicione a funcionalidade aqui
              child: Text('Ver extrato >'),
            ),
            SizedBox(height: 16),
            // Adicione os outros botões aqui usando Row ou GridView
            // Exemplo:
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildButton('PIX', Icons.swap_horiz),
                _buildButton('Cartões', Icons.credit_card),
                _buildButton('Boleto', Icons.receipt),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildButton('Investimento', Icons.bar_chart),
                _buildButton('Transferência', Icons.compare_arrows),
                _buildButton('Empréstimo', Icons.monetization_on),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildButton('Educação', Icons.school),
                _buildButton('Personalizar', Icons.settings),
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