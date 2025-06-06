import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/pages/PixScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/Sessao.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share_plus/share_plus.dart';

class ReceberPixScreen extends StatefulWidget {
  const ReceberPixScreen({Key? key}) : super(key: key);

  @override
  State<ReceberPixScreen> createState() => _ReceberPixScreenState();
}

class _ReceberPixScreenState extends State<ReceberPixScreen> {
  Usuario usuario = Sessao.getUsuario()!;
  late String chavePix = usuario.chavePix;
  late String qrCodeData = usuario.chavePix;

  void _copiarChavePix() {
    Clipboard.setData(ClipboardData(text: chavePix));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Chave PIX copiada!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _compartilhar() {
    Share.share(
      'Minha chave PIX: $chavePix\n\nOu use o QR Code para fazer o pagamento!',
      subject: 'Chave PIX para pagamento',
    );
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
        appBar: CustomAppBar(
          title: 'Receber com PIX',
          scaffoldKey: scaffoldKey,
          onBackPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PixScreen()),
            );
          },
        ),
        drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            
            // Conteúdo principal
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  // Título
                  Text(
                    'Escaneie o QR Code sem\nvalor definido',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: AppColors.invertMode,
                      height: 1.3,
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // QR Code Container
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.mainWhite,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.mainBlack.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: qrCodeData,
                      version: QrVersions.auto,
                      size: 200.0,
                      backgroundColor: AppColors.mainWhite,
                      foregroundColor: AppColors.mainBlack,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Chave PIX Section
                  Text(
                    'Chave PIX',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.invertMode,
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Chave PIX Container
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.mainWhite,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            chavePix,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.mainBlack
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _copiarChavePix,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            child: Icon(
                              Icons.copy,
                              color: AppColors.main,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Botão Compartilhar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _compartilhar,
                      icon: Icon(Icons.share, color: AppColors.main),
                      label: Text(
                        'Compartilhar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.main,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainWhite,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: AppColors.main),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}