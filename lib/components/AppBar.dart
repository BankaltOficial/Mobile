import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/InicialScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/ColorsProvider.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;
  final bool showMenuButton;
  final VoidCallback? onBackPressed;
  final VoidCallback? onMenuPressed;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.subtitle,
    this.showBackButton = true,
    this.showMenuButton = true,
    this.onBackPressed,
    this.onMenuPressed,
    this.scaffoldKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<ColorProvider>(context);
    final bool hasSubtitle = subtitle != null && subtitle!.isNotEmpty;

    return AppBar(
      toolbarHeight: hasSubtitle ? 120 : 100,
      backgroundColor: colors.main,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Column(
        children: [
          // Primeira linha - bankalt + menu
          Row(
            children: [
              // Menu button ou espaço vazio
              if (showMenuButton)
                IconButton(
                  icon: Icon(Icons.menu, color: AppColors.mainWhite),
                  onPressed: onMenuPressed ?? () {
                    scaffoldKey?.currentState?.openDrawer();
                  },
                )
              else
                SizedBox(width: 48),
              
              // Logo bankalt centralizado
              Expanded(
                child: Center(
                  child: Text(
                    'bankalt',
                    style: TextStyle(
                      color: AppColors.mainWhite,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              
              // Espaço para balancear o layout
              SizedBox(width: 48),
            ],
          ),
          
          // Segunda linha - título + botão voltar (se necessário)
          if (hasSubtitle || showBackButton)
            SizedBox(height: 8),
          
          if (hasSubtitle || showBackButton)
            Row(
              children: [
                // Back button ou espaço vazio
                if (showBackButton)
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: AppColors.mainWhite),
                    onPressed: onBackPressed ?? () {
                      Navigator.of(context).pop();
                    },
                  )
                else
                  SizedBox(width: 48),
                
                // Título/Subtítulo centralizado
                Expanded(
                  child: hasSubtitle 
                    ? Column(
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: AppColors.mainWhite,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            subtitle!,
                            style: TextStyle(
                              color: AppColors.mainWhite,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      )
                    : Center(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: AppColors.mainWhite,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                ),
                
                // Espaço para balancear o layout
                SizedBox(width: 48),
              ],
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize {
    final bool hasSubtitle = subtitle != null && subtitle!.isNotEmpty;
    return Size.fromHeight(hasSubtitle ? 120 : 100);
  }
}

// Versão simplificada para telas básicas
class SimpleCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const SimpleCustomAppBar({
    Key? key,
    required this.title,
    this.showBackButton = true,
    this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<ColorProvider>(context);

    return AppBar(
      backgroundColor: colors.main,
      elevation: 0,
      automaticallyImplyLeading: false,
      centerTitle: true,
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.mainWhite),
              onPressed: onBackPressed ?? () {
                Navigator.of(context).pop();
              },
            )
          : null,
      title: Text(
        title,
        style: const TextStyle(
          color: AppColors.mainWhite,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}