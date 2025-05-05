import 'package:flutter/material.dart';
import 'package:habitoo/models/resposta_model.dart';
import 'package:habitoo/services/sqlite_service.dart';

class ResultScreen extends StatelessWidget {
  final RespostaQ8RN resposta;

  const ResultScreen({Key? key, required this.resposta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seus Resultados'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () async {
              try {
                await SQLiteService().salvarResposta(resposta);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Resultados salvos com sucesso!')),
                );
              } catch (e) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text('Erro ao salvar: $e')));
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabeçalho com resultado principal
            _buildResultCard(
              title: 'Resultado Geral',
              children: [
                Text(
                  '${resposta.escoreTotal} pontos',
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Classificação: ${resposta.classificacao}',
                  style: TextStyle(fontSize: 24, color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                LinearProgressIndicator(
                  value:
                      resposta.escoreTotal / 88, // Assumindo que 88 é o máximo
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getScoreColor(resposta.escoreTotal),
                  ),
                  minHeight: 20,
                ),
              ],
            ),

            SizedBox(height: 20),

            // Detalhes por domínio
            Text(
              'Detalhes por Domínio:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...resposta.escoresPorDominio.entries.map((entry) {
              return _buildDomainScore(
                domain: entry.key,
                score: entry.value,
                maxScore: _getMaxScoreForDomain(entry.key),
              );
            }).toList(),

            SizedBox(height: 20),

            // Data da avaliação
            Text(
              'Data da avaliação: ${_formatDate(resposta.dataResposta)}',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDomainScore({
    required String domain,
    required int score,
    required int maxScore,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(domain, style: TextStyle(fontWeight: FontWeight.bold)),
              Text('$score/$maxScore'),
            ],
          ),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: score / maxScore,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation<Color>(
              _getDomainColor(score / maxScore),
            ),
          ),
        ],
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score <= 25) return Colors.red;
    if (score <= 44) return Colors.orange;
    if (score <= 58) return Colors.lightGreen;
    if (score <= 73) return Colors.green;
    return Colors.deepPurple;
  }

  Color _getDomainColor(double percentage) {
    if (percentage < 0.3) return Colors.red;
    if (percentage < 0.6) return Colors.orange;
    if (percentage < 0.8) return Colors.lightGreen;
    return Colors.green;
  }

  int _getMaxScoreForDomain(String domain) {
    // Defina os valores máximos para cada domínio
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} às ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}
