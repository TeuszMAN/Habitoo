class Questao {
  final String chave;
  final String dominio;
  final String titulo;
  final List<String> opcoes;
  final bool isDicotomica;

  Questao({
    required this.chave,
    required this.dominio,
    required this.titulo,
    this.opcoes = const [],
    this.isDicotomica = false,
  });
}

final List<Questao> listQuestoes = [
  Questao(
    chave: 'nutricao_q1',
    dominio: 'Nutrição',
    titulo:
        "1. Com que frequência você inclui nas principais refeições do dia: feijões, cereais integrais, castanhas, frutas, legumes e verduras?",
    opcoes: [
      "Quase nunca",
      "Raramente",
      "Algumas vezes",
      "Muitas vezes",
      "Sempre",
    ],
  ),
  Questao(
    chave: 'nutricao_q2',
    dominio: 'Nutrição',
    titulo:
        "2. Como você se classifica no que se refere ao tipo de alimento que você mais consome?",
    opcoes: [
      "Não vegetariano: Consome carne de tipos variados mais de 1 vez por semana",
      "Semi Vegetariano: Consome carne de tipos variados no máximo 1 vez por semana",
      "Pesco Vegetariano: Consome carne, frango e outras aves menos de 1 vez por mês, e consome peixe mais de 1 vez por mês",
      "Ovolacto Vegetariano: Consome laticínios e ovos mais que 1 vez por mês e peixes e carnes menos que 1 vez por mês",
      "Vegetariano estrito: Consome leite, queijo, ovos, peixe ou carne no máximo 1 vez por mês ou menos",
    ],
  ),
  Questao(
    chave: 'nutricao_q3',
    dominio: 'Nutrição',
    titulo:
        "3. Quantos dos itens a seguir você consome uma ou mais vezes por semana? (salgadinhos, bolachas, frituras, refrigerantes e doces de maneira geral)",
    opcoes: [
      "Quatro a cinco itens",
      "Três itens",
      "Dois itens",
      "Um item",
      "Nenhum",
    ],
  ),

  Questao(
    chave: 'exercicio_q4',
    dominio: 'Exercício',
    titulo:
        "4. Você pratica atividades de lazer, tais como caminhar, pedalar, jogar bola, esportes radicais ou outros hobbies e atividades prazerosas?",
    opcoes: ["Nunca", "Raramente", "Algumas vezes", "Muitas vezes", "Sempre"],
  ),
  Questao(
    chave: 'exercicio_q5',
    dominio: 'Exercício',
    titulo:
        "5. Quantas vezes por semana você pratica exercício físico intenso (que faz suar e aumentar os batimentos cardíacos, como caminhada longa, corrida, bicicleta, etc)?",
    opcoes: [
      "Nunca",
      "Menos de 1 vez por semana",
      "1 a 2 vezes por semana",
      "3 a 4 vezes por semana",
      "5 vezes ou mais por semana",
    ],
  ),
  Questao(
    chave: 'exercicio_q6',
    dominio: 'Exercício',
    titulo:
        "6. Quantos minutos você gasta 'em média' quando faz exercícios intensos até suar?",
    opcoes: [
      "Nenhum, não faço",
      "5 a 10 minutos",
      "10 a 20 minutos",
      "21 a 30 minutos",
      "30 a 60 minutos",
    ],
  ),

  Questao(
    chave: 'agua_q7',
    dominio: 'Água',
    titulo: "7. Quantos copos (250 ml) de água você bebe diariamente?",
    opcoes: ["Nenhum", "1 a 3 copos", "4 a 6 copos", "7 copos", "8 ou mais"],
  ),
  Questao(
    chave: 'agua_q8',
    dominio: 'Água',
    titulo:
        "8. Você utiliza a água como remédio para tratamentos caseiros quando necessário? (Por exemplo, compressas quentes e frias, aplicação de gelo, inalação, escalda pés e banhos em geral).",
    opcoes: ["Nunca", "Raramente", "Algumas vezes", "Muitas vezes", "Sempre"],
  ),

  Questao(
    chave: 'sol_q9',
    dominio: 'Sol',
    titulo:
        "9. Com que frequência você se expõe ao sol pelo menos 15 a 20 minutos por dia?",
    opcoes: ["Nunca", "Quase nunca", "Algumas vezes", "Muitas vezes", "Sempre"],
  ),
  Questao(
    chave: 'sol_q10',
    dominio: 'Sol',
    titulo:
        "10. Em sua casa, as janelas e persianas são abertas diariamente para que entrem sol e luz natural?",
    opcoes: ["Nunca", "Quase nunca", "Algumas vezes", "Muitas vezes", "Sempre"],
  ),

  Questao(
    chave: 'temperanca_q11',
    dominio: 'Temperança',
    titulo:
        "11. Você ingere bebida alcóolica (cerveja, vinho, licor, aguardente, pinga ou qualquer outra)?",
    isDicotomica: true,
  ),
  Questao(
    chave: 'temperanca_q12',
    dominio: 'Temperança',
    titulo:
        "12. Você fuma cigarro, charuto, cachimbo ou qualquer outro tipo de tabaco?",
    isDicotomica: true,
  ),
  Questao(
    chave: 'temperanca_q13',
    dominio: 'Temperança',
    titulo:
        "13. Você fez uso de alguma droga, tipo maconha, crack, cocaína, etc nos últimos três meses?",
    isDicotomica: true,
  ),
  Questao(
    chave: 'temperanca_q14',
    dominio: 'Temperança',
    titulo:
        "14. Você ingere bebidas que contém cafeína (café, chá preto, chá verde, chá mate, chá branco ou refrigerantes)?",
    isDicotomica: true,
  ),

  Questao(
    chave: 'ar_puro_q15',
    dominio: 'Ar Puro',
    titulo:
        "15. Considerando os lugares onde passa a maior parte do tempo, como você classifica a qualidade do ar que respira?",
    opcoes: ["Muito ruim", "Ruim", "Regular", "Boa", "Muito boa"],
  ),
  Questao(
    chave: 'ar_puro_q16',
    dominio: 'Ar Puro',
    titulo:
        "16. Você faz respiração profunda ao ar livre ou quando precisa controlar a tensão e a ansiedade?",
    opcoes: ["Nunca", "Raramente", "Algumas vezes", "Muitas vezes", "Sempre"],
  ),

  Questao(
    chave: 'descanso_q17',
    dominio: 'Descanso',
    titulo:
        "17. Você dorme de 7 a 8 horas por noite e acorda descansado(a) e com boa disposição na maioria das vezes?",
    opcoes: ["Nunca", "Quase nunca", "Algumas vezes", "Muitas vezes", "Sempre"],
  ),
  Questao(
    chave: 'descanso_q18',
    dominio: 'Descanso',
    titulo:
        "18. Você costuma dormir cedo (por volta das 22h ou antes desse horário)?",
    opcoes: ["Nunca", "Quase nunca", "Algumas vezes", "Muitas vezes", "Sempre"],
  ),

  Questao(
    chave: 'confianca_q19',
    dominio: 'Confiança',
    titulo: "19. Você confia em Deus (em um Ser Superior ou algo sagrado)?",
    opcoes: ["Nunca", "Quase nunca", "Algumas vezes", "Muitas vezes", "Sempre"],
  ),
  Questao(
    chave: 'confianca_q20',
    dominio: 'Confiança',
    titulo:
        "20. Sua confiança em Deus (Ser Superior ou algo sagrado) influencia positivamente sua maneira de viver?",
    opcoes: ["Nunca", "Quase nunca", "Algumas vezes", "Muitas vezes", "Sempre"],
  ),
  Questao(
    chave: 'confianca_q21',
    dominio: 'Confiança',
    titulo:
        "21. Com que frequência você participa de reuniões religiosas ou espirituais?",
    opcoes: [
      "Raramente ou nunca",
      "Algumas vezes por ano",
      "Duas a três vezes por mês",
      "Uma vez por semana",
      "Mais de 1 vez por semana",
    ],
  ),
  Questao(
    chave: 'confianca_q22',
    dominio: 'Confiança',
    titulo:
        "22. Você pratica atividades religiosas ou espirituais em sua vida particular (meditar, rezar ou orar, ler a Bíblia ou livros religiosos, se voluntariar, fazer caridade, etc.)?",
    opcoes: [
      "Raramente ou nunca",
      "Poucas vezes por mês",
      "Duas ou mais vezes por semana",
      "1 vez ao dia",
      "Mais de uma vez ao dia",
    ],
  ),
];
