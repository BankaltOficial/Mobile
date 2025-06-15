// ignore_for_file: unused_local_variable, file_names, use_key_in_widget_constructors, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/pages/InicialScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/ColorsProvider.dart';
import 'package:provider/provider.dart';

class ConfiguracaoScreen extends StatefulWidget {
  @override
  _ConfiguracaoScreenState createState() => _ConfiguracaoScreenState();
}

class _ConfiguracaoScreenState extends State<ConfiguracaoScreen> {
  int selectedColorIndex = 0;
  
  final List<Color> themeColors = [
    AppColors.main,
    AppColors.secondary,
    AppColors.tertiary,
  ];

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    final colors = Provider.of<ColorProvider>(context);
    
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.theme,
      appBar: CustomAppBar(
          title: 'Configurações',
          scaffoldKey: _scaffoldKey,
          onBackPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const InicialScreen(),
              ),
            );
          }),
          drawer: CustomDrawer(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
            alignment: Alignment.center,
            child: Text(
              'Configurações de @suracci',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.invertMode,
              ),
            ),
            ),
            SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.mainWhite,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.invertModeGray, width: 1),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Sua foto',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.main,
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              'assets/user_photo.jpg', // Substitua pelo caminho da sua imagem
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: Icon(
                                    Icons.person,
                                    size: 30,
                                    color: Colors.grey.shade600,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.mainWhite,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.invertModeGray, width: 1),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Cores',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.main,
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: List.generate(3, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedColorIndex = index;
                                });
                              },
                              child: Container(
                                width: 32,
                                height: 32,
                                decoration: BoxDecoration(
                                  color: themeColors[index],
                                  shape: BoxShape.circle,
                                  border: selectedColorIndex == index
                                      ? Border.all(color: AppColors.mainBlack, width: 2)
                                      : null,
                                ),
                              ),
                            );
                          }),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Light Mode',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.invertModeGray, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tipo de Conta',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.main,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'BÁSICO',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.main,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Conta Básica serve aos nossos clientes as simples funcionalidades do sistema.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.mainWhite,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.invertModeGray, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Investimentos',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.main,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'CONSERVADOR',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.main,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Você é cauteloso com seu dinheiro, busca sempre pesquisar muito bem antes de investir, para garantir chances melhores.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}