import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_application_1/inicialScreen.dart';
import 'package:flutter_application_1/colors.dart';
import 'package:flutter_application_1/colors_service.dart';
import 'package:flutter_application_1/colors_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'bankalt',
          style: TextStyle(
              color: AppColors.mainWhite, fontWeight: FontWeight.bold),
        ),
        backgroundColor: mainColor,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            const Text(
              "Escolha as cores do seu aplicativo",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.grayBlue),
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
                    await ColorService.saveColors(
                        mainColor, secondaryColor, tertiaryColor);

                    // Atualiza as cores ativas
                    setState(() {
                      AppColors.main = mainColor;
                      AppColors.secondary = secondaryColor;
                      AppColors.tertiary = tertiaryColor;
                    });

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const InicialScreen()),
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
                  onPressed: () async {
                    final provider =
                        Provider.of<ColorProvider>(context, listen: false);
                    provider.setColors(
                        mainColor, secondaryColor, tertiaryColor);
                    await ColorService.saveColors(
                        mainColor, secondaryColor, tertiaryColor);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const InicialScreen()),
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
          ],
        ),
      ),
    );
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
              border: Border.all(color: AppColors.grayBlue, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(title,
                    style: TextStyle(color: AppColors.grayBlue, fontSize: 18)),
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
