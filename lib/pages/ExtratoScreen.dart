import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/InicialScreen.dart';
import 'package:flutter_application_1/service/TransferenciaExtrato.dart';
import 'package:intl/intl.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/UsuarioService.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/service/ExtratoService.dart';

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
    if (usuarioLogado == null) return;

    try {
      transacoes = await ExtratoService.buscarTransacoes(usuarioLogado!.id);
    } catch (e) {
      print('Erro ao carregar transações: $e');
      transacoes = [];
    } finally {
      setState(() {});
    }
  }

  List<TransacaoExtrato> _filtrarTransacoes() {
    if (filtroSelecionado == 'Todos') return transacoes;

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
        title: 'Extrato',
        scaffoldKey: scaffoldKey,
        onBackPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InicialScreen()),
          );
        },
      ),
      drawer: CustomDrawer(),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : usuarioLogado == null
              ? _buildErroUsuario()
              : RefreshIndicator(
                  onRefresh: _carregarDados,
                  child: Column(
                    children: [
                      _buildHeader(),
                      _buildFiltroChips(),
                      Expanded(child: _buildListaTransacoes()),
                    ],
                  ),
                ),
    );
  }

  Widget _buildErroUsuario() {
    return Center(
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
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(
            int.parse(usuarioLogado!.corPrincipal.replaceAll('#', '0xFF'))),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Saldo Atual',
              style: TextStyle(color: Colors.white70, fontSize: 16)),
          SizedBox(height: 8),
          Text(
            'R\$ ${usuarioLogado!.saldo.toStringAsFixed(2).replaceAll('.', ',')}',
            style: TextStyle(
                color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text('Olá, ${usuarioLogado!.nome}',
              style: TextStyle(color: Colors.white70, fontSize: 14)),
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
            Text('Nenhuma transação encontrada',
                style: TextStyle(fontSize: 18, color: Colors.grey[600])),
            SizedBox(height: 8),
            Text('Suas transações aparecerão aqui',
                style: TextStyle(fontSize: 14, color: Colors.grey[500])),
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
                    Text(transacao.descricao,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800])),
                    SizedBox(height: 4),
                    Text(_formatarData(transacao.data),
                        style:
                            TextStyle(fontSize: 14, color: Colors.grey[600])),
                    if (transacao.chavePix != null ||
                        transacao.contaDestino != null)
                      Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Text(
                            transacao.chavePix ?? transacao.contaDestino ?? '',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500])),
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
                  Icon(Icons.arrow_forward_ios,
                      size: 16, color: Colors.grey[400]),
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
      child: Icon(icone, color: cor, size: 24),
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

    if (difference.inDays == 0)
      return 'Hoje ${DateFormat('HH:mm').format(data)}';
    if (difference.inDays == 1)
      return 'Ontem ${DateFormat('HH:mm').format(data)}';
    if (difference.inDays < 7) return '${difference.inDays} dias atrás';
    return DateFormat('dd/MM/yyyy HH:mm').format(data);
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
            _buildDetalheItem('Tipo', transacao.tipo.name),
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
              onPressed: () => Navigator.pop(context), child: Text('Fechar')),
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
              child: Text('$label:',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.grey[700]))),
          Expanded(
              child: Text(value, style: TextStyle(color: Colors.grey[800]))),
        ],
      ),
    );
  }
}
