import 'package:flutter/material.dart';

class Welcomescreen extends StatefulWidget {
  const Welcomescreen({super.key});

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

Color colorbluetitle = Color(0xFF353DAB);

class _WelcomescreenState extends State<Welcomescreen> {
  
  final _formKey = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      toolbarHeight: 250,
        backgroundColor: colorbluetitle,
        title: Image.asset('assets/images/LogoTitulo.png', height: 250, width: 250,),
        centerTitle: true,
),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 50,),
              Text("Acesse sua conta", textAlign: TextAlign.center, ),
              SizedBox(height: 50,),
              Text("CPF", textAlign: TextAlign.left),
              SizedBox(height: 30,),
              TextFormField(
                validator: (value) {
                  if(value == null || value.isEmpty)
                  return 'Por favor, preencha todos os campos obrigatórios antes de continuar';
                },
                decoration: InputDecoration(
                  labelText: "CPF",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8)
                ),
              ),
              SizedBox(height: 50,),
              ElevatedButton(
              onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Carregando...')),
                    );
                  }
                },
                child: const Text('Entrar'),
              ),
            ],
        )),
      )
      );
  }
}