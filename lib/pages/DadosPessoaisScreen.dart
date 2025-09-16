import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/pages/PerfilScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/UsuarioService.dart'; // Usar seu UsuarioService existente

class DadosPessoaisScreen extends StatefulWidget {
  final Usuario usuario; // Recebe o usuário atual

  const DadosPessoaisScreen({Key? key, required this.usuario}) : super(key: key);

  @override
  State<DadosPessoaisScreen> createState() => _DadosPessoaisScreenState();
}

class _DadosPessoaisScreenState extends State<DadosPessoaisScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  bool hasChanges = false;

  // Valores originais para comparação
  String _nomeOriginal = '';
  String _dataOriginal = '';
  String _telefoneOriginal = '';
  String _emailOriginal = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    
    // Listeners para detectar mudanças
    _nomeController.addListener(_onTextChanged);
    _dataController.addListener(_onTextChanged);
    _emailController.addListener(_onTextChanged);
    _telefoneController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _dataController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    // Carregar dados do usuário atual
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _nomeController.text = widget.usuario.nome;
        _dataController.text = widget.usuario.dataNascimento;
        _telefoneController.text = widget.usuario.telefone;
        _emailController.text = widget.usuario.email;
        
        // Salvar valores originais
        _nomeOriginal = widget.usuario.nome;
        _dataOriginal = widget.usuario.dataNascimento;
        _emailOriginal = widget.usuario.email;
        _telefoneOriginal = widget.usuario.telefone;
        
        isLoading = false;
      });
    });
  }

  void _onTextChanged() {
    // Verificar se houve mudanças comparando com os valores originais
    bool temMudancas = _nomeController.text != _nomeOriginal || 
                       _dataController.text != _dataOriginal;
                       _emailController.text != _emailOriginal;
                       _telefoneController.text != _telefoneOriginal;
    
    if (hasChanges != temMudancas) {
      setState(() {
        hasChanges = temMudancas;
      });
    }
  }

  void _saveData() async {
    setState(() {
      isLoading = true;
    });

    // Simular salvamento
    await Future.delayed(const Duration(milliseconds: 800));

    // Salvar as alterações no objeto Usuario
    widget.usuario.nome = _nomeController.text.trim();
    widget.usuario.dataNascimento = _dataController.text;
    widget.usuario.email = _emailController.text;
    widget.usuario.telefone = _telefoneController.text;

    // Salvar no SharedPreferences usando seu UsuarioService
    await UsuarioService.atualizarUsuario(widget.usuario);

    // Atualizar valores originais
    _nomeOriginal = widget.usuario.nome;
    _dataOriginal = widget.usuario.dataNascimento;
    _emailOriginal = widget.usuario.email;
    _telefoneOriginal = widget.usuario.telefone;

    setState(() {
      isLoading = false;
      hasChanges = false;
    });

    // Mostrar feedback de sucesso
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Dados salvos com sucesso!'),
          backgroundColor: Colors.green,
          action: SnackBarAction(
            label: 'OK',
            textColor: Colors.white,
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            },
          ),
        ),
      );
    }
  }

  Future<bool> _onWillPop() async {
    if (hasChanges) {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Descartar alterações?'),
          content: const Text('Você tem alterações não salvas. Deseja descartá-las?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Descartar',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
      ) ?? false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.theme,
        appBar: CustomAppBar(
            title: 'Dados Pessoais',
            scaffoldKey: _scaffoldKey,
            onBackPressed: () {
              if (hasChanges) {
                _onWillPop().then((canPop) {
                  if (canPop) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PerfilScreen(),
                      ),
                    );
                  }
                });
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PerfilScreen(),
                  ),
                );
              }
            }),
        drawer: const CustomDrawer(),
        body: isLoading && _nomeController.text.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.main,
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.main,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  color: Colors.white,
                                  size: 28,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Dados Pessoais',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 8),
                            Text(
                              'Atualize suas informações pessoais',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            _buildInputField(
                              label: 'Nome Completo',
                              controller: _nomeController,
                              enabled: !isLoading,
                              icon: Icons.person,
                            ),
                            
                            const SizedBox(height: 20),
                            
                            _buildInputField(
                              label: 'Data de Nascimento',
                              controller: _dataController,
                              enabled: !isLoading,
                              keyboardType: TextInputType.datetime,
                              onTap: () => _selectDate(context),
                              icon: Icons.cake_outlined,
                            ),

                            const SizedBox(height: 24),
                            
                            _buildInputField(
                              label: 'Email',
                              controller: _emailController,
                              enabled: !isLoading,
                              keyboardType: TextInputType.emailAddress,
                              icon: Icons.email,
                            ),

                            const SizedBox(height: 24),
                            
                            _buildInputField(
                              label: 'Telefone',
                              controller: _telefoneController,
                              enabled: !isLoading,
                              keyboardType: TextInputType.phone,
                              icon: Icons.phone,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    if (hasChanges) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _saveData,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.main,
                            foregroundColor: AppColors.mainWhite,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.save, size: 20),
                                    const SizedBox(width: 8),
                                    const Text(
                                      'Salvar Alterações',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.orange.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.orange,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Você tem alterações não salvas',
                                style: TextStyle(
                                  color: Colors.orange.shade700,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onTap,
    IconData? icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white70, size: 16),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white70,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            onTap: onTap,
            readOnly: onTap != null,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF4F46E5),
                  width: 2,
                ),
              ),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: onTap != null
                  ? const Icon(Icons.calendar_today, color: Colors.grey)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    // Tentar converter a data atual do controller
    DateTime initialDate = DateTime.now();
    try {
      List<String> dateParts = _dataController.text.split('/');
      if (dateParts.length == 3) {
        int day = int.parse(dateParts[0]);
        int month = int.parse(dateParts[1]);
        int year = int.parse(dateParts[2]);
        initialDate = DateTime(year, month, day);
      }
    } catch (e) {
      // Se não conseguir converter, usa a data atual
      initialDate = DateTime(2000, 1, 1);
    }

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.main,
            ),
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        _dataController.text = 
            '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}';
      });
    }
  }
}

// Exemplo de como navegar para esta tela passando o usuário
class NavigationExample extends StatelessWidget {
  final Usuario usuario;
  
  const NavigationExample({Key? key, required this.usuario}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exemplo')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DadosPessoaisScreen(usuario: usuario),
              ),
            );
          },
          child: const Text('Ir para Dados Pessoais'),
        ),
      ),
    );
  }
}