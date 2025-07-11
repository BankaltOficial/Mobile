import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/pages/PixScreen.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/Sessao.dart';
import 'package:flutter_application_1/service/UsuarioService.dart'; // Adicione esta importação
import 'package:flutter/services.dart';

import '../service/Colors.dart';

class PixPagarScreen extends StatefulWidget {
  @override
  _PixPagarScreenState createState() => _PixPagarScreenState();
}

class _PixPagarScreenState extends State<PixPagarScreen> {
  final TextEditingController _pixController = TextEditingController();
  Usuario usuario = Sessao.getUsuario()!;
  String selectedType = 'Email';
  bool _isLoading = false; // Para mostrar loading durante a transação

  @override
  void dispose() {
    _pixController.dispose();
    super.dispose();
  }

  String formatCPF(String value) {
    String numbers = value.replaceAll(RegExp(r'\D'), '');
    if (numbers.length <= 3) return numbers;
    if (numbers.length <= 6)
      return '${numbers.substring(0, 3)}.${numbers.substring(3)}';
    if (numbers.length <= 9)
      return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6)}';
    if (numbers.length <= 11)
      return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6, 9)}-${numbers.substring(9)}';
    return '${numbers.substring(0, 3)}.${numbers.substring(3, 6)}.${numbers.substring(6, 9)}-${numbers.substring(9, 11)}';
  }

  String formatPhone(String value) {
    String numbers = value.replaceAll(RegExp(r'\D'), '');
    if (numbers.length <= 2) return numbers;
    if (numbers.length <= 6)
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2)}';
    if (numbers.length <= 10)
      return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 6)}-${numbers.substring(6)}';
    return '(${numbers.substring(0, 2)}) ${numbers.substring(2, 7)}-${numbers.substring(7, 11)}';
  }

  void _onTextChanged(String value) {
    String formattedValue = value;

    if (selectedType == 'CPF') {
      formattedValue = formatCPF(value);
    } else if (selectedType == 'Telefone') {
      formattedValue = formatPhone(value);
    }

    if (formattedValue != value) {
      _pixController.value = TextEditingValue(
        text: formattedValue,
        selection: TextSelection.collapsed(offset: formattedValue.length),
      );
    }
  }

  String getPlaceholder() {
    switch (selectedType) {
      case 'CPF':
        return '000.000.000-00';
      case 'Telefone':
        return '(00) 00000-0000';
      case 'Email':
        return 'exemplo@email.com';
      default:
        return 'Chave PIX (e-mail, telefone ou CPF)';
    }
  }

  TextInputType getKeyboardType() {
    switch (selectedType) {
      case 'Email':
        return TextInputType.emailAddress;
      case 'Telefone':
      case 'CPF':
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  List<TextInputFormatter> getInputFormatters() {
    if (selectedType == 'CPF') {
      return [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ];
    } else if (selectedType == 'Telefone') {
      return [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(11),
      ];
    }
    return [];
  }

  void _selectType(String type) {
    setState(() {
      selectedType = type;
      _pixController.clear();
    });
  }

  late Usuario usuarioDestinatario = Usuario(
    'Destinatário',
    "",
    "",
    "",
    "",
    "",
    "",
  );

  Widget _buildTypeButton(String type) {
    bool isSelected = selectedType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () => _selectType(type),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.main : Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              type,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[700],
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _realizarPix(double valor, Usuario destinatario) async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool sucesso = await UsuarioService.realizarPix(
        remetente: usuario,
        destinatario: destinatario,
        valor: valor,
      );

      if (sucesso) {
        List<Usuario> usuariosAtualizados =
            await UsuarioService.carregarUsuarios();
        Usuario usuarioAtualizado =
            usuariosAtualizados.firstWhere((u) => u.id == usuario.id);
        Sessao.atualizarUsuario(usuarioAtualizado);

        setState(() {
          usuario = usuarioAtualizado;
        });

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PIX realizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao realizar PIX. Tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro inesperado: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        key: scaffoldKey,
        appBar: CustomAppBar(
          title: 'Pagar com PIX',
          scaffoldKey: scaffoldKey,
          onBackPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const PixScreen()),
            );
          },
        ),
        drawer: const CustomDrawer(),
        body: SingleChildScrollView(
          child: Container(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 40),
                    Text(
                      'Digite ou cole a chave PIX',
                      style: TextStyle(
                        color: AppColors.invertModeMain,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.theme,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: TextFormField(
                        controller: _pixController,
                        decoration: InputDecoration(
                          hintText: getPlaceholder(),
                          hintStyle: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.invertMode,
                        ),
                        keyboardType: getKeyboardType(),
                        inputFormatters: getInputFormatters(),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Por favor, insira uma chave PIX válida.';
                          }
                          return null;
                        },
                        onChanged: _onTextChanged,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        _buildTypeButton('Email'),
                        SizedBox(width: 8),
                        _buildTypeButton('Telefone'),
                        SizedBox(width: 8),
                        _buildTypeButton('CPF'),
                      ],
                    ),
                    SizedBox(height: 24),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                String chavePix = _pixController.text.trim();

                                if (chavePix.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Por favor, insira uma chave PIX válida.'),
                                    ),
                                  );
                                  return;
                                }

                                try {
                                  await UsuarioService.carregarUsuarios();
                                  if (selectedType == 'CPF' ||
                                      (chavePix.length == 14 &&
                                          chavePix.contains('.'))) {
                                    usuarioDestinatario =
                                        verificarUsuarioPorCpf(chavePix);
                                  } else if (selectedType == 'Telefone' ||
                                      (chavePix.length >= 10 &&
                                          chavePix.contains('('))) {
                                    usuarioDestinatario =
                                        verificarUsuarioPorTelefone(chavePix);
                                  } else if (selectedType == 'Email' ||
                                      chavePix.contains('@')) {
                                    usuarioDestinatario =
                                        verificarUsuarioPorEmail(chavePix);
                                  }

                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      TextEditingController valorController =
                                          TextEditingController();

                                      return AlertDialog(
                                        title: Text('Confirmar PIX'),
                                        content: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                                'Para: ${usuarioDestinatario.nome}'),
                                            SizedBox(height: 16),
                                            TextField(
                                              controller: valorController,
                                              decoration: InputDecoration(
                                                labelText: 'Valor (R\$)',
                                                border: OutlineInputBorder(),
                                              ),
                                              keyboardType: TextInputType
                                                  .numberWithOptions(
                                                      decimal: true),
                                            ),
                                          ],
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('Cancelar'),
                                          ),
                                          ElevatedButton(
                                            onPressed: _isLoading
                                                ? null
                                                : () async {
                                                    double? valorTransferencia =
                                                        double.tryParse(
                                                            valorController
                                                                .text);
 
                                                    if (valorTransferencia ==
                                                            null ||
                                                        valorTransferencia <=
                                                            0) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Insira um valor válido.'),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                      return;
                                                    }

                                                    if (valorTransferencia >
                                                        usuario.saldo) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Saldo insuficiente para PIX.'),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                      return;
                                                    }

                                                    if (usuarioDestinatario
                                                            .cpf ==
                                                        usuario.cpf) {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                              'Você não pode fazer um PIX para a mesma conta'),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                      return;
                                                    }

                                                    // Realizar PIX usando o UsuarioService
                                                    await _realizarPix(
                                                        valorTransferencia,
                                                        usuarioDestinatario);
                                                  },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.main,
                                            ),
                                            child: _isLoading
                                                ? SizedBox(
                                                    width: 20,
                                                    height: 20,
                                                    child:
                                                        CircularProgressIndicator(
                                                      strokeWidth: 2,
                                                      valueColor:
                                                          AlwaysStoppedAnimation<
                                                                  Color>(
                                                              Colors.white),
                                                    ),
                                                  )
                                                : Text(
                                                    'Confirmar',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Usuário não encontrado: ${e.toString()}'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.main,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : Text(
                                'Continuar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[400])),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Ou se preferir',
                            style: TextStyle(
                              color: AppColors.mainGray,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey[400])),
                      ],
                    ),
                    SizedBox(height: 40),
                    Column(
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          size: 48,
                          color: AppColors.mainGray,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Use sua camera para',
                          style: TextStyle(
                            color: AppColors.mainGray,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'ler o QR Code',
                          style: TextStyle(
                            color: AppColors.mainGray,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Implementar funcionalidade de QR Code
                              print('Acessar camera pressionado');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.main,
                              padding: EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Acessar camera',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
