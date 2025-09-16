import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/pages/DadosPessoaisScreen.dart';
import 'package:flutter_application_1/pages/InicialScreen.dart';
import 'package:flutter_application_1/pages/WelcomeScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/ColorsProvider.dart';
import 'package:flutter_application_1/service/ColorsService.dart';
import 'package:flutter_application_1/service/Sessao.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/UsuarioService.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({Key? key}) : super(key: key);

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String userName = 'Igor Suracci';
  String userHandle = '@suracci';
  bool isLoading = false;
  Usuario? usuarioAtual;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.theme,
      appBar: CustomAppBar(
            title: 'Perfil',
            scaffoldKey: _scaffoldKey,
            onBackPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
              builder: (context) => const InicialScreen()));
            }),
        drawer: const CustomDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 40),
              Expanded(
                child: Column(
                  children: [
                    _buildConfigCard(
                      title: 'Dados Pessoais',
                      subtitle: 'Edite dados pessoais, e-mail, telefone entre outros.',
                      onTap: () => _handleDadosPessoais(),
                    ),
                    
                    const SizedBox(height: 16),
                  ],
                ),
              ),     
                    const SizedBox(height: 16),
              
              _buildExitButton(),
            ],
          ),
        ),
      ),
    );
  }

 void _handleDadosPessoais() async {
  if (usuarioAtual == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Erro: Nenhum usuário logado encontrado'),
        backgroundColor: Colors.red,
      ),
    );
    return;
  }

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => DadosPessoaisScreen(usuario: usuarioAtual!),
    ),
  );

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isLoading = false;
      });

      print('Navegando para Dados Pessoais');
    });
  }

  void _handleDadosInvestidor() {
    setState(() {
      isLoading = true;
    });
    
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isLoading = false;
      });
      
      print('Navegando para Dados de Investidor');

    });
  }

  void _handleAcessibilidade() {
    setState(() {
      isLoading = true;
    });
    
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isLoading = false;
      });
      
      print('Navegando para Acessibilidade');
    });
  }

  void _handleExitApp() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sair do App'),
          content: const Text('Tem certeza que deseja sair do aplicativo?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
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
              child: const Text('Sair'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

void _loadUserData() async {
  usuarioAtual = await UsuarioService.obterUsuarioLogado();
  
  if (usuarioAtual != null) {
    setState(() {
      userName = usuarioAtual!.nome;
      userHandle = '@${usuarioAtual!.nome.toLowerCase().replaceAll(' ', '')}';
    });
  }
}
  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
          child: const Icon(
            Icons.person,
            size: 50,
            color: AppColors.mainGray,
          ),
        ),
        
        const SizedBox(width: 16),
        
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userName,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: AppColors.invertMode,
              ),
            ),
            Text(
              userHandle,
              style: TextStyle(
                fontSize: 17,
                color: AppColors.invertModeGray,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildConfigCard({
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.main,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.mainWhite,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.mainWhite,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            isLoading = true;
          });
          
          Future.delayed(const Duration(milliseconds: 500), () {
            setState(() {
              isLoading = false;
            });
            
            _handleExitApp();
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.mainRed,
          foregroundColor: AppColors.mainWhite,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
        child: isLoading 
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : const Text(
              'Sair do App',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
      ),
    );
  }
}