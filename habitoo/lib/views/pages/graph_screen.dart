import 'package:flutter/material.dart';
import 'package:habitoo/models/resposta_model.dart';
import 'package:habitoo/services/sqlite_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class GraphScreen extends StatefulWidget {
  const GraphScreen({Key? key}) : super(key: key);

  @override
  State<GraphScreen> createState() => _GraphScreenState();
}

class _GraphScreenState extends State<GraphScreen> {
  late Future<List<RespostaQ8RN>> _historicoFuture;
  final SQLiteService _storageService = SQLiteService();
  String _timeRangeFilter = 'all';
  final List<String> _timeRangeOptions = ['1m', '3m', '6m', '1y', 'all'];
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isRefreshing = true);
    try {
      await _storageService.debugPrintAllResponses();
      _historicoFuture = _loadFilteredData();
      await _historicoFuture;
    } catch (e) {
      debugPrint('Erro ao carregar dados: $e');
    } finally {
      setState(() => _isRefreshing = false);
    }
  }

  Future<List<RespostaQ8RN>> _loadFilteredData() async {
    try {
      final allData = await _storageService.carregarHistorico();
      debugPrint('[DEBUG] Total de respostas no banco: ${allData.length}');

      if (allData.isEmpty) return [];

      if (_timeRangeFilter == 'all') return allData;

      final days = _getDaysFromFilter(_timeRangeFilter);
      final now = DateTime.now();
      return allData
          .where(
            (r) => r.dataResposta.isAfter(now.subtract(Duration(days: days))),
          )
          .toList();
    } catch (e) {
      debugPrint('[ERRO] Falha ao filtrar dados: $e');
      return [];
    }
  }

  int _getDaysFromFilter(String filter) {
    switch (filter) {
      case '1m':
        return 30;
      case '3m':
        return 90;
      case '6m':
        return 180;
      case '1y':
        return 365;
      default:
        return 0;
    }
  }

  void _onTimeRangeChanged(String? value) {
    if (value != null && value != _timeRangeFilter) {
      setState(() {
        _timeRangeFilter = value;
        _historicoFuture = _loadFilteredData();
      });
    }
  }

  Future<void> _exportDatabase() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/q8rn_database_export.db');
      await _storageService.exportToFile(file.path);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Banco exportado com sucesso!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Falha ao exportar banco: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seu Progresso'),
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: _isRefreshing ? Colors.grey : null,
            ),
            onPressed: _isRefreshing ? null : _loadData,
          ),
          DropdownButton<String>(
            value: _timeRangeFilter,
            items:
                _timeRangeOptions
                    .map(
                      (value) => DropdownMenuItem(
                        value: value,
                        child: Text(_getTimeRangeLabel(value)),
                      ),
                    )
                    .toList(),
            onChanged: _onTimeRangeChanged,
            underline: Container(),
            icon: const Icon(Icons.filter_alt),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _exportDatabase,
        tooltip: 'Exportar banco de dados',
        child: const Icon(Icons.save_alt),
      ),
      body:
          _isRefreshing
              ? const Center(child: CircularProgressIndicator())
              : FutureBuilder<List<RespostaQ8RN>>(
                future: _historicoFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return _buildErrorState(snapshot.error.toString());
                  }

                  final historico = snapshot.data ?? [];
                  if (historico.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildDataContent(historico);
                },
              ),
    );
  }

  Widget _buildDataContent(List<RespostaQ8RN> historico) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Período: ${_getTimeRangeLabel(_timeRangeFilter)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildTotalScoreChart(historico),
          const SizedBox(height: 24),
          _buildDomainComparison(historico),
        ],
      ),
    );
  }

  Widget _buildTotalScoreChart(List<RespostaQ8RN> historico) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Progresso do Escore Total',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 250,
              child: SfCartesianChart(
                primaryXAxis: DateTimeAxis(
                  title: AxisTitle(text: 'Data da Avaliação'),
                ),
                primaryYAxis: NumericAxis(
                  title: AxisTitle(text: 'Pontuação'),
                  minimum: 0,
                  maximum: 88,
                ),
                series: <CartesianSeries<RespostaQ8RN, DateTime>>[
                  LineSeries<RespostaQ8RN, DateTime>(
                    dataSource: historico,
                    xValueMapper:
                        (RespostaQ8RN resposta, _) => resposta.dataResposta,
                    yValueMapper:
                        (RespostaQ8RN resposta, _) => resposta.escoreTotal,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    markerSettings: const MarkerSettings(isVisible: true),
                    color: Colors.blue,
                  ),
                ],
                tooltipBehavior: TooltipBehavior(enable: true),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDomainComparison(List<RespostaQ8RN> historico) {
    final domainAverages = _calculateDomainAverages(historico);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Distribuição por Domínio',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 300,
              child: SfCircularChart(
                legend: Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap,
                  position: LegendPosition.bottom,
                ),
                tooltipBehavior: TooltipBehavior(enable: true),
                series: <CircularSeries>[
                  PieSeries<DomainAverage, String>(
                    dataSource: domainAverages,
                    xValueMapper: (DomainAverage data, _) => data.domain,
                    yValueMapper: (DomainAverage data, _) => data.averageScore,
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    explode: true,
                    explodeIndex: 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DomainAverage> _calculateDomainAverages(List<RespostaQ8RN> historico) {
    final domainSums = <String, double>{};
    final domainCounts = <String, int>{};

    for (var resposta in historico) {
      for (var entry in resposta.escoresPorDominio.entries) {
        domainSums.update(
          entry.key,
          (value) => value + entry.value,
          ifAbsent: () => entry.value.toDouble(),
        );
        domainCounts.update(entry.key, (value) => value + 1, ifAbsent: () => 1);
      }
    }

    return domainSums.entries.map((e) {
      return DomainAverage(
        domain: e.key,
        averageScore: e.value / domainCounts[e.key]!,
      );
    }).toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.assessment_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            'Nenhum dado encontrado',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            _timeRangeFilter == 'all'
                ? 'Complete o questionário para ver seus resultados'
                : 'Nenhum dado para o período selecionado',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _timeRangeFilter = 'all';
                _historicoFuture = _loadFilteredData();
              });
            },
            child: const Text('Mostrar todos os dados'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Erro ao carregar dados',
            style: TextStyle(fontSize: 18, color: Colors.red),
          ),
          const SizedBox(height: 8),
          Text(error),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadData,
            child: const Text('Tentar novamente'),
          ),
        ],
      ),
    );
  }

  String _getTimeRangeLabel(String value) {
    switch (value) {
      case '1m':
        return 'Último mês';
      case '3m':
        return 'Últimos 3 meses';
      case '6m':
        return 'Últimos 6 meses';
      case '1y':
        return 'Último ano';
      default:
        return 'Todos os dados';
    }
  }

  Color _getDomainColor(double percentage) {
    if (percentage < 0.3) return Colors.red;
    if (percentage < 0.6) return Colors.orange;
    if (percentage < 0.8) return Colors.lightGreen;
    return Colors.green;
  }

  int _getMaxScoreForDomain(String domain) {
    final maxScores = {
      'Nutrição': 12,
      'Exercício': 12,
      'Água': 8,
      'Sol': 8,
      'Temperança': 16,
      'Ar Puro': 8,
      'Descanso': 16,
      'Confiança': 8,
    };
    return maxScores[domain] ?? 10;
  }
}

class DomainAverage {
  final String domain;
  final double averageScore;

  DomainAverage({required this.domain, required this.averageScore});
}
