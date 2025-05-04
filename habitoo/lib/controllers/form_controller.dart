import '../models/resposta_model.dart'; // Import essencial!
import '../services/storage_service.dart';
import '../services/calculos_helper.dart'; // Importando a classe de cálculos

class Q8RNFormController {
  final StorageService storageService;
  RespostaQ8RN? ultimaResposta; // Armazena a última resposta

  Q8RNFormController(this.storageService);

  Future<List<RespostaQ8RN>> carregarHistorico() async {
    return await storageService.carregarHistorico();
  }

  Future<RespostaQ8RN> submeterFormulario(
    Map<String, dynamic> respostas,
  ) async {
    final escoresDominio = CalculosQ8RN.calcularEscoreDominios(respostas);
    final escoreTotal = escoresDominio.values.reduce((a, b) => a + b);

    ultimaResposta = RespostaQ8RN(
      dataResposta: DateTime.now(),
      resposta: respostas,
      escoreTotal: escoreTotal,
      classificacao: _determinarClassificacao(escoreTotal),
      escoresPorDominio: escoresDominio,
    );

    await storageService.salvarResposta(ultimaResposta!);
    return ultimaResposta!;
  }

  String _determinarClassificacao(int escoreTotal) {
    if (escoreTotal <= 25) return 'Insuficiente';
    if (escoreTotal <= 44) return 'Regular';
    if (escoreTotal <= 58) return 'Bom';
    if (escoreTotal <= 73) return 'Muito Bom';
    return 'Excelente';
  }
}
