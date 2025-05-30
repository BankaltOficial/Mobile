import 'package:flutter/material.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/ColorsProvider.dart';
import 'package:provider/provider.dart';

class SobreNosScreen extends StatelessWidget {
  const SobreNosScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Provider.of<ColorProvider>(context);

    return Scaffold(
      backgroundColor: colors.main,
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // Logo/Ícone centralizado
            Center(
              child: Image.asset('assets/images/Logo.png',
                  height: 100, width: 100),
            ),

            const SizedBox(height: 32),

            // Título principal
            const Center(
              child: Text(
                'Sobre nós',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 60),

            // Subtítulo
            const Text(
              'Conheça os integrantes do grupo',
              style: TextStyle(
                color: AppColors.mainYellow, // Amarelo
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 32),

            // Lista de integrantes
            _buildTeamMember(
              'Gabriel Augusto Pereira Maia',
              'Dev. Web e Designer',
              'assets/images/gabriel_augusto.png',
            ),

            const SizedBox(height: 24),

            _buildTeamMember(
              'Gabriel Henrique de Paula',
              'Documentação e Suporte',
              'assets/images/gabriel_henrique.png',
            ),

            const SizedBox(height: 24),

            _buildTeamMember(
              'Leonardo Pedroso Mendes',
              'Dev. Mobile e Designer',
              'assets/images/leonardo_pedroso.png',
            ),

            const SizedBox(height: 24),

            _buildTeamMember(
              'Samuel Lucas Bravo Colucci',
              'Gerente e Dev. Desktop',
              'assets/images/samuel_colucci.png',
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(String name, String role, String? imagePath) {
    return Row(
      children: [
        // Foto do membro
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white.withOpacity(0.1),
          ),
          child: imagePath != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 30,
                        ),
                      );
                    },
                  ),
                )
              : Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
        ),

        const SizedBox(width: 16),

        // Informações do membro
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                role,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
