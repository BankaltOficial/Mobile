// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/pages/InvestimentoScreen.dart';
import 'package:flutter_application_1/service/Colors.dart';
import 'package:flutter_application_1/service/Usuario.dart';
import 'package:flutter_application_1/service/UsuarioService.dart';
import 'package:flutter_application_1/service/InvestimentoService.dart';
import 'package:flutter_application_1/service/Investimento.dart';
import 'package:flutter_application_1/components/ResgateDialog.dart';

class ResgateScreen extends StatefulWidget {
  const ResgateScreen({super.key});

  @override
  State<ResgateScreen> createState() => _ResgateScreenState();
}

class _ResgateScreenState extends State<ResgateScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Usuario? _usuarioLogado;
  List<Investimento> _investimentos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    setState(() {
      _isLoading = true;
    });

    try {
      int? usuarioId = await UsuarioService.carregarUsuarioLogado();
      if (usuarioId != null) {
        List<Usuario> usuarios = await UsuarioService.carregarUsuarios();
        Usuario? usuario = usuarios.firstWhere((u) => u.id == usuarioId);
        
        List<Investimento> investimentos = await InvestimentoService.obterInvestimentosPorUsuario(usuarioId);
        
        setState(() {
          _usuarioLogado = usuario;
          _investimentos = investimentos;
        });
      }
    } catch (e) {
      print('Erro ao carregar dados: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _mostrarDialogResgate(Investimento investimento) {
    if (_usuarioLogado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro: Usuário não encontrado'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!investimento.podeResgatar()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Resgate não disponível para ${investimento.nomeAtivo}. Disponível em: ${investimento.resgateDisponivel}'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => ResgateDialog(
        investimento: investimento,
        usuario: _usuarioLogado!,
        onResgateRealizado: () {
          _carregarDados(); // Recarregar dados
        },
      ),
    );
  }

  String _formatarData(DateTime data) {
    return '${data.day.toString().padLeft(2, '0')}/${data.month.toString().padLeft(2, '0')}/${data.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.theme,
      key: _scaffoldKey,
      appBar: CustomAppBar(
        title: 'Resgate',
        scaffoldKey: _scaffoldKey,
        onBackPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const InvestimentoScreen()),
          );
        },
      ),
      drawer: CustomDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _investimentos.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_sharp,
                        size: 80,
                        color: AppColors.invertMode.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Você não possui investimentos',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.invertMode.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Comece a investir para ver seus ativos aqui',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.invertMode.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Seus Investimentos',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.invertMode,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _investimentos.length,
                          itemBuilder: (context, index) {
                            final investimento = _investimentos[index];
                            final podeResgatar = investimento.podeResgatar();
                            
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: InkWell(
                                onTap: () => _mostrarDialogResgate(investimento),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: podeResgatar 
                                        ? AppColors.main 
                                        : AppColors.main.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(12),
                                    border: podeResgatar 
                                        ? null 
                                        : Border.all(
                                            color: Colors.orange,
                                            width: 2,
                                          ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              investimento.nomeAtivo,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.mainWhite,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: podeResgatar 
                                                  ? Colors.green 
                                                  : Colors.orange,
                                              borderRadius: BorderRadius.circular(6),
                                            ),
                                            child: Text(
                                              podeResgatar ? 'Disponível' : 'Bloqueado',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Valor Investido',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.mainWhite.withOpacity(0.8),
                                                ),
                                              ),
                                              Text(
                                                'R\$ ${investimento.valorInvestido.toStringAsFixed(2).replaceAll('.', ',')}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: AppColors.mainWhite,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                'Data Investimento',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.mainWhite.withOpacity(0.8),
                                                ),
                                              ),
                                              Text(
                                                _formatarData(investimento.dataInvestimento),
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: AppColors.mainWhite,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'Tipo: ${investimento.tipoAtivo}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.mainWhite.withOpacity(0.8),
                                            ),
                                          ),
                                          Text(
                                            'Resgate: ${investimento.resgateDisponivel}',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.mainWhite.withOpacity(0.8),
                                            ),
                                          ),
                                        ],
                                      ),
                                      if (podeResgatar) ...[
                                        const SizedBox(height: 12),
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          decoration: BoxDecoration(
                                            color: AppColors.mainWhite.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Text(
                                            'Toque para resgatar',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: AppColors.mainWhite,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}