import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import '../service/Colors.dart';
import '../service/Usuario.dart';
import '../service/InvestimentoService.dart';

class InvestirDialog extends StatefulWidget {
  final String nomeAtivo;
  final String tipoAtivo;
  final String investimentoMinimo;
  final String resgateDisponivel;
  final Usuario usuario;
  final VoidCallback onInvestimentoRealizado;

  const InvestirDialog({
    Key? key,
    required this.nomeAtivo,
    required this.tipoAtivo,
    required this.investimentoMinimo,
    required this.resgateDisponivel,
    required this.usuario,
    required this.onInvestimentoRealizado,
  }) : super(key: key);

  @override
  State<InvestirDialog> createState() => _InvestirDialogState();
}

class _InvestirDialogState extends State<InvestirDialog> {
  final MoneyMaskedTextController _valorController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    initialValue: 0.0,
    leftSymbol: 'R\$ ',
  );
  
  bool _isLoading = false;

  double _getValorMinimo() {
    String valor = widget.investimentoMinimo.replaceAll('R\$ ', '').replaceAll(',', '.');
    return double.tryParse(valor) ?? 0.0;
  }

  double _getValorDigitado() {
    String valor = _valorController.text
        .replaceAll('R\$ ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');
    return double.tryParse(valor) ?? 0.0;
  }

  Future<void> _realizarInvestimento() async {
    double valorInvestimento = _getValorDigitado();
    double valorMinimo = _getValorMinimo();

    if (valorInvestimento < valorMinimo) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Valor mínimo para investimento é ${widget.investimentoMinimo}'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (valorInvestimento > widget.usuario.saldo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saldo insuficiente'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    bool sucesso = await InvestimentoService.realizarInvestimento(
      usuario: widget.usuario,
      nomeAtivo: widget.nomeAtivo,
      tipoAtivo: widget.tipoAtivo,
      valor: valorInvestimento,
      resgateDisponivel: widget.resgateDisponivel,
    );

    setState(() {
      _isLoading = false;
    });

    if (sucesso) {
      widget.onInvestimentoRealizado();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Investimento realizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao realizar investimento'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.theme,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Investir em ${widget.nomeAtivo}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.invertMode,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.main.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Inv. Mínimo:',
                        style: TextStyle(color: AppColors.invertMode),
                      ),
                      Text(
                        widget.investimentoMinimo,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.invertMode,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Seu Saldo:',
                        style: TextStyle(color: AppColors.invertMode),
                      ),
                      Text(
                        'R\$ ${widget.usuario.saldo.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.invertMode,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Quanto você quer investir?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.invertMode,
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _valorController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.main,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: AppColors.invertMode),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _realizarInvestimento,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.main,
                      foregroundColor: AppColors.mainWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Investir'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}