import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/Drawer.dart';

class BoletoCartaoScreen extends StatefulWidget {
  const BoletoCartaoScreen({super.key});

  @override
  State<BoletoCartaoScreen> createState() => _BoletoCartaoScreenState();
}

class _BoletoCartaoScreenState extends State<BoletoCartaoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Boleto Cartão'),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Boleto Cartão',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Action for the button
                },
                child: Text('Pagar Boleto'),
              ),
            ],
          )
        )
      )
    );
  }
}