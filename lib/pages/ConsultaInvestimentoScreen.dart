import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/InvestimentoScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/components/AppBar.dart';
import 'package:flutter_application_1/components/Drawer.dart';
import 'package:flutter_application_1/service/Colors.dart';

enum InvestmentType { stocks, crypto, indices, fiis }

class Stock {
  final String symbol;
  final String shortName;
  final String longName;
  final double regularMarketPrice;
  final double regularMarketOpen;
  final double regularMarketDayHigh;
  final double regularMarketDayLow;
  final int regularMarketVolume;
  final double fiftyTwoWeekHigh;
  final double fiftyTwoWeekLow;
  final double change;
  final double changePercent;
  final String logoUrl;
  final String currency;
  final double marketCap;
  final String range;
  final String fiftyTwoWeekRange;

  Stock({
    required this.symbol,
    required this.shortName,
    required this.longName,
    required this.regularMarketPrice,
    required this.regularMarketOpen,
    required this.regularMarketDayHigh,
    required this.regularMarketDayLow,
    required this.regularMarketVolume,
    required this.fiftyTwoWeekHigh,
    required this.fiftyTwoWeekLow,
    required this.change,
    required this.changePercent,
    required this.logoUrl,
    required this.currency,
    required this.marketCap,
    required this.range,
    required this.fiftyTwoWeekRange,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      symbol: json['symbol'] ?? '',
      shortName: json['shortName'] ?? '',
      longName: json['longName'] ?? json['shortName'] ?? '',
      regularMarketPrice: (json['regularMarketPrice'] ?? 0).toDouble(),
      regularMarketOpen: (json['regularMarketOpen'] ?? 0).toDouble(),
      regularMarketDayHigh: (json['regularMarketDayHigh'] ?? 0).toDouble(),
      regularMarketDayLow: (json['regularMarketDayLow'] ?? 0).toDouble(),
      regularMarketVolume: json['regularMarketVolume'] ?? 0,
      fiftyTwoWeekHigh: (json['fiftyTwoWeekHigh'] ?? 0).toDouble(),
      fiftyTwoWeekLow: (json['fiftyTwoWeekLow'] ?? 0).toDouble(),
      change: (json['regularMarketChange'] ?? 0).toDouble(),
      changePercent: (json['regularMarketChangePercent'] ?? 0).toDouble(),
      logoUrl: json['logourl'] ?? '',
      currency: json['currency'] ?? 'BRL',
      marketCap: (json['marketCap'] ?? 0).toDouble(),
      range: json['regularMarketDayRange'] ?? '',
      fiftyTwoWeekRange: json['fiftyTwoWeekRange'] ?? '',
    );
  }
}

class ConsultaInvestimentoScreen extends StatefulWidget {
  @override
  _ConsultaInvestimentoScreenState createState() =>
      _ConsultaInvestimentoScreenState();
}

