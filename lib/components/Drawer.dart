import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/InicialScreen.dart';
import 'package:flutter_application_1/pages/InvestimentoScreen.dart';
import 'package:flutter_application_1/pages/CardsScreen.dart';
import 'package:flutter_application_1/pages/PixScreen.dart';
import 'package:flutter_application_1/pages/WelcomeScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/ColorsProvider.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {

    final colors = Provider.of<ColorProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: colors.main,
            ),
            child: const Text(
              'Menu',
              style: TextStyle(
                color: AppColors.mainWhite,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_filled),
            title: const Text('Página inicial'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const InicialScreen()));
            },
          ),
          ListTile(
            leading: Image.asset("assets/icons/pixColorido.png", width: 20, height: 20),
            title: const Text('PIX'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PixScreen()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Investimentos'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const InvestimentoScreen()));
            },
          ),
          ListTile(
            leading: Image.asset("assets/icons/cartoesColorido.png", height: 30, width: 30),
            title: const Text('Cartões'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CardsScreen()));
            },
          ),
          const Divider(
            color: Colors.grey,
            height: 1,
            thickness: 1,
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CardsScreen()));
            },
          ),
        ],
      ),
    );
  }
}
