import '../models/resposta_model.dart';

abstract class StorageService {
  Future<void> salvarResposta(RespostaQ8RN resposta);
  Future<List<RespostaQ8RN>> carregarHistorico();
}
