// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/TermsScreen.dart';
import 'package:flutter_application_1/pages/WelcomeScreen.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/UsuarioService.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter_application_1/components/AppBar.dart';

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentStep = 0;

  bool _obscureText = true;
  String? _sexoSelecionado;
  String? _estadoSelecionado;
  bool _possuiComorbidade = false;
  bool _possuiTEA = false;
  String? _nivelSuporteTEA;
  String? _estadoCivilSelecionado;

  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController celularController = TextEditingController();
  TextEditingController dataController = TextEditingController();
  TextEditingController cpfController = TextEditingController();
  TextEditingController rgController = TextEditingController();
  TextEditingController senhaController = TextEditingController();
  TextEditingController ruaController = TextEditingController();
  TextEditingController cidadeController = TextEditingController();
  TextEditingController comorbidadeController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController complementoController = TextEditingController();

  var celularMask = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  var dataNascimentoMask = MaskTextInputFormatter(
      mask: '##/##/####', filter: {"#": RegExp(r'[0-9]')});
  var cpfMask = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  var rgMask = MaskTextInputFormatter(
      mask: '##.###.###-#', filter: {"#": RegExp(r'[0-9]')});
  var cepMask = MaskTextInputFormatter(
    mask: '#####-###', filter: {"#": RegExp(r'[0-9]')});

  final List<String> sexoOptions = ['Masculino', 'Feminino', 'Outro'];

  final List<String> estadoCivilOptions = [
    'Solteiro(a)',
    'Casado(a)',
    'Divorciado(a)',
    'Viúvo(a)',
    'Separado(a)'
  ];
  
  final List<String> estados = [
    'AC - Acre', 'AL - Alagoas', 'AP - Amapá', 'AM - Amazonas',
    'BA - Bahia', 'CE - Ceará', 'DF - Distrito Federal', 'ES - Espírito Santo',
    'GO - Goiás', 'MA - Maranhão', 'MT - Mato Grosso', 'MS - Mato Grosso do Sul',
    'MG - Minas Gerais', 'PA - Pará', 'PB - Paraíba', 'PR - Paraná',
    'PE - Pernambuco', 'PI - Piauí', 'RJ - Rio de Janeiro', 'RN - Rio Grande do Norte',
    'RS - Rio Grande do Sul', 'RO - Rondônia', 'RR - Roraima', 'SC - Santa Catarina',
    'SP - São Paulo', 'SE - Sergipe', 'TO - Tocantins'
  ];

  final List<String> niveisSuporteTEA = [
    'Nível 1 - Necessita de apoio',
    'Nível 2 - Necessita de apoio substancial',
    'Nível 3 - Necessita de apoio muito substancial'
  ];

  final List<String> stepTitles = [
    'Dados Pessoais',
    'Endereço',
    'Informações de Saúde',
    'Finalize seu Cadastro'
  ];

  Widget _buildProgressIndicator() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Column(
        children: [
          Row(
            children: List.generate(4, (index) {
              return Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                    right: index < 3 ? 8 : 0,
                  ),
                  height: 4,
                  decoration: BoxDecoration(
                    color: index <= _currentStep ? AppColors.main : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            '${_currentStep + 1}/4 - ${stepTitles[_currentStep]}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.main,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<MaskTextInputFormatter>? inputFormatters,
    bool obscureText = false,
    Widget? suffixIcon,
    int maxLines = 1,
    String? hintText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.main,
              ),
            ),
          ),
          TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            obscureText: obscureText,
            maxLines: maxLines,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade500),
              filled: true,
              fillColor: Colors.white,
              suffixIcon: suffixIcon,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.main, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: maxLines > 1 ? 16 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    required String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.main,
              ),
            ),
          ),
          DropdownButtonFormField<String>(
            value: value,
            validator: validator,
            items: items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(color: Colors.black87),
                ),
              );
            }).toList(),
            onChanged: onChanged,
            style: const TextStyle(color: Colors.black87, fontSize: 16),
            dropdownColor: Colors.white,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.main, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: Colors.red),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckboxTile({
    required String title,
    required bool value,
    required void Function(bool?) onChanged,
    String? subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: CheckboxListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: AppColors.main,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              )
            : null,
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.main,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  Widget _buildStepContent(int step) {
    switch (step) {
      case 0:
        return _buildPersonalDataStep();
      case 1:
        return _buildAddressStep();
      case 2:
        return _buildHealthStep();
      case 3:
        return _buildFinalStep();
      default:
        return Container();
    }
  }

  Widget _buildPersonalDataStep() {
  return Column(
    children: [
      _buildCustomTextField(
        controller: nomeController,
        label: 'Nome Completo',
        hintText: 'Digite seu nome completo',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, insira seu nome completo';
          }
          return null;
        },
      ),
      _buildCustomTextField(
        controller: emailController,
        label: 'Email',
        hintText: 'exemplo@email.com',
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Por favor, insira seu email';
          }
          final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
          if (!emailRegex.hasMatch(value.trim())) {
            return 'Insira um email válido';
          }
          return null;
        },
      ),
      _buildCustomTextField(
        controller: celularController,
        label: 'Celular',
        hintText: '(00) 00000-0000',
        keyboardType: TextInputType.phone,
        inputFormatters: [celularMask],
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Por favor, insira seu celular';
          }
          if (value.replaceAll(RegExp(r'\D'), '').length < 11) {
            return 'Insira um número de celular válido';
          }
          return null;
        },
      ),
      _buildCustomTextField(
        controller: dataController,
        label: 'Data de Nascimento',
        hintText: 'DD/MM/AAAA',
        keyboardType: TextInputType.number,
        inputFormatters: [dataNascimentoMask],
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Por favor, insira sua data de nascimento';
          }
          final parts = value.trim().split('/');
          if (parts.length != 3) {
            return 'Formato inválido (dd/mm/aaaa)';
          }
          final day = int.tryParse(parts[0]);
          final month = int.tryParse(parts[1]);
          final year = int.tryParse(parts[2]);
          if (day == null || month == null || year == null) {
            return 'Data inválida';
          }
          if (day < 1 || day > 31) {
            return 'Dia deve estar entre 1 e 31';
          }
          if (month < 1 || month > 12) {
            return 'Mês deve estar entre 1 e 12';
          }
          if (year < 1900 || year > DateTime.now().year) {
            return 'Ano deve estar entre 1900 e ${DateTime.now().year}';
          }
          try {
            final date = DateTime(year, month, day);
            if (date.day != day || date.month != month || date.year != year) {
              return 'Data inválida';
            }
            if (date.isAfter(DateTime.now())) {
              return 'Data no futuro é inválida';
            }
            final age = DateTime.now().difference(date).inDays ~/ 365;
            if (age > 150) {
              return 'Idade muito alta, verifique a data';
            }
          } catch (e) {
            return 'Data inválida';
          }
          return null;
        },
      ),
      _buildCustomDropdown(
        label: 'Sexo',
        value: _sexoSelecionado,
        items: sexoOptions,
        onChanged: (value) => setState(() => _sexoSelecionado = value),
        validator: (value) {
          if (value == null) {
            return 'Por favor, selecione seu sexo';
          }
          return null;
        },
      ),
      _buildCustomDropdown(
        label: 'Estado Civil',
        value: _estadoCivilSelecionado,
        items: estadoCivilOptions,
        onChanged: (value) => setState(() => _estadoCivilSelecionado = value),
        validator: (value) {
          if (value == null) {
            return 'Por favor, selecione seu estado civil';
          }
          return null;
        },
      ),
      Row(
        children: [
          Expanded(
            child: _buildCustomTextField(
              controller: cpfController,
              label: 'CPF',
              hintText: '000.000.000-00',
              keyboardType: TextInputType.number,
              inputFormatters: [cpfMask],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor, insira seu CPF';
                }
                String cpf = value.replaceAll(RegExp(r'\D'), '');
                if (cpf.length != 11 || RegExp(r'^(\d)\1*$').hasMatch(cpf)) {
                  return 'CPF inválido';
                }
                List<int> digits = cpf.split('').map(int.parse).toList();
                int sum1 = 0;
                for (int i = 0; i < 9; i++) {
                  sum1 += digits[i] * (10 - i);
                }
                int firstVerifier = (sum1 * 10) % 11;
                if (firstVerifier == 10) firstVerifier = 0;
                if (digits[9] != firstVerifier) {
                  return 'CPF inválido';
                }
                int sum2 = 0;
                for (int i = 0; i < 10; i++) {
                  sum2 += digits[i] * (11 - i);
                }
                int secondVerifier = (sum2 * 10) % 11;
                if (secondVerifier == 10) secondVerifier = 0;
                if (digits[10] != secondVerifier) {
                  return 'CPF inválido';
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildCustomTextField(
              controller: rgController,
              label: 'RG',
              hintText: '00.000.000-0',
              keyboardType: TextInputType.number,
              inputFormatters: [rgMask],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor, insira seu RG';
                }
                String rg = value.replaceAll(RegExp(r'\D'), '');
                if (rg.length < 7 || rg.length > 9) {
                  return 'RG inválido';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildAddressStep() {
  return Column(
    children: [
      _buildCustomDropdown(
        label: 'Estado',
        value: _estadoSelecionado,
        items: estados,
        onChanged: (value) => setState(() => _estadoSelecionado = value),
        validator: (value) {
          if (value == null) {
            return 'Por favor, selecione seu estado';
          }
          return null;
        },
      ),
      _buildCustomTextField(
        controller: cidadeController,
        label: 'Cidade',
        hintText: 'Digite sua cidade',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, insira sua cidade';
          }
          return null;
        },
      ),
      _buildCustomTextField(
        controller: bairroController,
        label: 'Bairro',
        hintText: 'Digite seu bairro',
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Por favor, insira seu bairro';
          }
          return null;
        },
      ),
      Row(
        children: [
          Expanded(
            flex: 2,
            child: _buildCustomTextField(
              controller: ruaController,
              label: 'Rua',
              hintText: 'Nome da rua',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira sua rua';
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 1,
            child: _buildCustomTextField(
              controller: numeroController,
              label: 'Número',
              hintText: '123',
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, insira o número';
                }
                return null;
              },
            ),
          ),
        ],
      ),
      Row(
        children: [
          Expanded(
            flex: 1,
            child: _buildCustomTextField(
              controller: cepController,
              label: 'CEP',
              hintText: '00000-000',
              keyboardType: TextInputType.number,
              inputFormatters: [cepMask],
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor, insira seu CEP';
                }
                if (value.replaceAll(RegExp(r'\D'), '').length != 8) {
                  return 'CEP inválido';
                }
                return null;
              },
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: _buildCustomTextField(
              controller: complementoController,
              label: 'Complemento (Opcional)',
              hintText: 'Apartamento, bloco, etc.',
              validator: (value) {
                // Complemento é opcional, então não precisa de validação
                return null;
              },
            ),
          ),
        ],
      ),
    ],
  );
}

  Widget _buildHealthStep() {
    return Column(
      children: [
        _buildCheckboxTile(
          title: 'Possui comorbidade(s)',
          subtitle: 'Marque se você possui alguma condição médica',
          value: _possuiComorbidade,
          onChanged: (value) {
            setState(() {
              _possuiComorbidade = value!;
              if (!_possuiComorbidade) {
                comorbidadeController.clear();
              }
            });
          },
        ),
        if (_possuiComorbidade) ...[
          _buildCustomTextField(
            controller: comorbidadeController,
            label: 'Descreva suas comorbidades',
            hintText: 'Descreva detalhadamente suas condições médicas...',
            maxLines: 3,
            validator: (value) {
              if (_possuiComorbidade && (value == null || value.trim().isEmpty)) {
                return 'Por favor, especifique sua(s) comorbidade(s)';
              }
              return null;
            },
          ),
        ],
        _buildCheckboxTile(
          title: 'Possui TEA',
          subtitle: 'Transtorno do Espectro Autista',
          value: _possuiTEA,
          onChanged: (value) {
            setState(() {
              _possuiTEA = value!;
              if (!_possuiTEA) {
                _nivelSuporteTEA = null;
              }
            });
          },
        ),
        if (_possuiTEA) ...[
          _buildCustomDropdown(
            label: 'Nível de Suporte',
            value: _nivelSuporteTEA,
            items: niveisSuporteTEA,
            onChanged: (value) => setState(() => _nivelSuporteTEA = value),
            validator: (value) {
              if (_possuiTEA && value == null) {
                return 'Por favor, selecione o nível de suporte';
              }
              return null;
            },
          ),
        ],
      ],
    );
  }

  Widget _buildFinalStep() {
    return Column(
      children: [
        _buildCustomTextField(
          controller: senhaController,
          label: 'Senha',
          hintText: 'Mínimo de 6 caracteres',
          obscureText: _obscureText,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText ? Icons.visibility_off : Icons.visibility,
              color: AppColors.main,
            ),
            onPressed: () {
              setState(() {
                _obscureText = !_obscureText;
              });
            },
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, insira sua senha';
            }
            if (value.length < 6) {
              return 'A senha deve ter no mínimo 6 caracteres';
            }
            return null;
          },
        ),
        Container(
          padding: const EdgeInsets.all(20),
          margin: const EdgeInsets.only(top: 20),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue.shade200),
          ),
          child: Column(
            children: [
              Icon(
                Icons.security,
                color: AppColors.main,
                size: 32,
              ),
              const SizedBox(height: 12),
              Text(
                'Seus dados estão seguros',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.main,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Utilizamos criptografia de ponta para proteger todas as suas informações pessoais.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() => _currentStep--);
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.main,
                    side: BorderSide(color: AppColors.main),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Voltar',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            if (_currentStep > 0) const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  if (_currentStep < 3) {
                    if (_validateCurrentStep()) {
                      setState(() => _currentStep++);
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    }
                  } else {
                    _submitForm();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.main,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  _currentStep < 3 ? 'Continuar' : 'Finalizar Cadastro',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateCurrentStep() {
  switch (_currentStep) {
    case 0:
      return nomeController.text.isNotEmpty &&
             emailController.text.isNotEmpty &&
             RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text) &&
             celularController.text.isNotEmpty &&
             dataController.text.isNotEmpty &&
             _sexoSelecionado != null &&
             _estadoCivilSelecionado != null &&
             cpfController.text.isNotEmpty &&
             rgController.text.isNotEmpty;
    case 1:
      return _estadoSelecionado != null &&
             cidadeController.text.isNotEmpty &&
             bairroController.text.isNotEmpty &&
             ruaController.text.isNotEmpty &&
             numeroController.text.isNotEmpty &&
             cepController.text.isNotEmpty;
    case 2:
      if (_possuiComorbidade && comorbidadeController.text.isEmpty) return false;
      if (_possuiTEA && _nivelSuporteTEA == null) return false;
      return true;
    default:
      return true;
  }
}

  Future<void> _submitForm() async {
  if (_formKey.currentState!.validate()) {
    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      Usuario u = Usuario(
        nomeController.text,
        emailController.text,
        cpfController.text,
        dataController.text,
        celularController.text,
        rgController.text,
        senhaController.text,
        sexo: _sexoSelecionado ?? '',
        estadoCivil: _estadoCivilSelecionado ?? '',
        estado: _estadoSelecionado ?? '',
        cidade: cidadeController.text,
        rua: ruaController.text,
        numero: numeroController.text,
        bairro: bairroController.text,
        cep: cepController.text,
        complemento: complementoController.text,
        possuiComorbidade: _possuiComorbidade,
        comorbidades: _possuiComorbidade ? comorbidadeController.text : '',
        possuiTEA: _possuiTEA,
        nivelSuporteTEA: _possuiTEA ? (_nivelSuporteTEA ?? '') : '',
      );
      
      // Cadastrar usando o método completo (local + API)
      Map<String, dynamic> resultado = await UsuarioService.cadastrarUsuarioCompleto(u);
      
      // Fechar loading DIALOG primeiro
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      
      // Pequeno delay para garantir que o dialog foi fechado
      await Future.delayed(const Duration(milliseconds: 100));
      
      if (resultado['success']) {
        // Mostrar dialog de sucesso
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      color: Colors.green.shade600,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Cadastro Realizado!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.main,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Bem-vindo(a), ${u.nome}!\nSua conta foi criada com sucesso e salva no banco de dados.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Fechar o dialog de sucesso primeiro
                        Navigator.of(context).pop();
                        // Depois navegar para a tela de termos
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TermsScreen(),
                            ),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.main,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Continuar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      } else {
        // Mostrar erro
        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.error, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Erro no Cadastro'),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Não foi possível completar o cadastro:',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  Text(
                    resultado['message'] ?? 'Erro desconhecido',
                    style: TextStyle(color: Colors.red.shade700),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Verifique sua conexão com a internet e tente novamente.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Tentar Novamente'),
                ),
              ],
            );
          },
        );
      }
      
    } catch (e) {
      // Fechar loading se ainda estiver aberto
      if (Navigator.of(context, rootNavigator: true).canPop()) {
        Navigator.of(context, rootNavigator: true).pop();
      }
      
      // Mostrar erro de exceção
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro no cadastro: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      });
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainLight,
      appBar: SimpleCustomAppBar(
        title: 'Cadastro',
        showBackButton: true,
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const TermsScreen(),
            ),
          );
        },
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildProgressIndicator(),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                onPageChanged: (index) {
                  setState(() {
                    _currentStep = index;
                  });
                },
                itemBuilder: (context, index) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildStepContent(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildNavigationButtons(),
    );
  }
}