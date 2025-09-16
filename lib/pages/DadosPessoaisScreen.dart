import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/components/PhoneInputFormatter.dart';
import 'package:flutter_application_1/pages/PerfilScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/UsuarioService.dart';

// Formatador para data
class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(RegExp(r'\D'), '');
    
    if (text.length > 8) {
      text = text.substring(0, 8);
    }
    
    String formatted = '';
    for (int i = 0; i < text.length; i++) {
      if (i == 2 || i == 4) {
        formatted += '/';
      }
      formatted += text[i];
    }
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Formatador para nome (primeira letra maiúscula)
class NameInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text;
    
    // Remover números e caracteres especiais, mantendo apenas letras e espaços
    text = text.replaceAll(RegExp(r'[^a-zA-ZáàâãéèêíìîóòôõúùûçÁÀÂÃÉÈÊÍÌÎÓÒÔÕÚÙÛÇ\s]'), '');
    
    // Capitalizar primeira letra de cada palavra
    List<String> words = text.split(' ');
    for (int i = 0; i < words.length; i++) {
      if (words[i].isNotEmpty) {
        words[i] = words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
      }
    }
    
    String formatted = words.join(' ');
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class DadosPessoaisScreen extends StatefulWidget {
  final Usuario usuario;

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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
    setState(() {
      isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _nomeController.text = widget.usuario.nome;
        _dataController.text = widget.usuario.dataNascimento;
        _telefoneController.text = PhoneInputFormatter().formatEditUpdate(
          TextEditingValue.empty,
          TextEditingValue(text: widget.usuario.telefone),
        ).text;
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
    // Corrigir o operador lógico - estava faltando ||
    bool temMudancas = _nomeController.text != _nomeOriginal || 
                       _dataController.text != _dataOriginal ||
                       _emailController.text != _emailOriginal ||
                       _telefoneController.text.replaceAll(RegExp(r'\D'), '') != _telefoneOriginal.replaceAll(RegExp(r'\D'), '');
    
    if (hasChanges != temMudancas) {
      setState(() {
        hasChanges = temMudancas;
      });
    }
  }

  String? _validateNome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nome é obrigatório';
    }
    
    String trimmedValue = value.trim();
    
    if (trimmedValue.length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }
    
    if (trimmedValue.length > 50) {
      return 'Nome não pode ter mais de 50 caracteres';
    }
    
    // Verificar se contém apenas letras, espaços e acentos
    if (!RegExp(r'^[a-zA-ZáàâãéèêíìîóòôõúùûçÁÀÂÃÉÈÊÍÌÎÓÒÔÕÚÙÛÇ\s]+$').hasMatch(trimmedValue)) {
      return 'Nome deve conter apenas letras';
    }
    
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email é obrigatório';
    }
    
    String trimmedValue = value.trim().toLowerCase();
    
    if (trimmedValue.length > 254) {
      return 'Email muito longo';
    }
    
    // Regex mais robusto para email
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$'
    );
    
    if (!emailRegex.hasMatch(trimmedValue)) {
      return 'Email inválido';
    }
    
    // Verificar se não tem espaços
    if (trimmedValue.contains(' ')) {
      return 'Email não pode conter espaços';
    }
    
    return null;
  }

  String? _validateTelefone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Telefone é obrigatório';
    }
    
    String numbers = value.replaceAll(RegExp(r'\D'), '');
    
    if (numbers.isEmpty) {
      return 'Telefone é obrigatório';
    }
    
    if (numbers.length < 10) {
      return 'Telefone deve ter pelo menos 10 dígitos';
    }
    
    if (numbers.length > 11) {
      return 'Telefone deve ter no máximo 11 dígitos';
    }
    
    return null;
  }

  String? _validateData(String? value) {
    if (value == null || value.isEmpty) {
      return 'Data de nascimento é obrigatória';
    }
    
    // Verificar formato DD/MM/AAAA
    if (!RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(value)) {
      return 'Use o formato DD/MM/AAAA';
    }
    
    try {
      List<String> parts = value.split('/');
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);
      
      // Verificar se os valores são válidos
      if (day < 1 || day > 31) {
        return 'Dia inválido';
      }
      
      if (month < 1 || month > 12) {
        return 'Mês inválido';
      }
      
      if (year < 1900) {
        return 'Ano muito antigo';
      }
      
      // Verificar se a data existe (ex: 30/02 não existe)
      DateTime birthDate;
      try {
        birthDate = DateTime(year, month, day);
        if (birthDate.day != day || birthDate.month != month || birthDate.year != year) {
          return 'Data não existe';
        }
      } catch (e) {
        return 'Data inválida';
      }
      
      DateTime now = DateTime.now();
      
      if (birthDate.isAfter(now)) {
        return 'Data não pode ser no futuro';
      }
      
      // Calcular idade
      int age = now.year - birthDate.year;
      if (now.month < birthDate.month || (now.month == birthDate.month && now.day < birthDate.day)) {
        age--;
      }
      
      if (age < 13) {
        return 'Idade mínima de 13 anos';
      }
      
      if (age > 120) {
        return 'Idade muito alta';
      }
      
    } catch (e) {
      return 'Data inválida';
    }
    
    return null;
  }

  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _saveData() async {
    if (!_formKey.currentState!.validate()) {
      _showErrorSnackBar('Por favor, corrija os erros no formulário');
      return;
    }

    setState(() {
      isLoading = true;
    });

    // Simular salvamento
    await Future.delayed(const Duration(milliseconds: 800));

    // Salvar as alterações no objeto Usuario
    widget.usuario.nome = _nomeController.text.trim();
    widget.usuario.dataNascimento = _dataController.text;
    widget.usuario.email = _emailController.text.trim().toLowerCase();
    widget.usuario.telefone = _telefoneController.text.replaceAll(RegExp(r'\D'), '');

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
                      child: Form(
                        key: _formKey,
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
                                validator: _validateNome,
                                inputFormatters: [NameInputFormatter()],
                                textCapitalization: TextCapitalization.words,
                              ),
                              
                              const SizedBox(height: 20),
                              
                              _buildInputField(
                                label: 'Data de Nascimento',
                                controller: _dataController,
                                enabled: !isLoading,
                                keyboardType: TextInputType.number,
                                onTap: () => _selectDate(context),
                                icon: Icons.cake_outlined,
                                validator: _validateData,
                                inputFormatters: [DateInputFormatter()],
                                hintText: 'DD/MM/AAAA',
                              ),

                              const SizedBox(height: 24),
                              
                              _buildInputField(
                                label: 'Email',
                                controller: _emailController,
                                enabled: !isLoading,
                                keyboardType: TextInputType.emailAddress,
                                icon: Icons.email,
                                validator: _validateEmail,
                                textCapitalization: TextCapitalization.none,
                              ),

                              const SizedBox(height: 24),
                              
                              _buildInputField(
                                label: 'Telefone',
                                controller: _telefoneController,
                                enabled: !isLoading,
                                keyboardType: TextInputType.phone,
                                icon: Icons.phone,
                                validator: _validateTelefone,
                                inputFormatters: [PhoneInputFormatter()],
                                hintText: '(11) 99999-9999',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    ...(
                      hasChanges
                        ? [
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
                          ]
                        : []
                    ),
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
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
    String? hintText,
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
            validator: validator,
            inputFormatters: inputFormatters,
            textCapitalization: textCapitalization,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              hintText: hintText,
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey.shade200,
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color(0xFF4F46E5),
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.red,
                  width: 1,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Colors.red,
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
    DateTime initialDate = DateTime(2000, 1, 1);
    try {
      List<String> dateParts = _dataController.text.split('/');
      if (dateParts.length == 3) {
        int day = int.parse(dateParts[0]);
        int month = int.parse(dateParts[1]);
        int year = int.parse(dateParts[2]);
        initialDate = DateTime(year, month, day);
      }
    } catch (e) {
      // Se não conseguir converter, usa a data padrão
      initialDate = DateTime(2000, 1, 1);
    }

    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
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