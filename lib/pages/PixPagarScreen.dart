import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/pages/PixScreen.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/Sessao.dart';

import '../service/Colors.dart';

class PixPagarScreen extends StatefulWidget {
  @override
  _PixPagarScreenState createState() => _PixPagarScreenState();
}

class _PixPagarScreenState extends State<PixPagarScreen> {
  final TextEditingController _pixController = TextEditingController();
  Usuario usuario = Sessao.getUsuario()!;
  late Usuario usuarioDestinatario = Usuario(
    'Destinatário',
    "",
    "",
    "",
    "",
    "",
    "",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Pagar com PIX',
        scaffoldKey: GlobalKey<ScaffoldState>(),
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const PixScreen()),
          );
        },
      ),
      drawer: const CustomDrawer(),
      body: Container(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40),
                Text(
                  'Digite ou cole a chave PIX',
                  style: TextStyle(
                    color: AppColors.main,
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
                        hintText:
                            'Chave PIX (e-mail, telefone, CPF ou chave aleatória)',
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
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, insira uma chave PIX válida.';
                        }
                        return null;
                      },
                      onChanged: (value) {
                        String texto =
                            value.replaceAll(RegExp(r'[^0-9a-zA-Z@.]'), '');

                        String formatado;

                        if (RegExp(r'^\d{11}$').hasMatch(texto)) {
                          formatado =
                              '${texto.substring(0, 3)}.${texto.substring(3, 6)}.${texto.substring(6, 9)}-${texto.substring(9)}';
                        } else if (RegExp(r'^\d{10,11}$').hasMatch(texto)) {
                          if (texto.length == 11) {
                            formatado =
                                '(${texto.substring(0, 2)}) ${texto.substring(2, 7)}-${texto.substring(7)}';
                          } else {
                            formatado =
                                '(${texto.substring(0, 2)}) ${texto.substring(2, 6)}-${texto.substring(6)}';
                          }
                        } else if (texto.contains('@') && texto.contains('.')) {
                          formatado = texto;
                        } else {
                          formatado = texto;
                        }
                        if (_pixController.text != formatado) {
                          final pos = _pixController.selection.baseOffset;
                          _pixController.value = TextEditingValue(
                            text: formatado,
                            selection: TextSelection.collapsed(
                              offset: formatado.length < pos
                                  ? formatado.length
                                  : pos,
                            ),
                          );
                        }
                        if (_pixController.text.length == 14) {
                          usuarioDestinatario = verificarUsuarioPorCpf(
                              _pixController.text.trim());
                        } else if (_pixController.text.length == 11) {
                          usuarioDestinatario = verificarUsuarioPorTelefone(
                              _pixController.text.trim());
                        } else if (_pixController.text.contains('@')) {
                          usuarioDestinatario = verificarUsuarioPorEmail(
                              _pixController.text.trim());
                        }
                      }),
                ),
                SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          var valorTransferencia;
                          if (_pixController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('Por favor, insira uma chave PIX.'),
                              ),
                            );
                            return Container();
                          }
                          return AlertDialog(
                            title: Text('Confirmar PIX'),
                            content: Text(
                                'Deseja confirmar a PIX de R\$ $valorTransferencia para ${usuarioDestinatario.nome}'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Cancelar'),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (usuario != null &&
                                      valorTransferencia > 0) {
                                    if (valorTransferencia > usuario.saldo) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Saldo insuficiente para PIX.'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }
                                    if (usuarioDestinatario.cpf ==
                                        usuario.cpf) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              'Você não pode fazer uma PIX para mesma conta'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }
                                    Sessao.atualizarUsuario(usuario);
                                    //salvarSaldo(usuario.saldo);
                                    Navigator.pop(context);
                                    print(usuario.saldo);
                                    print(usuarioDestinatario.saldo);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content:
                                            Text('PIX realizada com sucesso!'),
                                        backgroundColor: Colors.green,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.main,
                                ),
                                child: Text(
                                  'Confirmar',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          );
                        },
                      );
                      String chavePix = _pixController.text.trim();
                      if (chavePix.isNotEmpty) {
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Por favor, insira uma chave PIX válida.')),
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
                    child: Text(
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
                          // Ação do botão acessar camera
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
    );
  }

  @override
  void dispose() {
    _pixController.dispose();
    super.dispose();
  }
}
