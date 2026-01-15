// ignore_for_file: file_names, prefer_const_constructors, duplicate_ignore, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/components/ProfileAnalyzer.dart';
import 'package:flutter_application_1/pages/InvestimentoScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';


class PerfilInvestidorScreen extends StatefulWidget {
  const PerfilInvestidorScreen({super.key});

  @override
  State<PerfilInvestidorScreen> createState() => _PerfilInvestidorScreenState();
}

class _PerfilInvestidorScreenState extends State<PerfilInvestidorScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final List<String> perfis = ['CONSERVADOR', 'MODERADO', 'ARROJADO'];
  int perfilIndex = 2;
  
  String? selectedObjective;
  String? selectedTimeHorizon;
  String? selectedLoss;
  String? selectedExperience;
  String? selectedGain;

  void _mostrarSeletorPerfil() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: perfis.asMap().entries.map((entry) {
            int index = entry.key;
            String perfil = entry.value;
            return ListTile(
              leading: Icon(
                perfilIndex == index ? Icons.check_circle : Icons.circle_outlined,
                color: perfilIndex == index ? Colors.green : Colors.grey,
              ),
              title: Text(perfil),
              onTap: () {
                setState(() {
                  perfilIndex = index;
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  void _limparCampos() {
    setState(() {
      selectedObjective = null;
      selectedTimeHorizon = null;
      selectedLoss = null;
      selectedExperience = null;
      selectedGain = null;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Campos limpos com sucesso!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _analisarPerfil() {
    if (selectedObjective == null || 
        selectedTimeHorizon == null || 
        selectedLoss == null || 
        selectedExperience == null || 
        selectedGain == null) {
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, preencha todos os campos antes de analisar!'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
      return;
    }

    String perfilCalculado = InvestorProfileAnalyzer.calculateProfile(
      objective: selectedObjective,
      timeHorizon: selectedTimeHorizon,
      riskTolerance: selectedLoss,
      experience: selectedExperience,
      liquidity: selectedGain,
    );

    setState(() {
      perfilIndex = perfis.indexOf(perfilCalculado);
    });

    _mostrarResultadoAnalise(perfilCalculado);
  }

  void _mostrarResultadoAnalise(String perfil) {
    String descricao = InvestorProfileAnalyzer.getProfileDescription(perfil);
    List<String> sugestoes = InvestorProfileAnalyzer.getInvestmentSuggestions(perfil);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.analytics, color: AppColors.main),
              SizedBox(width: 8),
              Text('Análise Completa'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Seu perfil: $perfil',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.main,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Descrição:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(descricao),
                SizedBox(height: 16),
                Text(
                  'Investimentos recomendados:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                ...sugestoes.map((sugestao) => Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('• ', style: TextStyle(color: AppColors.main, fontWeight: FontWeight.bold)),
                      Expanded(child: Text(sugestao)),
                    ],
                  ),
                ))
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Fechar', style: TextStyle(color: AppColors.main)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRadioOption(String title, String? groupValue, Function(String?) onChanged) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.isDarkMode ? AppColors.darkMode : AppColors.mainWhite,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.isDarkMode ? AppColors.mainGray : AppColors.main),
      ),
      child: RadioListTile<String>(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: AppColors.isDarkMode ? AppColors.mainWhite : AppColors.mainBlack,
          ),
        ),
        activeColor: groupValue == title
            ? (AppColors.isDarkMode ? AppColors.mainWhite : AppColors.main)
            : (AppColors.isDarkMode ? AppColors.mainGray : AppColors.mainGrayBlue),
        fillColor: MaterialStateProperty.resolveWith<Color>((states) {
          if (states.contains(MaterialState.selected)) {
            return AppColors.main;
          }
          return AppColors.isDarkMode ? AppColors.mainGray : AppColors.mainGrayBlue;
        }),
        value: title,
        groupValue: groupValue,
        onChanged: onChanged,
        
        controlAffinity: ListTileControlAffinity.leading,
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.theme,
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Perfil de Investidor',
        scaffoldKey: _scaffoldKey,
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const InvestimentoScreen()),
          );
        },
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(25),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Descubra o seu perfil de investidor",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.invertMode,),
                ),
                SizedBox(height: 10),
                Text(
                  "O seu perfil atualmente está ativo como ${perfis[perfilIndex].toLowerCase()}. Você pode mudar o tipo de investidor abaixo:",
                style: TextStyle(color: AppColors.invertMode),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  height: 70,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.mainGray,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(Icons.person, color: AppColors.main, size: 40,),
                      SizedBox(width: 8),
                      Text.rich(
                        TextSpan(
                          text: 'O seu perfil é ',
                          style: TextStyle(fontSize: 19, color: AppColors.invertMode),
                          children: [
                            TextSpan(
                              text: perfis[perfilIndex],
                              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.invertMode, fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 30),
                      GestureDetector(
                        onTap: _mostrarSeletorPerfil,
                        child: Text(
                          'Alterar',
                          style: TextStyle(
                            color: AppColors.main,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(
                      color: AppColors.mainGrayBlue,
                      thickness: 0.5,
                      height: 1,
                    ),
                  ),

                Text(
                  'Qual é o seu objetivo ao investir?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.invertMode
                  ),
                ),
                SizedBox(height: 16),
                
                _buildRadioOption('Aposentadoria', selectedObjective, (value) {
                  setState(() {
                    selectedObjective = value;
                  });
                }),
                _buildRadioOption('Compra de imóvel', selectedObjective, (value) {
                  setState(() {
                    selectedObjective = value;
                  });
                }),
                _buildRadioOption('Geração de renda', selectedObjective, (value) {
                  setState(() {
                    selectedObjective = value;
                  });
                }),

                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(
                      color: AppColors.mainGrayBlue,
                      thickness: 0.5,
                      height: 1,
                    ),
                  ),

                Text(
                  'Qual é o seu horizonte de investimento?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.invertMode
                  ),
                ),
                SizedBox(height: 16),
                
                _buildRadioOption('Curto prazo', selectedTimeHorizon, (value) {
                  setState(() {
                    selectedTimeHorizon = value;
                  });
                }),
                _buildRadioOption('Médio prazo', selectedTimeHorizon, (value) {
                  setState(() {
                    selectedTimeHorizon = value;
                  });
                }),
                _buildRadioOption('Longo prazo', selectedTimeHorizon, (value) {
                  setState(() {
                    selectedTimeHorizon = value;
                  });
                }),

                Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(
                      color: AppColors.mainGrayBlue,
                      thickness: 0.5,
                      height: 1,
                    ),
                  ),

                Text(
                  'Qual é a sua tolerância quanta a perda de renda?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.invertMode
                  ),
                ),
                SizedBox(height: 16),

                _buildRadioOption('Baixa', selectedLoss, (value) {
                  setState(() {
                    selectedLoss = value;
                  });
                }),
                _buildRadioOption('Moderada', selectedLoss, (value) {
                  setState(() {
                    selectedLoss = value;
                  });
                }),
                _buildRadioOption('Alta', selectedLoss, (value) {
                  setState(() {
                    selectedLoss = value;
                  });
                }),

                Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(
                      color: AppColors.mainGrayBlue,
                      thickness: 0.5,
                      height: 1,
                    ),
                  ),

                  Text(
                  'Qual é a sua experiência com investimentos?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.invertMode
                  ),
                ),
                SizedBox(height: 16),

                _buildRadioOption('Iniciante', selectedExperience, (value) {
                  setState(() {
                    selectedExperience = value;
                  });
                }),
                _buildRadioOption('Intermediário', selectedExperience, (value) {
                  setState(() {
                    selectedExperience = value;
                  });
                }),
                _buildRadioOption('Avançado', selectedExperience, (value) {
                  setState(() {
                    selectedExperience = value;
                  });
                }),

                Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Divider(
                      color: AppColors.mainGrayBlue,
                      thickness: 0.5,
                      height: 1,
                    ),
                  ),

                Text(
                  'Quanta liquidez você precisa dos seus investimentos?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.invertMode,
                  ),
                ),
                SizedBox(height: 16), 

                _buildRadioOption('Pode manter investimentos por longos períodos', selectedGain, (value) {
                  setState(() {
                    selectedGain = value;
                  });
                }),
                _buildRadioOption('Precisa de acesso rápido ao capital', selectedGain, (value) {
                  setState(() {
                    selectedGain = value;
                  });
                }),

                // Adicionando os botões no final
                SizedBox(height: 30),
                Row(
                  children: [
                    // Botão Cancelar
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _limparCampos,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black87,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.clear, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Cancelar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    // Botão Analisar
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _analisarPerfil,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.main,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.analytics, size: 20, color: AppColors.mainWhite),
                            SizedBox(width: 8),
                            Text(
                              'Analisar',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}