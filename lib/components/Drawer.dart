import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/EmprestimoScreen.dart';
import 'package:flutter_application_1/pages/InicialScreen.dart';
import 'package:flutter_application_1/pages/InvestimentoScreen.dart';
import 'package:flutter_application_1/pages/CardsScreen.dart';
import 'package:flutter_application_1/pages/PersonalizedScreen.dart';
import 'package:flutter_application_1/pages/PixScreen.dart';
import 'package:flutter_application_1/pages/BoletoScreen.dart';
import 'package:flutter_application_1/pages/EducationScreen.dart';
import 'package:flutter_application_1/pages/TransferenciaScreen.dart';
import 'package:flutter_application_1/pages/WelcomeScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/ColorsService.dart';
import 'package:flutter_application_1/service/ColorsProvider.dart';
import 'package:flutter_application_1/service/Sessao.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<ColorProvider>(context);

    return Drawer(
      backgroundColor: AppColors.themeColor,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Column(
          children: [
            // Header com logo e nome
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 40, horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.main,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    child: Image.asset('assets/images/Logo.png',
                        height: 500, width: 500),
                  ),
                  SizedBox(width: 16),
                  Text(
                    'bankalt',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Menu items
            Expanded(
              child: Container(
                color: AppColors.themeColor,
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  children: [
                    _buildMenuItem(
                      context,
                      icon: Icons.home_outlined,
                      title: 'Página Inicial',
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const InicialScreen()));
                      },
                    ),

                    _buildMenuItem(
                      context,
                      icon: Icons.attach_money,
                      title: 'PIX',
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PixScreen()));
                      },
                    ),

                    _buildMenuItem(
                      context,
                      icon: Icons.trending_up,
                      title: 'Investimentos',
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const InvestimentoScreen()));
                      },
                    ),

                    _buildMenuItem(
                      context,
                      icon: Icons.credit_card,
                      title: 'Cartões',
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CardsScreen()));
                      },
                    ),

                    _buildMenuItem(
                      context,
                      icon: Icons.shopping_cart_outlined,
                      title: 'Boleto',
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const BoletoScreen()));
                      },
                    ),

                    _buildMenuItem(
                      context,
                      icon: Icons.account_balance,
                      title: 'Empréstimo',
                      onTap: () {
                        Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EmprestimoScreen()));
                      },
                    ),

                    _buildMenuItem(
                      context,
                      icon: Icons.sync_alt,
                      title: 'Transferência',
                      onTap: () {
                        Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TransferenciaScreen()));
                      },
                    ),

                    _buildMenuItem(
                      context,
                      icon: Icons.school_outlined,
                      title: 'Educação',
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const EducationScreen()));
                      },
                    ),

                    _buildMenuItem(
                      context,
                      icon: Icons.format_paint_rounded,
                      title: 'Personalizar',
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const PersonalizedScreen()));
                      },
                    ),

                    // Divisor
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      height: 1,
                      color: Colors.grey[300],
                    ),

                    _buildMenuItem(
                      context,
                      icon: Icons.settings_outlined,
                      title: 'Configurações',
                      onTap: () {
                        // Navigator para configurações
                      },
                    ),

                    _buildMenuItem(
                      context,
                      icon: Icons.person_outline,
                      title: 'Perfil',
                      onTap: () {
                        // Navigator para perfil
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Botão Logout
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: () async{
                  AppColors.main = AppColors.mainPurple;
                  AppColors.secondary = AppColors.mainBlue;
                  AppColors.tertiary = AppColors.mainGreen;
                  
                  final provider = Provider.of<ColorProvider>(context, listen: false);
                  provider.setColors(
                        AppColors.mainPurple, AppColors.mainBlue, AppColors.mainGreen);
                    await ColorService.saveColors(
                        AppColors.mainPurple, AppColors.mainBlue, AppColors.mainGreen);
                  provider.resetColors();
                  Sessao.limparUsuario();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const WelcomeScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.main,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout, color: Colors.white),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      leading: Icon(
        icon,
        color: AppColors.invertModeMain,
        size: 24,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.invertModeMain,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
