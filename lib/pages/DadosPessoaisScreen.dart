import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/pages/PerfilScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/UsuarioService.dart';
import 'package:flutter_application_1/service/Sessao.dart';

class DadosPessoaisScreen extends StatefulWidget {
  final Usuario usuario;

  const DadosPessoaisScreen({Key? key, required this.usuario}) : super(key: key);

  @override
  State<DadosPessoaisScreen> createState() => _DadosPessoaisScreenState();
}

class _DadosPessoaisScreenState extends State<DadosPessoaisScreen> {
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _dataController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool isLoading = false;
  bool hasChanges = false;

  // Valores originais para comparação
  String _nomeOriginal = '';
  String _dataOriginal = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
    
    // Listeners para detectar mudanças
    _nomeController.addListener(_onTextChanged);
    _dataController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _dataController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _nomeController.text = widget.usuario.nome;
        _dataController.text = widget.usuario.dataNascimento;
        
        // Salvar valores originais
        _nomeOriginal = widget.usuario.nome;
        _dataOriginal = widget.usuario.dataNascimento;
        
        isLoading = false;
      });
    });
  }

  void _onTextChanged() {
    // Verificar se houve mudanças comparando com os valores originais
    bool temMudancas = _nomeController.text.trim() != _nomeOriginal || 
                       _dataController.text != _dataOriginal;
    
    if (hasChanges != temMudancas) {
      setState(() {
        hasChanges = temMudancas;
      });
    }
  }

  void _saveData() async {
    // Validações
    if (_nomeController.text.trim().isEmpty) {
      _showErrorSnackBar('Nome não pode estar vazio');
      return;
    }

    if (_dataController.text.isEmpty) {
      _showErrorSnackBar('Data de nascimento é obrigatória');
      return;
    }

    // Validar formato da data
    if (!_isValidDateFormat(_dataController.text)) {
      _showErrorSnackBar('Formato de data inválido');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Atualizar dados do usuário atual
      widget.usuario.nome = _nomeController.text.trim();
      widget.usuario.dataNascimento = _dataController.text;

      // Salvar no UsuarioService (persistir no SharedPreferences)
      await UsuarioService.atualizarUsuario(widget.usuario);
      
      // Atualizar na sessão
      await Sessao.atualizarUsuario(widget.usuario);

      // Atualizar valores originais após salvar com sucesso
      _nomeOriginal = widget.usuario.nome;
      _dataOriginal = widget.usuario.dataNascimento;

      setState(() {
        isLoading = false;
        hasChanges = false;
      });

      // Mostrar feedback de sucesso
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white),
                const SizedBox(width: 8),
                const Text('Dados salvos com sucesso!'),
              ],
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
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
      
      print('Dados pessoais atualizados: ${widget.usuario.nome}, ${widget.usuario.dataNascimento}');
      
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      
      print('Erro ao salvar dados pessoais: $e');
      _showErrorSnackBar('Erro ao salvar dados. Tente novamente.');
    }
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  bool _isValidDateFormat(String date) {
    try {
      RegExp dateRegex = RegExp(r'^\d{2}/\d{2}/\d{4}$');
      if (!dateRegex.hasMatch(date)) {
        return false;
      }

      List<String> parts = date.split('/');
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);

      if (month < 1 || month > 12) return false;
      if (day < 1 || day > 31) return false;
      if (year < 1900 || year > DateTime.now().year) return false;

      // Verificar se a data é válida
      DateTime parsedDate = DateTime(year, month, day);
      return parsedDate.day == day && 
             parsedDate.month == month && 
             parsedDate.year == year;
    } catch (e) {
      return false;
    }
  }

  Future<bool> _onWillPop() async {
    if (hasChanges) {
      return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              const SizedBox(width: 8),
              const Text('Descartar alterações?'),
            ],
          ),
          content: const Text(
            'Você tem alterações não salvas. Deseja descartá-las?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Descartar'),
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
            onBackPressed: () async {
              if (hasChanges) {
                bool canPop = await _onWillPop();
                if (canPop) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PerfilScreen(),
                    ),
                  );
                }
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: AppColors.main,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Carregando dados...',
                      style: TextStyle(
                        color: AppColors.main,
                        fontSize: 16,
                      ),
                    ),
                  ],
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
                            elevation: 3,
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
      // Se não conseguir converter, usa uma data padrão
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