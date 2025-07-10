import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/pages/BoletoScreen.dart';
import 'package:flutter_application_1/service/Boleto.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/UsuarioService.dart';

class BoletoPixScreen extends StatefulWidget {
  const BoletoPixScreen({super.key});

  @override
  State<BoletoPixScreen> createState() => _BoletoPixScreenState();
}

class _BoletoPixScreenState extends State<BoletoPixScreen> {
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
        title: 'Boleto - PIX',
        scaffoldKey: scaffoldKey,
        onBackPressed: () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const BoletoScreen()));
        },
      ),
      drawer: const CustomDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // Seção QR Code (sempre visível)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Escaneie o QR Code ou código',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'de barras para pagar boleto',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF333333),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.main,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.qr_code_scanner,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Divisor
            Container(
              height: 1,
              color: Colors.grey[300],
            ),

            const SizedBox(height: 20),
            
            // Seção para inserir código do boleto
            if (!boletoVerificado) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.mainWhite,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Digite o código do boleto para pagar',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.mainBlack,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.main,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextField(
                        controller: boletoController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.mainGray,
                          ),
                        ),
                        style: const TextStyle(color: AppColors.mainBlack),
                        keyboardType: TextInputType.number,
                        maxLength: 10,
                        cursorColor: AppColors.main,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
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
            
            // Seção de informações do boleto e opções de pagamento PIX
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
              
              // Opções de pagamento PIX (apenas se não estiver quitado)
              if (!boletoEncontrado!.isQuitado) ...[
                // Valor disponível para pagamento PIX
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
                              'Valor disponível para pagamento PIX',
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
                          Icons.pix,
                          color: AppColors.mainWhite,
                          size: 28,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Pagar valor total via PIX
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _showPixPaymentConfirmation(context, boletoEncontrado!.valorRestante, 'total'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.main,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Pagar valor restante via PIX',
                      style: TextStyle(
                        color: AppColors.mainWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Pagamento parcial via PIX
                GestureDetector(
                  onTap: () => _showPartialPixPaymentDialog(context),
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
                                'Pagar parcialmente via PIX',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.mainBlack,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Escolha quanto pagar via PIX. Lembre-se do valor mínimo',
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

            const SizedBox(height: 40),
            
            // Botão compartilhar (sempre visível)
            Center(
              child: TextButton.icon(
                onPressed: () {},
                icon: Icon(
                  Icons.share,
                  color: AppColors.invertModeMain,
                ),
                label: Text(
                  'Compartilhar',
                  style: TextStyle(
                    color: AppColors.invertModeMain,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
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

void _showPixPaymentConfirmation(BuildContext context, double amount, String type) async {
  if (!boletoVerificado || boletoEncontrado == null) {
    _showErrorDialog('Por favor, verifique o boleto antes de prosseguir com o pagamento.');
    return;
  }

  if (boletoEncontrado!.isQuitado) {
    _showErrorDialog('Este boleto já está quitado.');
    return;
  }

  // Obter o saldo atual do usuário
  Usuario? usuarioLogado = await UsuarioService.obterUsuarioLogado();
  
  if (usuarioLogado == null) {
    _showErrorDialog('Erro: Usuário não encontrado. Faça login novamente.');
    return;
  }

  double saldoAtual = usuarioLogado.saldo;
  double saldoAposPagamento = saldoAtual - amount;
  bool temSaldoSuficiente = saldoAtual >= amount;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Confirmar Pagamento PIX'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Informações do pagamento
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informações do Pagamento',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text('Valor a pagar: R\$ ${amount.toStringAsFixed(2).replaceAll('.', ',')}'),
                  Text('Boleto código: ${boletoEncontrado!.codigo}'),
                  Text('Valor restante após pagamento: R\$ ${(boletoEncontrado!.valorRestante - amount).toStringAsFixed(2).replaceAll('.', ',')}'),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Informações do saldo
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: temSaldoSuficiente ? Colors.green[50] : Colors.red[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: temSaldoSuficiente ? Colors.green[200]! : Colors.red[200]!
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    temSaldoSuficiente ? 'Saldo Suficiente' : 'Saldo Insuficiente',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: temSaldoSuficiente ? Colors.green[700] : Colors.red[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Seu saldo atual: R\$ ${saldoAtual.toStringAsFixed(2).replaceAll('.', ',')}'),
                  Text(
                    'Saldo após pagamento: R\$ ${saldoAposPagamento.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: TextStyle(
                      color: temSaldoSuficiente ? Colors.green[700] : Colors.red[700],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (!temSaldoSuficiente) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Valor em falta: R\$ ${(amount - saldoAtual).toStringAsFixed(2).replaceAll('.', ',')}',
                      style: TextStyle(
                        color: Colors.red[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            
            if (!temSaldoSuficiente) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.orange[700], size: 20),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Adicione saldo à sua conta antes de prosseguir.',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: temSaldoSuficiente ? () {
              Navigator.of(context).pop();
              _processPixPayment(amount, type);
            } : null, // Desabilita o botão se não tiver saldo suficiente
            style: ElevatedButton.styleFrom(
              backgroundColor: temSaldoSuficiente ? AppColors.main : Colors.grey,
            ),
            child: Text(
              temSaldoSuficiente ? 'Confirmar PIX' : 'Saldo Insuficiente',
              style: const TextStyle(color: AppColors.mainWhite),
            ),
          ),
        ],
      );
    },
  );
}

 void _showPartialPixPaymentDialog(BuildContext context) async {
  if (!boletoVerificado || boletoEncontrado == null) {
    _showErrorDialog('Por favor, verifique o boleto antes de prosseguir com o pagamento.');
    return;
  }

  if (boletoEncontrado!.isQuitado) {
    _showErrorDialog('Este boleto já está quitado.');
    return;
  }

  // Obter o saldo atual do usuário
  Usuario? usuarioLogado = await UsuarioService.obterUsuarioLogado();
  
  if (usuarioLogado == null) {
    _showErrorDialog('Erro: Usuário não encontrado. Faça login novamente.');
    return;
  }

  double saldoAtual = usuarioLogado.saldo;
  double valorMaximoPossivel = saldoAtual < boletoEncontrado!.valorRestante 
    ? saldoAtual 
    : boletoEncontrado!.valorRestante;

  final TextEditingController amountController = TextEditingController();
  
  // Verificar se o usuário tem saldo suficiente para o valor mínimo
  if (saldoAtual < minimumAmount) {
    _showErrorDialog(
      'Saldo insuficiente para pagamento parcial!\n\n'
      'Valor mínimo: R\$ ${minimumAmount.toStringAsFixed(2).replaceAll('.', ',')}\n'
      'Seu saldo: R\$ ${saldoAtual.toStringAsFixed(2).replaceAll('.', ',')}\n'
      'Adicione saldo à sua conta antes de prosseguir.'
    );
    return;
  }
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Pagamento Parcial via PIX'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Informações do boleto
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                    'Informações do Boleto',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Valor restante: R\$ ${boletoEncontrado!.valorRestante.toStringAsFixed(2).replaceAll('.', ',')}'),
                    Text('Valor mínimo: R\$ ${minimumAmount.toStringAsFixed(2).replaceAll('.', ',')}'),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Informações do saldo
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Seu Saldo',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text('Saldo atual: R\$ ${saldoAtual.toStringAsFixed(2).replaceAll('.', ',')}'),
                    Text(
                      'Valor máximo possível: R\$ ${valorMaximoPossivel.toStringAsFixed(2).replaceAll('.', ',')}',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Campo de entrada
              TextField(
                controller: amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Valor a pagar via PIX',
                  prefixText: 'R\$ ',
                  border: const OutlineInputBorder(),
                  helperText: 'Entre R\$ ${minimumAmount.toStringAsFixed(2).replaceAll('.', ',')} e R\$ ${valorMaximoPossivel.toStringAsFixed(2).replaceAll('.', ',')}',
                  helperMaxLines: 2,
                ),
                onChanged: (value) {
                  // Opcional: Validação em tempo real
                },
              ),
            ],
          ),
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
                _showErrorDialog('O valor não pode ser maior que o valor restante do boleto.');
                return;
              }
              
              if (amount > saldoAtual) {
                _showErrorDialog(
                  'Saldo insuficiente!\n\n'
                  'Valor solicitado: R\$ ${amount.toStringAsFixed(2).replaceAll('.', ',')}\n'
                  'Seu saldo: R\$ ${saldoAtual.toStringAsFixed(2).replaceAll('.', ',')}'
                );
                return;
              }
              
              Navigator.of(context).pop();
              _showPixPaymentConfirmation(context, amount, 'partial');
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

  void _processPixPayment(double amount, String type) async {
  if (boletoEncontrado == null) {
    _showErrorDialog('Erro: Boleto não encontrado.');
    return;
  }

  try {
    // Obter o usuário logado
    Usuario? usuarioLogado = await UsuarioService.obterUsuarioLogado();
    
    if (usuarioLogado == null) {
      _showErrorDialog('Erro: Usuário não encontrado. Faça login novamente.');
      return;
    }

    // Verificar se o usuário tem saldo suficiente
    if (usuarioLogado.saldo < amount) {
      _showErrorDialog(
        'Saldo insuficiente!\n\n'
        'Saldo atual: R\$ ${usuarioLogado.saldo.toStringAsFixed(2).replaceAll('.', ',')}\n'
        'Valor necessário: R\$ ${amount.toStringAsFixed(2).replaceAll('.', ',')}\n'
        'Valor em falta: R\$ ${(amount - usuarioLogado.saldo).toStringAsFixed(2).replaceAll('.', ',')}'
      );
      return;
    }

    // Tentar processar o pagamento do boleto
    bool sucessoPagamentoBoleto = boletoEncontrado!.pagarValor(amount);
    
    if (!sucessoPagamentoBoleto) {
      _showErrorDialog('Erro ao processar pagamento do boleto.');
      return;
    }

    // Se o pagamento do boleto foi bem-sucedido, debitar do saldo do usuário
    double novoSaldo = usuarioLogado.saldo - amount;
    
    // Atualizar o saldo do usuário no banco de dados
    await UsuarioService.salvarSaldoUsuario(usuarioLogado.id, novoSaldo);
    
    // Incrementar o score do usuário (bonus por pagar boleto)
    int novoScore = usuarioLogado.score + 5; // 5 pontos por pagamento de boleto
    await UsuarioService.salvarScoreUsuario(usuarioLogado.id, novoScore);
    
    // Atualizar o boleto na lista global (simula persistência)
    atualizarBoleto(boletoEncontrado!);
    
    setState(() {
      // Força a atualização da interface
    });
    
    // Mostrar mensagem de sucesso
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Pagamento PIX realizado com sucesso!\n\n'
          'Valor pago: R\$ ${amount.toStringAsFixed(2).replaceAll('.', ',')}\n'
          'Seu novo saldo: R\$ ${novoSaldo.toStringAsFixed(2).replaceAll('.', ',')}\n'
          'Valor restante do boleto: R\$ ${boletoEncontrado!.valorRestante.toStringAsFixed(2).replaceAll('.', ',')}\n'
          '+5 pontos no seu score!'
        ),
        backgroundColor: Colors.green[600],
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
    
    print(' Pagamento PIX processado com sucesso:');
    print('   - Valor: R\$ $amount');
    print('   - Usuário: ${usuarioLogado.nome}');
    print('   - Saldo anterior: R\$ ${usuarioLogado.saldo}');
    print('   - Novo saldo: R\$ $novoSaldo');
    print('   - Boleto código: ${boletoEncontrado!.codigo}');
    print('   - Valor restante boleto: R\$ ${boletoEncontrado!.valorRestante}');
    
  } catch (e) {
    print(' Erro ao processar pagamento PIX: $e');
    _showErrorDialog('Erro inesperado ao processar pagamento. Tente novamente.');
  }
}
}