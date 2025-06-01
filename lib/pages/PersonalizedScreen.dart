// ignore_for_file: file_names, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_application_1/pages/inicialScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/ColorsService.dart';
import 'package:flutter_application_1/service/ColorsProvider.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:provider/provider.dart';

class PersonalizedScreen extends StatefulWidget {
  const PersonalizedScreen({super.key});

  @override
  State<PersonalizedScreen> createState() => _PersonalizedScreenState();
}

class _PersonalizedScreenState extends State<PersonalizedScreen> {
  Color mainColor = AppColors.main;
  Color secondaryColor = AppColors.secondary;
  Color tertiaryColor = AppColors.tertiary;
  bool isDarkMode = AppColors.isDarkMode;

  void pickColor(Color currentColor, ValueChanged<Color> onColorChanged) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Escolha uma cor'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: onColorChanged,
          ),
        ),
        actions: [
          TextButton(
            child: const Text('Fechar'),
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: CustomAppBar(
            title: 'Personalizar',
            scaffoldKey: _scaffoldKey,
            onBackPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const InicialScreen()));
            }),
        drawer: CustomDrawer(),
        backgroundColor: AppColors.themeColor,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                const Text(
                  "Escolha as cores do seu aplicativo",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.mainGray),
                ),
                const SizedBox(height: 30),
                buildColorSelector(
                  title: "Principal",
                  color: mainColor,
                  onTap: () => pickColor(mainColor, (color) {
                    setState(() => mainColor = color);
                  }),
                ),
                const SizedBox(height: 20),
                buildColorSelector(
                  title: "Secundária",
                  color: secondaryColor,
                  onTap: () => pickColor(secondaryColor, (color) {
                    setState(() => secondaryColor = color);
                  }),
                ),
                const SizedBox(height: 20),
                buildColorSelector(
                  title: "Terciária",
                  color: tertiaryColor,
                  onTap: () => pickColor(tertiaryColor, (color) {
                    setState(() => tertiaryColor = color);
                  }),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final provider =
                            Provider.of<ColorProvider>(context, listen: false);
                        provider.setColors(
                            mainColor, secondaryColor, tertiaryColor);
                        provider.setTheme(isDarkMode);
                        ColorService.setTheme(isDarkMode);
                        await ColorService.saveColors(
                            mainColor, secondaryColor, tertiaryColor);
                        setState(() {
                          AppColors.isDarkMode = isDarkMode;
                          AppColors.main = mainColor;
                          AppColors.secondary = secondaryColor;
                          AppColors.tertiary = tertiaryColor;
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const InicialScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: mainColor,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32),
                      ),
                      child: const Text("Continuar",
                          style: TextStyle(fontSize: 15, color: Colors.white)),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const InicialScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32),
                      ),
                      child: const Text("Cancelar",
                          style: TextStyle(fontSize: 15, color: Colors.white)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  "As cores escolhidas serão aplicadas em todo o aplicativo.",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: AppColors.mainGray),
                ),
                const SizedBox(height: 20),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Icon(Icons.palette,
                      color: AppColors.mainGray, size: 28),
                  const SizedBox(width: 10),
                  Text(
                    isDarkMode ? "Modo Escuro" : "Modo Claro",
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.mainGray,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Switch(
                    value: isDarkMode,
                    activeColor: AppColors.secondary,
                    inactiveThumbColor: AppColors.main,
                    onChanged: (value) {
                      setState(() {
                        isDarkMode = value;
                      });

                      if (isDarkMode) {
                        ColorService.setTheme(isDarkMode);
                      } else{
                        ColorService.setTheme(isDarkMode);
                      }
                    },
                  ),
                ]),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ));
  }

  Widget buildColorSelector({
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 150,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.mainGray, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(title,
                    style: TextStyle(color: AppColors.mainGray, fontSize: 18)),
                const SizedBox(height: 10),
                Text(
                  '#${color.value.toRadixString(16).substring(2).toUpperCase()}',
                  style: TextStyle(
                      color: color, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 50),
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}
