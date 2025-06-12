import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/pages/WelcomeScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';

class DescricaoScreen extends StatelessWidget {
  const DescricaoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.main,
      appBar: SimpleCustomAppBar(
        title: 'Descrição do Projeto',
        showBackButton: true,
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const WelcomeScreen(),
            ),
          );
        },
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 150,
                height: 150,
                child: Image.asset('assets/images/Logo.png',
                    height: 150, width: 150),
              ),
            ),

            const SizedBox(height: 32),

            // Título principal
            const Center(
              child: Text(
                'Bem Vindo ao BankAlt!',
                style: TextStyle(
                  color: AppColors.mainWhite,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Primeiro parágrafo
            RichText(
              text: const TextSpan(
                style: TextStyle(
                    color: AppColors.mainWhite,
                    fontSize: 16,
                    height: 1.5,
                    fontFamily: 'Poppins'),
                children: [
                  TextSpan(
                    text:
                        'O nosso projeto propõe a criação de um banco inovador que tem o intuito de ensinar ',
                  ),
                  TextSpan(
                    text: 'educação financeira',
                    style: TextStyle(
                      color: AppColors.mainYellow, // Amarelo
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        ', bem como o auxílio na administração monetária familiar em casos no qual o diagnóstico de ',
                  ),
                  TextSpan(
                    text: 'Transtorno do Espectro Autista (TEA)',
                    style: TextStyle(
                      color: AppColors.mainYellow, // Amarelo
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' está presente.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Segundo parágrafo
            RichText(
              text: const TextSpan(
                style: TextStyle(
                    color: AppColors.mainWhite,
                    fontSize: 16,
                    height: 1.5,
                    fontFamily: 'Poppins'),
                children: [
                  TextSpan(
                    text: 'O ensino proporcionado em nosso projeto é ',
                  ),
                  TextSpan(
                    text: 'dinâmico',
                    style: TextStyle(
                      color: AppColors.mainYellow, // Amarelo
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' e procura atender a ',
                  ),
                  TextSpan(
                    text: 'necessidade de todos',
                    style: TextStyle(
                      color: AppColors.mainYellow, // Amarelo
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ', incluindo o público portador de ',
                  ),
                  TextSpan(
                    text: 'TEA',
                    style: TextStyle(
                      color: AppColors.mainYellow, // Amarelo
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '. Para isso, serão disponibilizadas ',
                  ),
                  TextSpan(
                    text: 'aulas',
                    style: TextStyle(
                      color: AppColors.mainYellow, // Amarelo
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: ' por tópico que terão uma ',
                  ),
                  TextSpan(
                    text:
                        'linguagem menos rebuscada e fácil para o melhor entendimento',
                    style: TextStyle(
                      color: AppColors.mainYellow, // Amarelo
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: '. Além disso, para cada aula uma opção em ',
                  ),
                  TextSpan(
                    text: 'áudio',
                    style: TextStyle(
                      color: AppColors.mainYellow, // Amarelo
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' estará disponível aos que preferirem, disponibilidade essa que pode servir como uma ',
                  ),
                  TextSpan(
                    text: 'outra alternativa',
                    style: TextStyle(
                      color: AppColors.mainYellow, // Amarelo
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' de tornar o estudo mais palpável e menos cansativo.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Terceiro parágrafo
            RichText(
              text: const TextSpan(
                style: TextStyle(
                    color: AppColors.mainWhite,
                    fontSize: 16,
                    height: 1.5,
                    fontFamily: 'Poppins'),
                children: [
                  TextSpan(
                    text: 'A ',
                  ),
                  TextSpan(
                    text: 'funcionalidade de investimentos',
                    style: TextStyle(
                      color: AppColors.mainYellow, // Amarelo
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        ' busca colocar tudo que o cliente aprendeu com as aulas em prática, definindo o ',
                  ),
                  TextSpan(
                    text: 'perfil de investidor',
                    style: TextStyle(
                      color: AppColors.mainYellow, // Amarelo
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        ', ajudando nas primeiras aplicações e etc. Com base na nossa proposta, o intuito é que todos consigam realizar seus ',
                  ),
                  TextSpan(
                    text: 'investimentos da melhor forma possível',
                    style: TextStyle(
                      color: AppColors.mainYellow, // Amarelo
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        ', tendo consciência dos prováveis riscos que sofrerá durante o processo.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
