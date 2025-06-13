import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/BoletoScreen.dart';
import 'package:flutter_application_1/service/Boleto.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/service/Usuario.dart';

class BoletoPixScreen extends StatelessWidget {
  const BoletoPixScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    TextEditingController boletoController = TextEditingController();
    int? codigo;
    Boleto? boletoEncontrado;
    double total = 0, valorPago = 0, valorRestante = 0;

    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
          title: 'Boleto - PIX',
          scaffoldKey: scaffoldKey,
          onBackPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const BoletoScreen()));
          }),
      drawer: const CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Escaneie o QR Code ou código',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'de barras para pagar boleto',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.main,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Divisor
            Container(
              height: 1,
              color: Colors.grey[300],
            ),

            const SizedBox(height: 40),

            // Seção de digitação
            Text(
              'Digite o código do boleto para pagar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.invertModeGray,
              ),
            ),

            const SizedBox(height: 16),

            // Campo de input
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.main,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: boletoController,
                decoration: const InputDecoration(
                  hintText: '',
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.mainGray,
                  ),
                ),
                style: TextStyle(color: AppColors.invertMode),
                keyboardType: TextInputType.number,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
              onPressed: () {
                final codigo = int.tryParse(boletoController.text);

                if (codigo == null) {
                  print('Código inválido. Digite um número.');
                  return;
                }

                boletoEncontrado = buscarBoleto(codigo);
                total = boletoEncontrado?.total ?? 0;
                valorPago = boletoEncontrado?.valorPago ?? 0; 
                valorRestante = total - valorPago;

                if (boletoEncontrado != null) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Boleto Encontrado'),
                        content: Text(
                          'Nome: ${boletoEncontrado!.nomePagante}\n'
                          'CPF: ${boletoEncontrado!.cpfPagante}\n'
                          'Código: ${boletoEncontrado!.codigo}\n'
                          'Valor Total: R\$ ${boletoEncontrado!.total.toStringAsFixed(2)}',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  print('Boleto não encontrado.');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.main,
              ),
              child: const Text(
                'Confirmar',
                style: TextStyle(color: AppColors.mainWhite),
              ),
            ),
              ],
            ),
            
            const Spacer(),
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.share,
                  color: AppColors.main,
                ),
                label: Text(
                  'Compartilhar',
                  style: TextStyle(
                    color: AppColors.main,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
