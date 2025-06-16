// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/pages/InicialScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/UsuarioService.dart';
import 'package:flutter_application_1/service/Sessao.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TransferenciaScreen extends StatefulWidget {
  const TransferenciaScreen({super.key});

  @override
  State<TransferenciaScreen> createState() => _TransferenciaScreenState();
}

class _TransferenciaScreenState extends State<TransferenciaScreen> {
  TextEditingController cpfController = TextEditingController();
  var cpfMask = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});
  Usuario usuarioDestinatario =
      Usuario("Destinatário", "destinatario@gmail.com", "", "", "", "", "");
  String cpfDestinatario = '';
  bool _realizandoTransferencia = false;

  final MoneyMaskedTextController valorController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    initialValue: 0.0,
    leftSymbol: 'R\$ ',
  );

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    Usuario usuario = Sessao.getUsuario()!;
    String nome = usuario.nome;

    return Scaffold(
      backgroundColor: AppColors.theme,
      key: scaffoldKey,
      appBar: CustomAppBar(
        title: 'Transferência',
        scaffoldKey: scaffoldKey,
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const InicialScreen()),
          );
        },
      ),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    '',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.grey[600],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  nome,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Icon(
                                Icons.flight_takeoff,
                                color: AppColors.main,
                                size: 50,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(vertical: 8),
                                padding: EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.main,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.attach_money,
                                  color: AppColors.mainWhite,
                                  size: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey[300],
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    '',
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.grey[600],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(height: 12),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  usuarioDestinatario.nome,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 40),
                    Text("Digite o CPF do destinatário",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.invertMode)),
                    SizedBox(height: 5),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.main,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: cpfController,
                        inputFormatters: [cpfMask],
                        decoration: InputDecoration(
                          hintText: '000.000.000-00',
                          hintStyle: TextStyle(color: AppColors.mainGray),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) async {
                          if (value.length == 14) {
                            cpfDestinatario = value;

                            // Carregar usuários atualizados antes de buscar
                            await UsuarioService.carregarUsuarios();

                            if (encontrarUsuarioPorCpf(cpfDestinatario)) {
                              Usuario encontrado =
                                  verificarUsuarioPorCpf(cpfDestinatario);
                              setState(() {
                                usuarioDestinatario = encontrado;
                              });
                              if (usuarioDestinatario.cpf == usuario.cpf) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Você não pode fazer uma transferência para mesma conta'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Usuário encontrado: ${usuarioDestinatario.nome}'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } else {
                              setState(() {
                                usuarioDestinatario = Usuario(
                                    "Destinatário",
                                    "destinatario@gmail.com",
                                    "",
                                    "",
                                    "",
                                    "",
                                    "");
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Usuário não encontrado.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Preencha todos os campos antes de continuar";
                          } else if (value.length != 14) {
                            return "O CPF deve ter exatamente 11 dígitos";
                          }
                          return null;
                        },
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.invertMode,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.mainLight,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Total da transferência',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppColors.invertMode,
                            ),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: TextFormField(
                                  controller: valorController,
                                  validator: (value) {
                                    final cleaned = value?.replaceAll(
                                        RegExp(r'[^0-9,]'), '');
                                    if (cleaned == null || cleaned.isEmpty) {
                                      return 'Digite um valor válido';
                                    }
                                    return null;
                                  },
                                  onChanged: (value) {
                                    final cleaned = value.replaceAll(
                                        RegExp(r'[A-Za-z]'), '');
                                    if (value != cleaned) {
                                      valorController.text = cleaned;
                                      valorController.selection =
                                          TextSelection.fromPosition(
                                        TextPosition(offset: cleaned.length),
                                      );
                                    }
                                  },
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[0-9.,]')),
                                  ],
                                  decoration: InputDecoration(
                                    constraints: BoxConstraints(
                                      minHeight: 40,
                                      maxHeight: 40,
                                      minWidth: 150,
                                      maxWidth: 320,
                                    ),
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 1, horizontal: 1),
                                  ),
                                  keyboardType:
                                      TextInputType.numberWithOptions(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.invertModeMain,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _realizandoTransferencia
                    ? null
                    : () {
                        _mostrarDialogoConfirmacao(context, usuario);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.main,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _realizandoTransferencia
                    ? CircularProgressIndicator(
                        color: AppColors.mainWhite,
                        strokeWidth: 2,
                      )
                    : Text(
                        'Confirmar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.mainWhite,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarDialogoConfirmacao(BuildContext context, Usuario usuario) {
    // Obter o valor atual do controller aqui
    double valorTransferencia = valorController.numberValue;

    if (usuarioDestinatario.cpf.isEmpty ||
        usuarioDestinatario.nome == "Destinatário") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Selecione um destinatário válido.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validar se o valor é maior que zero
    if (valorTransferencia <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Digite um valor válido para transferência.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (valorTransferencia > usuario.saldo) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Saldo insuficiente para transferência.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (usuarioDestinatario.cpf == usuario.cpf) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Você não pode fazer uma transferência para mesma conta'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Transferência'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Destinatário: ${usuarioDestinatario.nome}'),
              Text('CPF: ${usuarioDestinatario.cpf}'),
              Text(
                  'Valor: R\$ ${valorTransferencia.toStringAsFixed(2).replaceAll('.', ',')}'),
              SizedBox(height: 10),
              Text('Deseja confirmar a transferência?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await _realizarTransferencia(usuario, valorTransferencia);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.main,
              ),
              child: Text(
                'Confirmar',
                style: TextStyle(color: AppColors.mainWhite),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _realizarTransferencia(
      Usuario usuario, double valorTransferencia) async {
    setState(() {
      _realizandoTransferencia = true;
    });

    try {
      // Usar o UsuarioService para realizar a transferência
      bool sucesso = await UsuarioService.realizarTransferencia(
        remetente: usuario,
        destinatario: usuarioDestinatario,
        valor: valorTransferencia,
      );

      if (sucesso) {
        // Atualizar o usuário na sessão com os dados mais recentes
        List<Usuario> usuariosAtualizados =
            await UsuarioService.carregarUsuarios();
        Usuario usuarioAtualizado =
            usuariosAtualizados.firstWhere((u) => u.id == usuario.id);
        Sessao.atualizarUsuario(usuarioAtualizado);

        // Limpar campos
        cpfController.clear();
        valorController.text = 'R\$ 0,00';
        setState(() {
          usuarioDestinatario = Usuario(
              "Destinatário", "destinatario@gmail.com", "", "", "", "", "");
          cpfDestinatario = '';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Transferência realizada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao realizar transferência. Tente novamente.'),
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
        _realizandoTransferencia = false;
      });
    }
  }
}
