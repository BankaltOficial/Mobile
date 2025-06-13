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
  final double totalAmount = 350.90;
  final double minimumAmount = 50.00;

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
                          'Total ao ser pago',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.mainGray,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'R\$ ${totalAmount.toStringAsFixed(2).replaceAll('.', ',')}',
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
                onPressed: () => _showPaymentConfirmation(context, totalAmount, 'total'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.main,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Pagar o total',
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
                            'Parcelar Fatura',
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
        ),
      ),
    );
  }

  void _showPaymentConfirmation(BuildContext context, double amount, String type) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Pagamento'),
          content: Text(
            'Deseja confirmar o pagamento de R\$ ${amount.toStringAsFixed(2).replaceAll('.', ',')}?'
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
              Text('Valor máximo: R\$ ${totalAmount.toStringAsFixed(2).replaceAll('.', ',')}'),
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
                  _showErrorDialog(context, 'Por favor, insira um valor válido.');
                  return;
                }
                
                if (amount < minimumAmount) {
                  _showErrorDialog(context, 'O valor deve ser maior que R\$ ${minimumAmount.toStringAsFixed(2).replaceAll('.', ',')}');
                  return;
                }
                
                if (amount > totalAmount) {
                  _showErrorDialog(context, 'O valor não pode ser maior que o total da fatura.');
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
    final List<int> installmentOptions = [2, 3, 4, 5, 6, 12];
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Parcelar Fatura'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Escolha o número de parcelas:'),
              const SizedBox(height: 16),
              ...installmentOptions.map((installments) {
                final double installmentValue = totalAmount / installments;
                return ListTile(
                  title: Text('${installments}x de R\$ ${installmentValue.toStringAsFixed(2).replaceAll('.', ',')}'),
                  subtitle: Text('Total: R\$ ${totalAmount.toStringAsFixed(2).replaceAll('.', ',')}'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showPaymentConfirmation(context, totalAmount, '${installments}x installment');
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

  void _showErrorDialog(BuildContext context, String message) {
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
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pagamento de R\$ ${amount.toStringAsFixed(2).replaceAll('.', ',')} processado com sucesso!'
        ),
        backgroundColor: AppColors.main,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}