import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/BoletoScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/Boleto.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';

class BoletoCartaoScreen extends StatefulWidget {
  const BoletoCartaoScreen({super.key});

  @override
  State<BoletoCartaoScreen> createState() => _BoletoCartaoScreenState();
}

class _BoletoCartaoScreenState extends State<BoletoCartaoScreen> {
  final TextEditingController boletoController = TextEditingController();
  Boleto? boletoEncontrado;
  double minimumAmount = 50.00;
  bool boletoVerificado = false;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
        title: 'Boleto', 
        subtitle: 'Pagamento de fatura de cartão', 
        scaffoldKey: scaffoldKey, 
        onBackPressed: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const BoletoScreen()));
        }
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Seção para inserir código do boleto
            if (!boletoVerificado) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8F5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Código do Boleto',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.mainGray,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: boletoController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Digite o código do boleto',
                        border: OutlineInputBorder(),
                      ),
                      maxLength: 10,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _verificarBoleto,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.main,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Verificar Boleto',
                          style: TextStyle(
                            color: AppColors.mainWhite,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            // Seção de informações do boleto e opções de pagamento
            if (boletoVerificado && boletoEncontrado != null) ...[
              // Informações do boleto
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: boletoEncontrado!.isQuitado 
                    ? const Color(0xFFE8F5E8) 
                    : const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          boletoEncontrado!.isQuitado ? 'Boleto Quitado' : 'Boleto Encontrado',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: boletoEncontrado!.isQuitado 
                              ? Colors.green[700] 
                              : AppColors.mainBlack,
                          ),
                        ),
                        const Spacer(),
                        if (boletoEncontrado!.isQuitado)
                          Icon(
                            Icons.check_circle,
                            color: Colors.green[700],
                            size: 24,
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Nome: ${boletoEncontrado!.nomePagante}',
                      style: const TextStyle(fontSize: 14, color: AppColors.mainGray),
                    ),
                    Text(
                      'CPF: ${boletoEncontrado!.cpfPagante}',
                      style: const TextStyle(fontSize: 14, color: AppColors.mainGray),
                    ),
                    Text(
                      'Código: ${boletoEncontrado!.codigo}',
                      style: const TextStyle(fontSize: 14, color: AppColors.mainGray),
                    ),
                    const SizedBox(height: 12),
                    const Divider(),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Valor Total',
                              style: TextStyle(fontSize: 12, color: AppColors.mainGray),
                            ),
                            Text(
                              'R\$ ${boletoEncontrado!.total.toStringAsFixed(2).replaceAll('.', ',')}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainBlack,
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Valor Pago',
                              style: TextStyle(fontSize: 12, color: AppColors.mainGray),
                            ),
                            Text(
                              'R\$ ${boletoEncontrado!.valorPago.toStringAsFixed(2).replaceAll('.', ',')}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Valor Restante',
                              style: TextStyle(fontSize: 12, color: AppColors.mainGray),
                            ),
                            Text(
                              'R\$ ${boletoEncontrado!.valorRestante.toStringAsFixed(2).replaceAll('.', ',')}',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: boletoEncontrado!.valorRestante > 0 
                                  ? Colors.orange[700] 
                                  : Colors.green[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              boletoVerificado = false;
                              boletoEncontrado = null;
                              boletoController.clear();
                            });
                          },
                          child: Text(
                            'Alterar Boleto',
                            style: TextStyle(color: AppColors.main),
                          ),
                        ),
                        TextButton(
                          onPressed: _atualizarInformacoes,
                          child: Text(
                            'Atualizar',
                            style: TextStyle(color: AppColors.main),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Opções de pagamento (apenas se não estiver quitado)
              if (!boletoEncontrado!.isQuitado) ...[
                // Total amount container
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8E8F5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Valor disponível para pagamento',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: AppColors.mainGray,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'R\$ ${boletoEncontrado!.valorRestante.toStringAsFixed(2).replaceAll('.', ',')}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.mainBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.main,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.attach_money,
                          color: AppColors.mainWhite,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Pay full amount button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _showPaymentConfirmation(context, boletoEncontrado!.valorRestante, 'total'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.main,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Pagar valor restante',
                      style: TextStyle(
                        color: AppColors.mainWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Partial payment option
                GestureDetector(
                  onTap: () => _showPartialPaymentDialog(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E8F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pagar parcialmente',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mainBlack,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Escolha quanto pagar. Lembre-se do valor mínimo',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.mainGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.mainGray,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Installment payment option
                GestureDetector(
                  onTap: () => _showInstallmentDialog(context),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8E8F5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Parcelar Valor Restante',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mainBlack,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Pague um valor fixo de entrada e, nas próximas faturas, as parcelas que selecionar',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.mainGray,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.mainGray,
                          size: 24,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              
              // Mensagem se estiver quitado
              if (boletoEncontrado!.isQuitado) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 48,
                        color: Colors.green[700],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Boleto Quitado!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[700],
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Este boleto já foi pago integralmente.',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.mainGray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  void _verificarBoleto() {
    final codigo = int.tryParse(boletoController.text);

    if (codigo == null) {
      _showErrorDialog('Código inválido. Digite um número válido.');
      return;
    }

    try {
      boletoEncontrado = buscarBoleto(codigo);
      
      if (boletoEncontrado != null) {
        setState(() {
          boletoVerificado = true;
        });
        
        _showSuccessDialog('Boleto encontrado com sucesso!');
      }
    } catch (e) {
      _showErrorDialog('Boleto não encontrado. Verifique o código e tente novamente.');
    }
  }

  void _atualizarInformacoes() {
    if (boletoEncontrado != null) {
      try {
        // Recarrega o boleto para obter informações atualizadas
        Boleto boletoAtualizado = buscarBoleto(boletoEncontrado!.codigo);
        setState(() {
          boletoEncontrado = boletoAtualizado;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Informações atualizadas com sucesso!'),
            backgroundColor: AppColors.main,
            duration: Duration(seconds: 2),
          ),
        );
      } catch (e) {
        _showErrorDialog('Erro ao atualizar informações.');
      }
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sucesso'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showPaymentConfirmation(BuildContext context, double amount, String type) {
    if (!boletoVerificado || boletoEncontrado == null) {
      _showErrorDialog('Por favor, verifique o boleto antes de prosseguir com o pagamento.');
      return;
    }

    if (boletoEncontrado!.isQuitado) {
      _showErrorDialog('Este boleto já está quitado.');
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Pagamento'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Valor a pagar: R\$ ${amount.toStringAsFixed(2).replaceAll('.', ',')}'),
              const SizedBox(height: 8),
              Text('Valor restante após pagamento: R\$ ${(boletoEncontrado!.valorRestante - amount).toStringAsFixed(2).replaceAll('.', ',')}'),
              const SizedBox(height: 16),
              const Text('Deseja confirmar este pagamento?'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _processPayment(amount, type);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.main,
              ),
              child: const Text(
                'Confirmar',
                style: TextStyle(color: AppColors.mainWhite),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showPartialPaymentDialog(BuildContext context) {
    if (!boletoVerificado || boletoEncontrado == null) {
      _showErrorDialog('Por favor, verifique o boleto antes de prosseguir com o pagamento.');
      return;
    }

    if (boletoEncontrado!.isQuitado) {
      _showErrorDialog('Este boleto já está quitado.');
      return;
    }

    final TextEditingController amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pagamento Parcial'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Valor mínimo: R\$ ${minimumAmount.toStringAsFixed(2).replaceAll('.', ',')}'),
              Text('Valor máximo: R\$ ${boletoEncontrado!.valorRestante.toStringAsFixed(2).replaceAll('.', ',')}'),
              Text('Valor restante: R\$ ${boletoEncontrado!.valorRestante.toStringAsFixed(2).replaceAll('.', ',')}'),
              const SizedBox(height: 16),
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Valor a pagar',
                  prefixText: 'R\$ ',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final String input = amountController.text.replaceAll(',', '.');
                final double? amount = double.tryParse(input);
                
                if (amount == null) {
                  _showErrorDialog('Por favor, insira um valor válido.');
                  return;
                }
                
                if (amount < minimumAmount) {
                  _showErrorDialog('O valor deve ser maior que R\$ ${minimumAmount.toStringAsFixed(2).replaceAll('.', ',')}');
                  return;
                }
                
                if (amount > boletoEncontrado!.valorRestante) {
                  _showErrorDialog('O valor não pode ser maior que o valor restante.');
                  return;
                }
                
                Navigator.of(context).pop();
                _showPaymentConfirmation(context, amount, 'partial');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.main,
              ),
              child: const Text(
                'Continuar',
                style: TextStyle(color: AppColors.mainWhite),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showInstallmentDialog(BuildContext context) {
    if (!boletoVerificado || boletoEncontrado == null) {
      _showErrorDialog('Por favor, verifique o boleto antes de prosseguir com o pagamento.');
      return;
    }

    if (boletoEncontrado!.isQuitado) {
      _showErrorDialog('Este boleto já está quitado.');
      return;
    }

    final List<int> installmentOptions = [2, 3, 4, 5, 6, 12];
    final double valorRestante = boletoEncontrado!.valorRestante;
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Parcelar Valor Restante'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Valor a parcelar: R\$ ${valorRestante.toStringAsFixed(2).replaceAll('.', ',')}'),
              const SizedBox(height: 16),
              const Text('Escolha o número de parcelas:'),
              const SizedBox(height: 16),
              ...installmentOptions.map((installments) {
                final double installmentValue = valorRestante / installments;
                return ListTile(
                  title: Text('${installments}x de R\$ ${installmentValue.toStringAsFixed(2).replaceAll('.', ',')}'),
                  subtitle: Text('Total: R\$ ${valorRestante.toStringAsFixed(2).replaceAll('.', ',')}'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showPaymentConfirmation(context, valorRestante, '${installments}x installment');
                  },
                );
              }).toList(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erro'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _processPayment(double amount, String type) {
    if (boletoEncontrado != null) {
      bool sucesso = boletoEncontrado!.pagarValor(amount);
      
      if (sucesso) {
        setState(() {
          // Força a atualização da interface
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Pagamento de R\$ ${amount.toStringAsFixed(2).replaceAll('.', ',')} processado com sucesso!\n'
              'Valor restante: R\$ ${boletoEncontrado!.valorRestante.toStringAsFixed(2).replaceAll('.', ',')}'
            ),
            backgroundColor: AppColors.main,
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        _showErrorDialog('Erro ao processar pagamento.');
      }
    }
  }
}