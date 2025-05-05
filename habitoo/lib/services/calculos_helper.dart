class CalculosQ8RN {
  static Map<String, int> calcularEscoreDominios(
    Map<String, dynamic> respostas,
  ) {
    return {
      'Nutrição': _calcularNutricao(respostas),
      'Exercício': _calcularExercicio(respostas),
      'Água': _calcularAgua(respostas),
      'Sol': _calcularSol(respostas),
      'Temperança': _calcularTemperanca(respostas),
      'Ar Puro': _calcularArPuro(respostas),
      'Descanso': _calcularDescanso(respostas),
      'Confiança': _calcularConfianca(respostas),
    };
  }

  static int _calcularNutricao(Map<String, dynamic> respostas) {
    int pontuacao = 0;

    if (respostas['nutricao_q1'] != null) {
      pontuacao += _converterLikert(respostas['nutricao_q1']);
    }

    if (respostas['nutricao_q2'] != null) {
      pontuacao +=
          {
            'Não vegetariano': 0,
            'Semi Vegetariano': 1,
            'Pesco Vegetariano': 2,
            'Ovolacto Vegetariano': 3,
            'Vegetariano estrito': 4,
          }[respostas['nutricao_q2']] ??
          0;
    }

    if (respostas['nutricao_q3'] != null) {
      pontuacao += 4 - _converterLikert(respostas['nutricao_q3']);
    }

    return pontuacao.clamp(0, 12);
  }

  static int _calcularExercicio(Map<String, dynamic> respostas) {
    int pontuacao = 0;

    if (respostas['exercicio_q4'] != null) {
      pontuacao += _converterLikert(respostas['exercicio_q4']);
    }
    if (respostas['exercicio_q5'] != null) {
      pontuacao += _converterLikert(respostas['exercicio_q5']);
    }
    if (respostas['exercicio_q6'] != null) {
      pontuacao += _converterLikert(respostas['exercicio_q6']);
    }

    return pontuacao.clamp(0, 12);
  }

  static int _calcularAgua(Map<String, dynamic> respostas) {
    int pontuacao = 0;

    if (respostas['agua_q7'] != null) {
      pontuacao +=
          {
            'Nenhum': 0,
            '1 a 3 copos': 1,
            '4 a 6 copos': 2,
            '7 copos': 3,
            '8 ou mais': 4,
          }[respostas['agua_q7']] ??
          0;
    }

    if (respostas['agua_q8'] != null) {
      pontuacao += _converterLikert(respostas['agua_q8']);
    }

    return pontuacao.clamp(0, 8);
  }

  static int _calcularSol(Map<String, dynamic> respostas) {
    int pontuacao = 0;

    if (respostas['sol_q9'] != null) {
      pontuacao += _converterLikert(respostas['sol_q9']);
    }
    if (respostas['sol_q10'] != null) {
      pontuacao += _converterLikert(respostas['sol_q10']);
    }

    return pontuacao.clamp(0, 8);
  }

  static int _calcularTemperanca(Map<String, dynamic> respostas) {
    int pontuacao = 0;

    [
      'temperanca_q11',
      'temperanca_q12',
      'temperanca_q13',
      'temperanca_q14',
    ].forEach((q) {
      if (respostas[q] != null && respostas[q] == 'Não') {
        pontuacao += 4;
      }
    });

    return pontuacao.clamp(0, 16);
  }

  static int _calcularArPuro(Map<String, dynamic> respostas) {
    int pontuacao = 0;

    if (respostas['ar_puro_q15'] != null) {
      pontuacao += 4 - _converterLikert(respostas['ar_puro_q15']);
    }

    if (respostas['ar_puro_q16'] != null) {
      pontuacao += _converterLikert(respostas['ar_puro_q16']);
    }

    return pontuacao.clamp(0, 8);
  }

  static int _calcularDescanso(Map<String, dynamic> respostas) {
    int pontuacao = 0;

    if (respostas['descanso_q17'] != null) {
      pontuacao += _converterLikert(respostas['descanso_q17']);
    }
    if (respostas['descanso_q18'] != null) {
      pontuacao += _converterLikert(respostas['descanso_q18']);
    }
    if (respostas['descanso_q19'] != null) {
      pontuacao += _converterLikert(respostas['descanso_q19']);
    }
    if (respostas['descanso_q20'] != null) {
      pontuacao += _converterLikert(respostas['descanso_q20']);
    }

    return pontuacao.clamp(0, 16);
  }

  static int _calcularConfianca(Map<String, dynamic> respostas) {
    int pontuacao = 0;

    if (respostas['confianca_q21'] != null) {
      pontuacao += _converterLikert(respostas['confianca_q21']);
    }
    if (respostas['confianca_q22'] != null) {
      pontuacao += _converterLikert(respostas['confianca_q22']);
    }

    return pontuacao.clamp(0, 8);
  }

  static int _converterLikert(String resposta) {
    const mapa = {
      'Nunca': 0,
      'Quase nunca': 1,
      'Algumas vezes': 2,
      'Muitas vezes': 3,
      'Sempre': 4,
      'Raramente ou nunca': 0,
      'Algumas vezes por ano': 1,
      'Duas a três vezes por mês': 2,
      'Uma vez por semana': 3,
      'Mais de 1 vez por semana': 4,
      'Poucas vezes por mês': 1,
      'Duas ou mais vezes por semana': 3,
      '1 vez ao dia': 4,
      'Mais de uma vez ao dia': 4,
    };
    return mapa[resposta] ?? 0;
  }
}
