import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/PixScreen.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/Sessao.dart';
import 'package:flutter_application_1/service/Usuario.dart';

class MinhasChavesScreen extends StatefulWidget {
  @override
  _MinhasChavesScreenState createState() => _MinhasChavesScreenState();
}

class _MinhasChavesScreenState extends State<MinhasChavesScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Usuario usuario = Sessao.getUsuario()!;
  String selectedKey = 'email';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
          title: 'Minhas Chaves',
          scaffoldKey: _scaffoldKey,
          onBackPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const PixScreen(),
              ),
            );
          }),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          SizedBox(height: 40),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'Escolha qual será sua\nchave PIX',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.invertMode,
                      height: 1.3,
                    ),
                  ),

                  SizedBox(height: 40),

                  // Email option
                  _buildKeyOption(
                    'email',
                    'Email',
                    usuario.email,
                    Icons.email_outlined,
                  ),

                  SizedBox(height: 16),

                  // Phone option
                  _buildKeyOption(
                    'telefone',
                    'Telefone',
                    usuario.telefone,
                    Icons.phone_outlined,
                  ),

                  SizedBox(height: 16),

                  // CPF option
                  _buildKeyOption(
                    'cpf',
                    'CPF',
                    usuario.cpf,
                    Icons.person_outline,
                  ),

                  SizedBox(height: 40),

                  // Current key section
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.mainWhite,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.key,
                              color: AppColors.main,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Sua chave atual é ',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.main,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          usuario.chavePix,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  switch (selectedKey) {
                    case 'email':
                      usuario.chavePix = usuario.email;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Chave Pix atualizada com sucesso!'),
                          backgroundColor: AppColors.defaultTertiary,
                        ),
                      );
                      break;
                    case 'telefone':
                      usuario.chavePix = usuario.telefone;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Chave Pix atualizada com sucesso!'),
                          backgroundColor: AppColors.defaultTertiary,
                        ),
                      );
                      break;
                    case 'cpf':
                      usuario.chavePix = usuario.cpf;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Chave Pix atualizada com sucesso!'),
                          backgroundColor: AppColors.defaultTertiary,
                        ),
                      );
                      break;
                    default:
                      usuario.chavePix = usuario.email;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Não foi possível gerar a chave Pix'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      break;
                  }
                  print(usuario.chavePix);
                  Sessao.atualizarUsuario(usuario);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.main,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                ),
                child: const Text("Continuar",
                    style: TextStyle(fontSize: 15, color: AppColors.mainWhite)),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const PixScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.mainRed,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                ),
                child: const Text("Cancelar",
                    style: TextStyle(fontSize: 15, color: AppColors.mainWhite)),
              ),
            ],
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  Widget _buildKeyOption(
      String key, String title, String value, IconData icon) {
    bool isSelected = selectedKey == key;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedKey = key;
        });
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.mainWhite,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.main : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.main : Colors.grey[400]!,
                  width: 2,
                ),
                color: isSelected ? AppColors.main : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.circle,
                      size: 8,
                      color: AppColors.mainWhite,
                    )
                  : null,
            ),
            SizedBox(width: 16),
            Icon(
              icon,
              size: 24,
              color: AppColors.mainGray,
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.mainGray,
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
