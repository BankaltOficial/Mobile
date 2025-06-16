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
import 'package:flutter_application_1/service/UsuarioService.dart'; // Adicione esta importação

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

  // Método para processar o empréstimo com persistência
  Future<void> _processarEmprestimo() async {
    try {
      // Obter o valor do empréstimo do controller ou usar o valor padrão
      double valorEmprestimo =
          double.tryParse(_loanAmountController.text.replaceAll(',', '.')) ??
              loanAmount;

      if (valorEmprestimo <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Valor do empréstimo deve ser maior que zero.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
        return;
      }

      // Atualizar o saldo do usuário
      double novoSaldo = usuario.saldo + valorEmprestimo;

      // Persistir a mudança usando o UsuarioService
      await UsuarioService.salvarSaldoUsuario(usuario.id, novoSaldo);

      // Atualizar o objeto usuario local
      usuario.saldo = novoSaldo;

      // Atualizar a sessão
      Sessao.atualizarUsuario(usuario);

      Navigator.pop(context); // Fechar o dialog

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Empréstimo de R\$ ${_formatCurrency(valorEmprestimo)} aprovado e creditado em sua conta!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
    } catch (e) {
      Navigator.pop(context); // Fechar o dialog em caso de erro

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao processar empréstimo: $e'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }
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
                      'Total',
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
                'Datas para parcelas',
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
                        'Todo mês dia $paymentDay',
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
                          child: Text(
                            '${index + 1}ª parcela: $date - R\$ ${_formatCurrency(installmentValue)}',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.mainGray,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 40),

              Container(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirmar Empréstimo'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Valor: R\$ ${_formatCurrency(loanAmount)}'),
                              Text(
                                  'Taxa de juros: ${_formatCurrency(interestRate)}% a.a.'),
                              Text(
                                  'Parcelas: ${installments}x de R\$ ${_formatCurrency(installmentValue)}'),
                              Text(
                                  'Total: R\$ ${_formatCurrency(totalAmount)}'),
                              Text('Vencimento: todo dia $paymentDay'),
                              SizedBox(height: 16),
                              Text(
                                'O valor será creditado imediatamente em sua conta.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.main,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancelar'),
                            ),
                            ElevatedButton(
                              onPressed: _processarEmprestimo,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.main,
                              ),
                              child: Text('Confirmar',
                                  style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.main,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Confirmar',
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
            // Usar o installmentValue já calculado corretamente
            return DropdownMenuItem<int>(
              value: value,
              child: Text(
                '${value}x de R\$ ${_formatCurrency(installmentValue)}',
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
