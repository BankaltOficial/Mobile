import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/BoletoCartaoScreen.dart';
import 'package:flutter_application_1/pages/BoletoPixScreen.dart';
import 'package:flutter_application_1/pages/InicialScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/ColorsProvider.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
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
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(
            title: 'Boleto',
            scaffoldKey: scaffoldKey,
            onBackPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InicialScreen()));
            }),
        drawer: const CustomDrawer(),
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
                        builder: (context) => const BoletoPixScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.main,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        "Pagar com Pix",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.mainWhite,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      Text(
                        "Leia o QR code ou copie o codigo",
                        style: TextStyle(fontSize: 16, color: AppColors.mainWhite,),
                        textAlign: TextAlign.left,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Divider(
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
                        builder: (context) => const BoletoCartaoScreen()),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: colors.main,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: const Column(
                    children: [
                      Text(
                        "Pagar fatura do cartão",
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.mainWhite),
                      ),
                      Text(
                        "Libere o limite do seu cartão de credito",
                        style: TextStyle(fontSize: 16, color: AppColors.mainWhite),
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
