class RespostaQ8RN {
  final String id;
  final DateTime dataResposta;
  final Map<String, dynamic> resposta;
  final int escoreTotal;
  final String classificacao;
  final Map<String, int> escoresPorDominio;

  RespostaQ8RN({
    String? id,
    required this.dataResposta,
    required this.resposta,
    required this.escoreTotal,
    required this.classificacao,
    required this.escoresPorDominio,
  }) : this.id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dataResposta': dataResposta.toIso8601String(),
      'resposta': resposta,
      'escoreTotal': escoreTotal,
      'classificacao': classificacao,
      'escoresPorDominio': escoresPorDominio,
    };
  }

  factory RespostaQ8RN.fromMap(Map<String, dynamic> map) {
    return RespostaQ8RN(
      id: map['id'],
      dataResposta: DateTime.parse(map['dataResposta']),
      resposta: Map<String, dynamic>.from(map['resposta']),
      escoreTotal: map['escoreTotal'],
      classificacao: map['classificacao'],
      escoresPorDominio: Map<String, int>.from(map['escoresPorDominio']),
    );
  }
}
