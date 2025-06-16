import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import '../service/Colors.dart';
import '../service/Usuario.dart';
import '../service/InvestimentoService.dart';
import '../service/Investimento.dart';

class ResgateDialog extends StatefulWidget {
  final Investimento investimento;
  final Usuario usuario;
  final VoidCallback onResgateRealizado;

  const ResgateDialog({
    Key? key,
    required this.investimento,
    required this.usuario,
    required this.onResgateRealizado,
  }) : super(key: key);

  @override
  State<ResgateDialog> createState() => _ResgateDialogState();
}

class _ResgateDialogState extends State<ResgateDialog> {
  final MoneyMaskedTextController _valorController = MoneyMaskedTextController(
    decimalSeparator: ',',
    thousandSeparator: '.',
    initialValue: 0.0,
    leftSymbol: 'R\$ ',
  );
  
  bool _isLoading = false;
  String _resgateOption = 'total';

  @override
  void initState() {
    super.initState();
    // Inicializa o campo com o valor total investido
    _valorController.updateValue(widget.investimento.valorInvestido);
  }

  double _getValorDigitado() {
    String valor = _valorController.text
        .replaceAll('R\$ ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');
    return double.tryParse(valor) ?? 0.0;
  }

  Future<void> _realizarResgate() async {
    double valorResgate = _resgateOption == 'total' 
        ? widget.investimento.valorInvestido 
        : _getValorDigitado();

    if (valorResgate <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Digite um valor válido para resgate'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (valorResgate > widget.investimento.valorInvestido) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Valor de resgate não pode ser maior que o valor investido'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!widget.investimento.podeResgatar()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este investimento ainda não está disponível para resgate'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    bool sucesso = await InvestimentoService.realizarResgate(
      usuario: widget.usuario,
      investimento: widget.investimento,
      valorResgate: valorResgate,
    );

    setState(() {
      _isLoading = false;
    });

    if (sucesso) {
      widget.onResgateRealizado();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Resgate de R\$ ${valorResgate.toStringAsFixed(2).replaceAll('.', ',')} realizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao realizar resgate'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool podeResgatar = widget.investimento.podeResgatar();
    
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
              'Resgatar Investimento',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.invertMode,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.main.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.investimento.nomeAtivo,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.invertMode,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Valor Investido:',
                        style: TextStyle(color: AppColors.invertMode),
                      ),
                      Text(
                        'R\$ ${widget.investimento.valorInvestido.toStringAsFixed(2).replaceAll('.', ',')}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.invertMode,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Status:',
                        style: TextStyle(color: AppColors.invertMode),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: podeResgatar ? Colors.green : Colors.orange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          podeResgatar ? 'Disponível' : 'Bloqueado',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (!podeResgatar) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.orange),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Este investimento ainda não está disponível para resgate.',
                        style: TextStyle(
                          color: AppColors.invertMode,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              const SizedBox(height: 16),
              Column(
                children: [
                  RadioListTile<String>(
                    title: Text(
                      'Resgate Total',
                      style: TextStyle(color: AppColors.invertMode),
                    ),
                    subtitle: Text(
                      'R\$ ${widget.investimento.valorInvestido.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: TextStyle(
                        color: AppColors.main,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: 'total',
                    groupValue: _resgateOption,
                    onChanged: (value) {
                      setState(() {
                        _resgateOption = value!;
                        _valorController.updateValue(widget.investimento.valorInvestido);
                      });
                    },
                    activeColor: AppColors.main,
                  ),
                  RadioListTile<String>(
                    title: Text(
                      'Resgate Parcial',
                      style: TextStyle(color: AppColors.invertMode),
                    ),
                    value: 'parcial',
                    groupValue: _resgateOption,
                    onChanged: (value) {
                      setState(() {
                        _resgateOption = value!;
                        _valorController.updateValue(0.0);
                      });
                    },
                    activeColor: AppColors.main,
                  ),
                ],
              ),
              if (_resgateOption == 'parcial') ...[
                const SizedBox(height: 8),
                TextFormField(
                  controller: _valorController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                  decoration: InputDecoration(
                    labelText: 'Valor do resgate',
                    labelStyle: TextStyle(color: AppColors.invertMode),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.main),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.main.withOpacity(0.5)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: AppColors.main, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.invertMode,
                  ),
                ),
              ],
            ],
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancelar',
                      style: TextStyle(color: AppColors.invertMode),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: (_isLoading || !podeResgatar) ? null : _realizarResgate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.main,
                      foregroundColor: AppColors.mainWhite,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.mainWhite),
                            ),
                          )
                        : const Text(
                            'Resgatar',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
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