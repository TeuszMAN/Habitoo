import 'package:flutter/material.dart';
import 'package:habitoo/models/resposta_model.dart';

class ResultScreen extends StatelessWidget {
  final RespostaQ8RN resposta;

  const ResultScreen({Key? key, required this.resposta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Seus Resultados')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Escore Total: ${resposta.escoreTotal}',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 20),
            Text(
              'Classificação: ${resposta.classificacao}',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            // Adicione mais detalhes conforme necessário
          ],
        ),
      ),
    );
  }
}