class _ConsultaInvestimentoScreenState
    extends State<ConsultaInvestimentoScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Stock> _stocks = [];
  bool _isLoading = false;
  String _errorMessage = '';
  InvestmentType _selectedType = InvestmentType.stocks;

  final String apiToken = 'uLBEt4fvsVbRtkG18JJ14K';

  Map<InvestmentType, String> get typeLabels => {
    InvestmentType.stocks: 'Ações',
    InvestmentType.crypto: 'Criptomoedas',
    InvestmentType.indices: 'Índices',
    InvestmentType.fiis: 'FIIs',
  };

  Map<InvestmentType, List<String>> get suggestions => {
    InvestmentType.stocks: ['PETR4', 'VALE3', 'ITUB4', 'BBDC4', 'ABEV3', 'BBAS3', 'WEGE3', 'LREN3', 'MGLU3'],
    InvestmentType.crypto: ['BTC-USD', 'ETH-USD', 'BNB-USD', 'ADA-USD', 'XRP-USD', 'SOL-USD', 'DOT-USD', 'LINK-USD', 'UNI-USD'],
    InvestmentType.indices: ['^BVSP', '^GSPC', '^IXIC', '^DJI', '^FTSE', '^N225', '^HSI', '^GDAXI', '^FCHI'],
    InvestmentType.fiis: ['HGLG11', 'XPML11', 'VISC11', 'KNRI11', 'BCFF11', 'HGRU11', 'MXRF11', 'IRDM11', 'KNCR11'],
  };

  Map<InvestmentType, String> get placeholders => {
    InvestmentType.stocks: 'Digite o código da ação (ex: PETR4)',
    InvestmentType.crypto: 'Digite o código da cripto (ex: BTC-USD)',
    InvestmentType.indices: 'Digite o código do índice (ex: ^BVSP)',
    InvestmentType.fiis: 'Digite o código do FII (ex: HGLG11)',
  };

  bool _isValidSymbol(String symbol) {
    switch (_selectedType) {
      case InvestmentType.stocks:
      case InvestmentType.fiis:
        return RegExp(r'^[A-Z0-9]{4,6}$').hasMatch(symbol);
      case InvestmentType.crypto:
        return RegExp(r'^[A-Z0-9]+-[A-Z]{3}$').hasMatch(symbol);
      case InvestmentType.indices:
        return RegExp(r'^\^[A-Z0-9]+$').hasMatch(symbol);
    }
  }

  String _getApiEndpoint(String symbol) {
    switch (_selectedType) {
      case InvestmentType.stocks:
      case InvestmentType.fiis:
        return 'https://brapi.dev/api/quote/$symbol';
      case InvestmentType.crypto:
        return 'https://brapi.dev/api/quote/$symbol';
      case InvestmentType.indices:
        return 'https://brapi.dev/api/quote/$symbol';
    }
  }

  Future<void> _searchStock(String symbol) async {
    if (symbol.isEmpty) {
      setState(() {
        _stocks = [];
        _errorMessage = '';
        _isLoading = false;
      });
      return;
    }

    if (!_isValidSymbol(symbol)) {
      setState(() {
        _errorMessage = _getValidationMessage();
        _stocks = [];
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await http.get(
        Uri.parse(_getApiEndpoint(symbol)),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $apiToken',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data.containsKey('results') && data['results'] is List) {
          setState(() {
            _stocks = (data['results'] as List)
                .map((stock) => Stock.fromJson(stock))
                .toList();
          });
        } else {
          _errorMessage = 'Investimento não encontrado ou resposta inválida';
          _stocks = [];
        }
      } else {
        _errorMessage = 'Erro ao buscar investimento: ${response.statusCode}';
        _stocks = [];
      }
    } catch (e) {
      _errorMessage = 'Erro de conexão: $e';
      _stocks = [];
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getValidationMessage() {
    switch (_selectedType) {
      case InvestmentType.stocks:
        return 'Símbolo inválido. Use letras maiúsculas e números (ex: PETR4).';
      case InvestmentType.crypto:
        return 'Símbolo inválido. Use o formato CRYPTO-USD (ex: BTC-USD).';
      case InvestmentType.indices:
        return 'Símbolo inválido. Use o formato ^INDICE (ex: ^BVSP).';
      case InvestmentType.fiis:
        return 'Símbolo inválido. Use letras maiúsculas e números (ex: HGLG11).';
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      appBar: CustomAppBar(
          title: 'Consulta Investimentos',
          scaffoldKey: scaffoldKey,
          onBackPressed: () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const InvestimentoScreen()));
          }),
      drawer: CustomDrawer(),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.main,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                // Seletor de tipo de investimento
                Container(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: InvestmentType.values.map((type) {
                      final isSelected = _selectedType == type;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedType = type;
                              _searchController.clear();
                              _stocks = [];
                              _errorMessage = '';
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 2),
                            padding: EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: Colors.white,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              typeLabels[type]!,
                              style: TextStyle(
                                color: isSelected ? AppColors.main : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: placeholders[_selectedType],
                    prefixIcon: Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        _searchController.clear();
                        _searchStock('');
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: _searchStock,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () => _searchStock(_searchController.text),
                  child: Text('Buscar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.main,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _buildContent()),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_searchController.text.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_getTypeIcon(), size: 64, color: AppColors.main),
            SizedBox(height: 16),
            Text(
              'Digite o código de ${typeLabels[_selectedType]!.toLowerCase()} para consultar.',
              style: TextStyle(fontSize: 18, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Sugestões:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey[600]),
            ),
            SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              alignment: WrapAlignment.center,
              children: suggestions[_selectedType]!.map((tag) => _buildTag(tag)).toList(),
            ),
          ],
        ),
      );
    }

    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red),
            SizedBox(height: 16),
            Text(
              _errorMessage,
              style: TextStyle(fontSize: 18, color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _searchStock(_searchController.text),
              child: Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }

    if (_stocks.isEmpty) {
      return Center(
        child: Text(
          'Nenhum resultado encontrado para "${_searchController.text}"',
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: _stocks.length,
      itemBuilder: (context, index) {
        return StockCard(stock: _stocks[index], type: _selectedType);
      },
    );
  }

  IconData _getTypeIcon() {
    switch (_selectedType) {
      case InvestmentType.stocks:
        return Icons.trending_up;
      case InvestmentType.crypto:
        return Icons.currency_bitcoin;
      case InvestmentType.indices:
        return Icons.bar_chart;
      case InvestmentType.fiis:
        return Icons.business;
    }
  }

  Widget _buildTag(String text) {
    return InkWell(
      onTap: () {
        _searchController.text = text;
        _searchStock(text);
      },
      child: Chip(
        label: Text(text),
        backgroundColor: AppColors.main.withOpacity(0.1),
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.main,
        ),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
    );
  }
}

class StockCard extends StatelessWidget {
  final Stock stock;
  final InvestmentType type;

  const StockCard({Key? key, required this.stock, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPositive = stock.change >= 0;
    final changeColor = isPositive ? Colors.green : Colors.red;
    final changeIcon = isPositive ? Icons.arrow_upward : Icons.arrow_downward;
    final currencySymbol = _getCurrencySymbol();

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com logo, símbolo e preço
            Row(
              children: [
                // Logo e informações básicas
                Expanded(
                  child: Row(
                    children: [
                      // Logo
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[100],
                        ),
                        child: stock.logoUrl.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  stock.logoUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      _getTypeIcon(),
                                      color: AppColors.main,
                                      size: 30,
                                    );
                                  },
                                ),
                              )
                            : Icon(
                                _getTypeIcon(),
                                color: AppColors.main,
                                size: 30,
                              ),
                      ),
                      SizedBox(width: 12),
                      // Símbolo e nome
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              stock.symbol,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: AppColors.main,
                              ),
                            ),
                            if (stock.shortName.isNotEmpty)
                              Text(
                                stock.shortName,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            if (stock.longName.isNotEmpty && stock.longName != stock.shortName)
                              Text(
                                stock.longName,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[500],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Preço e variação
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$currencySymbol ${stock.regularMarketPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (stock.change != 0)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: changeColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(changeIcon, color: changeColor, size: 14),
                            SizedBox(width: 4),
                            Text(
                              '${stock.change.toStringAsFixed(2)} (${stock.changePercent.toStringAsFixed(2)}%)',
                              style: TextStyle(
                                color: changeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
            
            SizedBox(height: 16),
            Divider(color: Colors.grey[300]),
            SizedBox(height: 12),
            
            // Informações detalhadas
            Column(
              children: [
                // Primeira linha: Abertura e Volume
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        'Abertura',
                        stock.regularMarketOpen > 0 
                            ? '$currencySymbol ${stock.regularMarketOpen.toStringAsFixed(2)}'
                            : 'N/A',
                        Icons.access_time,
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        'Volume',
                        stock.regularMarketVolume > 0
                            ? _formatVolume(stock.regularMarketVolume)
                            : 'N/A',
                        Icons.bar_chart,
                      ),
                    ),
                  ],
                ),
                
                SizedBox(height: 12),
                
                // Segunda linha: Range do dia
                if (stock.range.isNotEmpty)
                  _buildRangeItem(
                    'Variação do Dia',
                    stock.range,
                    stock.regularMarketDayLow,
                    stock.regularMarketDayHigh,
                    currencySymbol,
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          'Mínima',
                          stock.regularMarketDayLow > 0
                              ? '$currencySymbol ${stock.regularMarketDayLow.toStringAsFixed(2)}'
                              : 'N/A',
                          Icons.trending_down,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          'Máxima',
                          stock.regularMarketDayHigh > 0
                              ? '$currencySymbol ${stock.regularMarketDayHigh.toStringAsFixed(2)}'
                              : 'N/A',
                          Icons.trending_up,
                        ),
                      ),
                    ],
                  ),
                
                SizedBox(height: 12),
                
                // Terceira linha: Range de 52 semanas
                if (stock.fiftyTwoWeekRange.isNotEmpty)
                  _buildRangeItem(
                    'Variação 52 Semanas',
                    stock.fiftyTwoWeekRange,
                    stock.fiftyTwoWeekLow,
                    stock.fiftyTwoWeekHigh,
                    currencySymbol,
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoItem(
                          'Mín. 52s',
                          stock.fiftyTwoWeekLow > 0
                              ? '$currencySymbol ${stock.fiftyTwoWeekLow.toStringAsFixed(2)}'
                              : 'N/A',
                          Icons.show_chart,
                        ),
                      ),
                      Expanded(
                        child: _buildInfoItem(
                          'Máx. 52s',
                          stock.fiftyTwoWeekHigh > 0
                              ? '$currencySymbol ${stock.fiftyTwoWeekHigh.toStringAsFixed(2)}'
                              : 'N/A',
                          Icons.show_chart,
                        ),
                      ),
                    ],
                  ),
                
                // Market Cap (se disponível)
                if (stock.marketCap > 0) ...[
                  SizedBox(height: 12),
                  _buildInfoItem(
                    'Valor de Mercado',
                    _formatMarketCap(stock.marketCap),
                    Icons.account_balance,
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRangeItem(String label, String range, double low, double high, String currencySymbol) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4),
          Text(
            range.isNotEmpty ? range : '$currencySymbol ${low.toStringAsFixed(2)} - $currencySymbol ${high.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.main,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon() {
    switch (type) {
      case InvestmentType.stocks:
        return Icons.trending_up;
      case InvestmentType.crypto:
        return Icons.currency_bitcoin;
      case InvestmentType.indices:
        return Icons.bar_chart;
      case InvestmentType.fiis:
        return Icons.business;
    }
  }

  String _getCurrencySymbol() {
    if (stock.currency == 'USD') return '\$';
    if (stock.currency == 'BRL') return 'R\$';
    return stock.currency;
  }

  Widget _buildInfoItem(String label, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatVolume(int volume) {
    if (volume >= 1000000000) {
      return '${(volume / 1000000000).toStringAsFixed(1)}B';
    } else if (volume >= 1000000) {
      return '${(volume / 1000000).toStringAsFixed(1)}M';
    } else if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(1)}K';
    }
    return volume.toString();
  }

  String _formatMarketCap(double marketCap) {
    if (marketCap >= 1000000000000) {
      return 'R\$ ${(marketCap / 1000000000000).toStringAsFixed(1)}T';
    } else if (marketCap >= 1000000000) {
      return 'R\$ ${(marketCap / 1000000000).toStringAsFixed(1)}B';
    } else if (marketCap >= 1000000) {
      return 'R\$ ${(marketCap / 1000000).toStringAsFixed(1)}M';
    }
    return 'R\$ ${marketCap.toStringAsFixed(0)}';
  }
}