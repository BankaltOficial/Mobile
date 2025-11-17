// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables, sized_box_for_whitespace

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/pages/InicialScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/Sessao.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/UsuarioService.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmprestimoScreen extends StatefulWidget {
  const EmprestimoScreen({super.key});

  @override
  State<EmprestimoScreen> createState() => _EmprestimoScreenState();
}

class _EmprestimoScreenState extends State<EmprestimoScreen> {
  // Controllers para os campos de entrada
  final TextEditingController _loanAmountController = TextEditingController();
  final TextEditingController _interestRateController = TextEditingController();
  final TextEditingController _paymentDayController = TextEditingController();
  Usuario usuario = Sessao.getUsuario()!;

  // Variáveis do empréstimo
  double loanAmount = 15000.00;
  double interestRate = 7.97;
  int installments = 3;
  String paymentDay = "10";

  // Estado de carregamento
  bool _isProcessing = false;

  // Valores calculados
  double get monthlyRate => interestRate / 100 / 12;
  double get installmentValue {
    if (monthlyRate == 0) return loanAmount / installments;
    return loanAmount *
        (monthlyRate * pow(1 + monthlyRate, installments)) /
        (pow(1 + monthlyRate, installments) - 1);
  }

  double get totalAmount => installmentValue * installments;

  @override
  void initState() {
    super.initState();
    _loanAmountController.text = loanAmount.toStringAsFixed(2);
    _interestRateController.text = interestRate.toStringAsFixed(2);
    _paymentDayController.text = paymentDay;
  }

  @override
  void dispose() {
    _loanAmountController.dispose();
    _interestRateController.dispose();
    _paymentDayController.dispose();
    super.dispose();
  }

  void _updateLoanAmount(String value) {
    setState(() {
      loanAmount = double.tryParse(value.replaceAll(',', '.')) ?? loanAmount;
    });
  }

  void _updateInterestRate(String value) {
    setState(() {
      interestRate =
          double.tryParse(value.replaceAll(',', '.')) ?? interestRate;
    });
  }

  void _updatePaymentDay(String value) {
    setState(() {
      paymentDay = value;
    });
  }

  String _formatCurrency(double value) {
    return value.toStringAsFixed(2).replaceAll('.', ',');
  }

  List<String> _getPaymentDates() {
    List<String> dates = [];
    DateTime now = DateTime.now();
    int day = int.tryParse(paymentDay) ?? 10;

    for (int i = 1; i <= installments; i++) {
      DateTime paymentDate = DateTime(now.year, now.month + i, day);
      dates.add('${paymentDate.day.toString().padLeft(2, '0')}/'
          '${paymentDate.month.toString().padLeft(2, '0')}/'
          '${paymentDate.year}');
    }
    return dates;
  }

