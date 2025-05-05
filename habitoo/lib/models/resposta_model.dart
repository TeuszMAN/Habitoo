class RespostaQ8RN {
  final String id;
  final DateTime dataResposta;
  final Map<String, dynamic> resposta;
  final int escoreTotal;
  final String classificacao;
  final Map<String, int> escoresPorDominio;
  final String? userId; // Novo campo para armazenar o ID do usuário

  RespostaQ8RN({
    String? id,
    required this.dataResposta,
    required this.resposta,
    required this.escoreTotal,
    required this.classificacao,
    required this.escoresPorDominio,
    this.userId,
  }) : this.id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dataResposta': dataResposta.toIso8601String(),
      'resposta': resposta,
      'escoreTotal': escoreTotal,
      'classificacao': classificacao,
      'escoresPorDominio': escoresPorDominio,
      'userId': userId,
    };
  }

  factory RespostaQ8RN.fromMap(Map<String, dynamic> map) {
    final rawRespostas = map['resposta'];
    final rawEscores = map['escoresPorDominio'];

    final Map<String, dynamic> respostasConvertidas =
        rawRespostas is Map ? Map<String, dynamic>.from(rawRespostas) : {};

    final Map<String, int> escoresConvertidos =
        rawEscores is Map
            ? rawEscores.map(
              (key, value) =>
                  MapEntry(key.toString(), int.tryParse(value.toString()) ?? 0),
            )
            : {};

    return RespostaQ8RN(
      id: map['id'],
      dataResposta: DateTime.parse(map['dataResposta']),
      resposta: respostasConvertidas,
      escoreTotal: map['escoreTotal'],
      classificacao: map['classificacao'],
      escoresPorDominio: escoresConvertidos,
      userId: map['userId'],
    );
  }
}
