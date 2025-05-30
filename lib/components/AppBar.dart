// ignore_for_file: unused_import, file_names

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/InicialScreen.dart';
import 'package:flutter_application_1/pages/InvestimentoScreen.dart';
import 'package:flutter_application_1/pages/CardsScreen.dart';
import 'package:flutter_application_1/pages/PixScreen.dart';
import 'package:flutter_application_1/pages/WelcomeScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/ColorsProvider.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({super.key, required String title});

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<ColorProvider>(context);
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return AppBar(
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
                    'Investimentos',
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
    );
  }
}