  // ✨ MÉTODO SIMPLIFICADO - Apenas credita o valor na conta
  Future<void> _processarEmprestimo() async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    try {
      // Validações básicas
      double valorEmprestimo =
          double.tryParse(_loanAmountController.text.replaceAll(',', '.')) ??
              loanAmount;

      if (valorEmprestimo <= 0) {
        _mostrarErro('Valor do empréstimo deve ser maior que zero.');
        return;
      }

      if (valorEmprestimo > 100000) {
        _mostrarErro('Valor máximo de empréstimo: R\$ 100.000,00');
        return;
      }

      print('🔄 Processando empréstimo...');
      print('   Cliente ID: ${usuario.id}');
      print('   Valor: R\$ $valorEmprestimo');
      print('   Saldo atual: R\$ ${usuario.saldo}');

      // Calcular novo saldo
      double novoSaldo = usuario.saldo + valorEmprestimo;
      print('   Novo saldo: R\$ $novoSaldo');

      // Tentar atualizar no servidor (em background, não bloqueia se falhar)
      _atualizarSaldoNaApi(usuario.id, novoSaldo).catchError((e) {
        print('⚠️ Aviso: Não foi possível sincronizar com servidor: $e');
        // Continua mesmo se falhar
      });

      // Atualizar localmente (SharedPreferences) - SEMPRE funciona
      await UsuarioService.salvarSaldoUsuario(usuario.id, novoSaldo);
      print('✅ Saldo atualizado localmente!');

      // Atualizar objeto do usuário e sessão
      usuario.saldo = novoSaldo;
      Sessao.atualizarUsuario(usuario);

      print('✅ Empréstimo concluído com sucesso!');

      // Fechar dialog
      if (mounted) {
        Navigator.pop(context);

        // Mostrar sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.white, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Empréstimo Aprovado!',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text('Valor creditado: R\$ ${_formatCurrency(valorEmprestimo)}'),
                Text('Novo saldo: R\$ ${_formatCurrency(novoSaldo)}'),
                SizedBox(height: 4),
                Text(
                  '${installments}x de R\$ ${_formatCurrency(installmentValue)}',
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 5),
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Voltar para tela inicial após 1 segundo
        await Future.delayed(Duration(seconds: 1));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => InicialScreen()),
          );
        }
      }
    } catch (e) {
      print('❌ Erro ao processar empréstimo: $e');
      if (mounted) {
        Navigator.pop(context);
        _mostrarErro('Erro ao processar empréstimo: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  // Método para atualizar saldo na API (executa em background)
  Future<void> _atualizarSaldoNaApi(int clienteId, double novoSaldo) async {
    try {
      const String baseUrl = 'http://10.0.2.2:8080/apiCliente';
      
      print('📡 Tentando sincronizar com servidor...');
      
      // Buscar dados completos do usuário
      final usuarioCompleto = await UsuarioService.buscarPorCpfApi(this.usuario.cpf)
          .timeout(Duration(seconds: 5));
      
      if (usuarioCompleto == null) {
        print('⚠️ Usuário não encontrado na API');
        return;
      }

      // Atualizar o saldo
      usuarioCompleto.saldo = novoSaldo;
      final dadosJson = usuarioCompleto.toJson();

      // Tentar PATCH (método correto do seu backend)
      print('📡 PATCH $baseUrl/atualizar');
      final response = await http.patch(
        Uri.parse('$baseUrl/atualizar'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(dadosJson),
      ).timeout(Duration(seconds: 5));

      if (response.statusCode == 200 || 
          response.statusCode == 204 || 
          response.statusCode == 201) {
        print('✅ Saldo sincronizado com sucesso no servidor!');
      } else {
        print('⚠️ Servidor retornou: ${response.statusCode}');
      }
    } catch (e) {
      print('⚠️ Não foi possível sincronizar com servidor: $e');
      print('   (Saldo foi atualizado localmente)');
      // Não lança exceção - permite que o empréstimo continue
    }
  }

  void _mostrarErro(String mensagem) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline, color: Colors.white),
            SizedBox(width: 8),
            Expanded(child: Text(mensagem)),
          ],
        ),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
      ),
    );

    setState(() {
      _isProcessing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        title: 'Empréstimo',
        scaffoldKey: scaffoldKey,
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const InicialScreen()),
          );
        },
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),

              // Valor do empréstimo editável
              Center(
                child: Column(
                  children: [
                    InkWell(
                      onTap: () => _showAmountDialog(),
                      child: Column(
                        children: [
                          Text(
                            'R\$ ${_formatCurrency(loanAmount)}',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.invertModeMain,
                              decoration: TextDecoration.underline,
                              decorationColor: AppColors.invertModeMain,
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Simular empréstimo',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.invertModeGray,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.edit,
                                size: 16,
                                color: AppColors.invertModeGray,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Taxa de juros editável
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tipo de empréstimo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.invertMode,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Pessoal',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.mainGray,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () => _showInterestRateDialog(),
                        child: Row(
                          children: [
                            Text(
                              'Taxa = ${_formatCurrency(interestRate)}%',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.invertModeMain,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.edit,
                              size: 16,
                              color: AppColors.invertModeMain,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 25),

              // Total calculado automaticamente
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: AppColors.main,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      'Total a pagar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'R\$ ${_formatCurrency(totalAmount)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 25),

              // Número de parcelas selecionável
              Text(
                'Número de parcelas',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.invertMode,
                ),
              ),
              SizedBox(height: 8),
              _buildInstallmentSelector(),

              SizedBox(height: 25),

              // Dia de pagamento editável
              Text(
                'Dia de vencimento',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.invertMode,
                ),
              ),
              SizedBox(height: 8),
              InkWell(
                onTap: () => _showPaymentDayDialog(),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Todo dia $paymentDay de cada mês',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.mainGray,
                        ),
                      ),
                      Icon(
                        Icons.edit,
                        size: 16,
                        color: AppColors.mainGray,
                      ),
                    ],
                  ),
                ),
              ),

              // Mostrar datas específicas
              SizedBox(height: 15),
              ExpansionTile(
                title: Text(
                  'Ver datas de vencimento',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.invertModeMain,
                  ),
                ),
                collapsedBackgroundColor: AppColors.themeColor,
                iconColor: AppColors.invertModeMain,
                collapsedIconColor: AppColors.invertModeMain,
                backgroundColor: AppColors.themeColor,
                children: [
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _getPaymentDates().asMap().entries.map((entry) {
                        int index = entry.key;
                        String date = entry.value;
                        return Padding(
                          padding: EdgeInsets.only(bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${index + 1}ª parcela: $date',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.mainGray,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'R\$ ${_formatCurrency(installmentValue)}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.main,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40),

              // Botão de confirmação
              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isProcessing
                      ? null
                      : () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Row(
                                  children: [
                                    Icon(Icons.account_balance_wallet,
                                        color: AppColors.main),
                                    SizedBox(width: 8),
                                    Text('Confirmar Empréstimo'),
                                  ],
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _buildInfoRow('Valor a receber',
                                        'R\$ ${_formatCurrency(loanAmount)}'),
                                    _buildInfoRow('Taxa de juros',
                                        '${_formatCurrency(interestRate)}% a.a.'),
                                    _buildInfoRow('Parcelas',
                                        '${installments}x de R\$ ${_formatCurrency(installmentValue)}'),
                                    _buildInfoRow('Total a pagar',
                                        'R\$ ${_formatCurrency(totalAmount)}'),
                                    _buildInfoRow(
                                        'Vencimento', 'Todo dia $paymentDay'),
                                    Divider(height: 24),
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: Colors.green.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.green,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(Icons.check_circle_outline,
                                              color: Colors.green, size: 20),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              'O valor será creditado imediatamente em sua conta!',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.green[800],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: _isProcessing
                                        ? null
                                        : () => Navigator.pop(context),
                                    child: Text('Cancelar'),
                                  ),
                                  ElevatedButton(
                                    onPressed:
                                        _isProcessing ? null : _processarEmprestimo,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.main,
                                      disabledBackgroundColor:
                                          Colors.grey[400],
                                    ),
                                    child: _isProcessing
                                        ? SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                            ),
                                          )
                                        : Text('Confirmar',
                                            style:
                                                TextStyle(color: Colors.white)),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.main,
                    disabledBackgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: _isProcessing
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Processando...',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          'Solicitar Empréstimo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.invertMode,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstallmentSelector() {
    List<int> options = [1, 3, 6, 12, 18, 24, 36, 48];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<int>(
          value: installments,
          isExpanded: true,
          items: options.map((int value) {
            // Recalcular valor da parcela para cada opção
            double monthlyRateCalc = interestRate / 100 / 12;
            double parcelaCalc = monthlyRateCalc == 0
                ? loanAmount / value
                : loanAmount *
                    (monthlyRateCalc * pow(1 + monthlyRateCalc, value)) /
                    (pow(1 + monthlyRateCalc, value) - 1);
            
            return DropdownMenuItem<int>(
              value: value,
              child: Text(
                '${value}x de R\$ ${_formatCurrency(parcelaCalc)}',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.mainGray,
                ),
              ),
            );
          }).toList(),
          onChanged: (int? newValue) {
            setState(() {
              installments = newValue ?? installments;
            });
          },
        ),
      ),
    );
  }

  void _showAmountDialog() {
    _loanAmountController.text = loanAmount.toStringAsFixed(2);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Valor do Empréstimo'),
          content: TextField(
            controller: _loanAmountController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: 'Valor (R\$)',
              prefixText: 'R\$ ',
              border: OutlineInputBorder(),
              helperText: 'Máximo: R\$ 100.000,00',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateLoanAmount(_loanAmountController.text);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.main),
              child: Text('Confirmar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showInterestRateDialog() {
    _interestRateController.text = interestRate.toStringAsFixed(2);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Taxa de Juros'),
          content: TextField(
            controller: _interestRateController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
            ],
            decoration: InputDecoration(
              labelText: 'Taxa anual (%)',
              suffixText: '% a.a.',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateInterestRate(_interestRateController.text);
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.main),
              child: Text('Confirmar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showPaymentDayDialog() {
    _paymentDayController.text = paymentDay;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Dia de Pagamento'),
          content: TextField(
            controller: _paymentDayController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(2),
            ],
            decoration: InputDecoration(
              labelText: 'Dia do mês (1-31)',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                int? day = int.tryParse(_paymentDayController.text);
                if (day != null && day >= 1 && day <= 31) {
                  _updatePaymentDay(_paymentDayController.text);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Digite um dia válido (1-31)'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.main),
              child: Text('Confirmar', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}