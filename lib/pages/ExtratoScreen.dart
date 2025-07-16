import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/InicialScreen.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/UsuarioService.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';

class ExtratoScreen extends StatefulWidget {
  const ExtratoScreen({Key? key}) : super(key: key);

  @override
  _ExtratoScreenState createState() => _ExtratoScreenState();
}

class _ExtratoScreenState extends State<ExtratoScreen> {
  Usuario? usuarioLogado;
  List<TransacaoExtrato> transacoes = [];
  bool isLoading = true;
  String filtroSelecionado = 'Todos';

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() {
      isLoading = true;
    });

    try {
      usuarioLogado = await UsuarioService.obterUsuarioLogado();
      if (usuarioLogado != null) {
        await _carregarTransacoes();
      }
    } catch (e) {
      print('Erro ao carregar dados: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _carregarTransacoes() async {
    // Simulando transações baseadas no histórico do usuário
    // Em uma aplicação real, isso viria de um banco de dados
    transacoes = _gerarTransacoesSimuladas();
    setState(() {});
  }

  List<TransacaoExtrato> _gerarTransacoesSimuladas() {
    final now = DateTime.now();
    return [
      TransacaoExtrato(
        id: '1',
        tipo: TipoTransacao.PIX_RECEBIDO,
        valor: 150.00,
        data: now.subtract(Duration(hours: 2)),
        descricao: 'PIX recebido de João Silva',
        chavePix: 'joao@email.com',
        saldoAnterior: usuarioLogado!.saldo - 150.00,
        saldoPosterior: usuarioLogado!.saldo,
      ),
      TransacaoExtrato(
        id: '2',
        tipo: TipoTransacao.PIX_ENVIADO,
        valor: 75.50,
        data: now.subtract(Duration(days: 1)),
        descricao: 'PIX para Maria Santos',
        chavePix: 'maria@email.com',
        saldoAnterior: usuarioLogado!.saldo + 75.50,
        saldoPosterior: usuarioLogado!.saldo,
      ),
      TransacaoExtrato(
        id: '3',
        tipo: TipoTransacao.TRANSFERENCIA_ENVIADA,
        valor: 200.00,
        data: now.subtract(Duration(days: 2)),
        descricao: 'Transferência para Igor Suracci',
        contaDestino: 'Conta: 1234-5',
        saldoAnterior: usuarioLogado!.saldo + 200.00,
        saldoPosterior: usuarioLogado!.saldo,
      ),
      TransacaoExtrato(
        id: '4',
        tipo: TipoTransacao.DEPOSITO,
        valor: 500.00,
        data: now.subtract(Duration(days: 3)),
        descricao: 'Depósito em conta',
        saldoAnterior: usuarioLogado!.saldo - 500.00,
        saldoPosterior: usuarioLogado!.saldo,
      ),
      TransacaoExtrato(
        id: '5',
        tipo: TipoTransacao.PAGAMENTO_CARTAO,
        valor: 89.90,
        data: now.subtract(Duration(days: 4)),
        descricao: 'Pagamento com cartão - Loja ABC',
        numeroCartao: usuarioLogado!.numeroCartao,
        saldoAnterior: usuarioLogado!.saldo + 89.90,
        saldoPosterior: usuarioLogado!.saldo,
      ),
      TransacaoExtrato(
        id: '6',
        tipo: TipoTransacao.TRANSFERENCIA_RECEBIDA,
        valor: 300.00,
        data: now.subtract(Duration(days: 5)),
        descricao: 'Transferência recebida de Flakes',
        contaOrigem: 'Conta: 9876-1',
        saldoAnterior: usuarioLogado!.saldo - 300.00,
        saldoPosterior: usuarioLogado!.saldo,
      ),
    ];
  }

  List<TransacaoExtrato> _filtrarTransacoes() {
    if (filtroSelecionado == 'Todos') {
      return transacoes;
    }

    return transacoes.where((transacao) {
      switch (filtroSelecionado) {
        case 'PIX':
          return transacao.tipo == TipoTransacao.PIX_ENVIADO ||
              transacao.tipo == TipoTransacao.PIX_RECEBIDO;
        case 'Transferências':
          return transacao.tipo == TipoTransacao.TRANSFERENCIA_ENVIADA ||
              transacao.tipo == TipoTransacao.TRANSFERENCIA_RECEBIDA;
        case 'Depósitos':
          return transacao.tipo == TipoTransacao.DEPOSITO;
        case 'Pagamentos':
          return transacao.tipo == TipoTransacao.PAGAMENTO_CARTAO;
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
          title: 'Investimento',
          scaffoldKey: scaffoldKey,
          onBackPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const InicialScreen()));
          }),
      drawer: CustomDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : usuarioLogado == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Erro ao carregar dados do usuário',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _carregarDados,
                  child: Column(
                    children: [
                      _buildHeader(),
                      _buildFiltroChips(),
                      Expanded(
                        child: _buildListaTransacoes(),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(int.parse(usuarioLogado!.corPrincipal.replaceAll('#', '0xFF'))),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Saldo Atual',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'R\$ ${usuarioLogado!.saldo.toStringAsFixed(2).replaceAll('.', ',')}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Olá, ${usuarioLogado!.nome}',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltroChips() {
    List<String> filtros = [
      'Todos',
      'PIX',
      'Transferências',
      'Depósitos',
      'Pagamentos'
    ];

    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: filtros.length,
        itemBuilder: (context, index) {
          String filtro = filtros[index];
          bool isSelected = filtroSelecionado == filtro;

          return Padding(
            padding: EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(filtro),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  filtroSelecionado = filtro;
                });
              },
              backgroundColor: Colors.white,
              selectedColor: Color(int.parse(
                      usuarioLogado!.corPrincipal.replaceAll('#', '0xFF')))
                  .withOpacity(0.2),
              checkmarkColor: Color(int.parse(
                  usuarioLogado!.corPrincipal.replaceAll('#', '0xFF'))),
              labelStyle: TextStyle(
                color: isSelected
                    ? Color(int.parse(
                        usuarioLogado!.corPrincipal.replaceAll('#', '0xFF')))
                    : Colors.grey[700],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListaTransacoes() {
    List<TransacaoExtrato> transacoesFiltradas = _filtrarTransacoes();

    if (transacoesFiltradas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 64, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'Nenhuma transação encontrada',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Suas transações aparecerão aqui',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: transacoesFiltradas.length,
      itemBuilder: (context, index) {
        return _buildTransacaoCard(transacoesFiltradas[index]);
      },
    );
  }

  Widget _buildTransacaoCard(TransacaoExtrato transacao) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _mostrarDetalhesTransacao(transacao),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              _buildIconeTransacao(transacao.tipo),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transacao.descricao,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      _formatarData(transacao.data),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (transacao.chavePix != null ||
                        transacao.contaDestino != null)
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                          transacao.chavePix ?? transacao.contaDestino ?? '',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${_isTransacaoPositiva(transacao.tipo) ? '+' : '-'} R\$ ${transacao.valor.toStringAsFixed(2).replaceAll('.', ',')}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _isTransacaoPositiva(transacao.tipo)
                          ? Colors.green[600]
                          : Colors.red[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconeTransacao(TipoTransacao tipo) {
    IconData icone;
    Color cor;

    switch (tipo) {
      case TipoTransacao.PIX_ENVIADO:
        icone = Icons.pix;
        cor = Colors.purple;
        break;
      case TipoTransacao.PIX_RECEBIDO:
        icone = Icons.pix;
        cor = Colors.green;
        break;
      case TipoTransacao.TRANSFERENCIA_ENVIADA:
        icone = Icons.send;
        cor = Colors.blue;
        break;
      case TipoTransacao.TRANSFERENCIA_RECEBIDA:
        icone = Icons.call_received;
        cor = Colors.green;
        break;
      case TipoTransacao.DEPOSITO:
        icone = Icons.account_balance;
        cor = Colors.teal;
        break;
      case TipoTransacao.PAGAMENTO_CARTAO:
        icone = Icons.credit_card;
        cor = Colors.orange;
        break;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: cor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(
        icone,
        color: cor,
        size: 24,
      ),
    );
  }

  bool _isTransacaoPositiva(TipoTransacao tipo) {
    return tipo == TipoTransacao.PIX_RECEBIDO ||
        tipo == TipoTransacao.TRANSFERENCIA_RECEBIDA ||
        tipo == TipoTransacao.DEPOSITO;
  }

  String _formatarData(DateTime data) {
    final now = DateTime.now();
    final difference = now.difference(data);

    if (difference.inDays == 0) {
      return 'Hoje ${DateFormat('HH:mm').format(data)}';
    } else if (difference.inDays == 1) {
      return 'Ontem ${DateFormat('HH:mm').format(data)}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} dias atrás';
    } else {
      return DateFormat('dd/MM/yyyy HH:mm').format(data);
    }
  }

  void _mostrarFiltros() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filtrar por',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              _buildFiltroOption('Todos'),
              _buildFiltroOption('PIX'),
              _buildFiltroOption('Transferências'),
              _buildFiltroOption('Depósitos'),
              _buildFiltroOption('Pagamentos'),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFiltroOption(String filtro) {
    bool isSelected = filtroSelecionado == filtro;

    return ListTile(
      title: Text(filtro),
      trailing: isSelected
          ? Icon(Icons.check,
              color: Color(int.parse(
                  usuarioLogado!.corPrincipal.replaceAll('#', '0xFF'))))
          : null,
      onTap: () {
        setState(() {
          filtroSelecionado = filtro;
        });
        Navigator.pop(context);
      },
    );
  }

  void _mostrarDetalhesTransacao(TransacaoExtrato transacao) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Detalhes da Transação'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetalheItem('Tipo', _obterDescricaoTipo(transacao.tipo)),
            _buildDetalheItem('Valor',
                'R\$ ${transacao.valor.toStringAsFixed(2).replaceAll('.', ',')}'),
            _buildDetalheItem(
                'Data', DateFormat('dd/MM/yyyy HH:mm').format(transacao.data)),
            _buildDetalheItem('Descrição', transacao.descricao),
            if (transacao.chavePix != null)
              _buildDetalheItem('Chave PIX', transacao.chavePix!),
            if (transacao.contaDestino != null)
              _buildDetalheItem('Conta Destino', transacao.contaDestino!),
            if (transacao.contaOrigem != null)
              _buildDetalheItem('Conta Origem', transacao.contaOrigem!),
            _buildDetalheItem('Saldo Anterior',
                'R\$ ${transacao.saldoAnterior.toStringAsFixed(2).replaceAll('.', ',')}'),
            _buildDetalheItem('Saldo Posterior',
                'R\$ ${transacao.saldoPosterior.toStringAsFixed(2).replaceAll('.', ',')}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Fechar'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetalheItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  String _obterDescricaoTipo(TipoTransacao tipo) {
    switch (tipo) {
      case TipoTransacao.PIX_ENVIADO:
        return 'PIX Enviado';
      case TipoTransacao.PIX_RECEBIDO:
        return 'PIX Recebido';
      case TipoTransacao.TRANSFERENCIA_ENVIADA:
        return 'Transferência Enviada';
      case TipoTransacao.TRANSFERENCIA_RECEBIDA:
        return 'Transferência Recebida';
      case TipoTransacao.DEPOSITO:
        return 'Depósito';
      case TipoTransacao.PAGAMENTO_CARTAO:
        return 'Pagamento com Cartão';
    }
  }
}

// Enums e classes auxiliares para o extrato
enum TipoTransacao {
  PIX_ENVIADO,
  PIX_RECEBIDO,
  TRANSFERENCIA_ENVIADA,
  TRANSFERENCIA_RECEBIDA,
  DEPOSITO,
  PAGAMENTO_CARTAO,
}

class TransacaoExtrato {
  final String id;
  final TipoTransacao tipo;
  final double valor;
  final DateTime data;
  final String descricao;
  final String? chavePix;
  final String? contaDestino;
  final String? contaOrigem;
  final String? numeroCartao;
  final double saldoAnterior;
  final double saldoPosterior;

  TransacaoExtrato({
    required this.id,
    required this.tipo,
    required this.valor,
    required this.data,
    required this.descricao,
    this.chavePix,
    this.contaDestino,
    this.contaOrigem,
    this.numeroCartao,
    required this.saldoAnterior,
    required this.saldoPosterior,
  });
}
