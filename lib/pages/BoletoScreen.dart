import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/BoletoCartaoScreen.dart';
import 'package:flutter_application_1/pages/InicialScreen.dart';
import 'package:flutter_application_1/pages/InvestimentoScreen.dart';
import 'package:flutter_application_1/pages/CardsScreen.dart';
import 'package:flutter_application_1/pages/PixScreen.dart';
import 'package:flutter_application_1/pages/WelcomeScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/ColorsProvider.dart';
import 'package:provider/provider.dart';

class BoletoScreen extends StatefulWidget {
  const BoletoScreen({super.key});

  @override
  State<BoletoScreen> createState() => _BoletoScreenState();
}

class _BoletoScreenState extends State<BoletoScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<ColorProvider>(context);
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          toolbarHeight: 100,
          backgroundColor: mainPurple,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.menu, color: mainWhite),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'bankalt',
                        style: TextStyle(
                          color: mainWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: mainWhite),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InicialScreen()),
                      );
                    },
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Boletos',
                        style: TextStyle(
                          color: mainWhite,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 48),
                ],
              ),
            ],
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: colors.main,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: mainWhite,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home_filled),
                title: Text('Página inicial'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InicialScreen()),
                  );
                },
              ),
              ListTile(
                leading: Image.asset("assets/icons/pixColorido.png",
                    width: 20, height: 20),
                title: Text('PIX'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const PixScreen()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.bar_chart),
                title: Text('Investimentos'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InvestimentoScreen()),
                  );
                },
              ),
              ListTile(
                leading: Image.asset("assets/icons/cartoesColorido.png",
                    height: 30, width: 30),
                title: Text('Cartões'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CardsScreen()),
                  );
                },
              ),
              Divider(
                color: Colors.grey,
                height: 1,
                thickness: 1,
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Configurações'),
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CardsScreen()),
                  );
                },
              ),
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BoletoCartaoScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                  color: mainPurple,
                  borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                    "Pagar com Pix",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: mainWhite),
                    textAlign: TextAlign.left,
                    ),
                    Text(
                    "Leia o QR code ou copie o codigo",
                    style: TextStyle(fontSize: 16, color: mainWhite),
                    textAlign: TextAlign.left,
                    )
                  ],
                  ),
                ),
                ),
              const SizedBox(height: 20),
              Divider(
                color: Colors.grey,
                height: 1,
                thickness: 1,
              ),
              const SizedBox(height: 20),
                InkWell(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const InicialScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                  color: mainPurple,
                  borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                  children: [
                    Text(
                    "Pagar fatura do cartão",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: mainWhite),
                    ),
                    Text(
                    "Libere o limite do seu cartão de credito",
                    style: TextStyle(fontSize: 16, color: mainWhite),
                    )
                  ],
                  ),
                ),
              ),
            ],
          )),
        ));
  }
}
