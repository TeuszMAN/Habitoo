import 'package:flutter/material.dart';
import 'package:habitoo/services/sqlite_service.dart';
import '../../controllers/form_controller.dart';
import 'result_screen.dart';
import '../widget/questoes.dart';
import 'package:collection/collection.dart';

class QuestionsScreen extends StatefulWidget {
  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final Map<String, dynamic> _respostas = {};
  late final Q8RNFormController _controller;
  final _formKey = GlobalKey<FormState>();
  final List<String> _questoesFaltantes = [];
  final Map<String, List<Questao>> questoesPorDominio = groupBy(
    listQuestoes,
    (q) => q.dominio,
  );

  @override
  void initState() {
    super.initState();

    _controller = Q8RNFormController(SQLiteService());
    _carregarDadosSalvos();
  }

  Future<void> _carregarDadosSalvos() async {
    try {
      final historico = await _controller.carregarHistorico();
      if (historico.isNotEmpty) {
        setState(() {
          _respostas.addAll(historico.last.resposta);
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar dados: $e');
    }
  }

  bool _validarFormulario() {
    _questoesFaltantes.clear();
    final todasChaves = listQuestoes.map((q) => q.chave).toList();
    bool valido = true;

    for (final chave in todasChaves) {
      if (_respostas[chave] == null) {
        _questoesFaltantes.add(chave);
        valido = false;
      }
    }

    if (!valido) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Faltam ${_questoesFaltantes.length} questões'),
          duration: Duration(seconds: 2),
        ),
      );
      setState(() {});
    }

    return valido;
  }

  Future<void> _submeterQuestionario() async {
    if (!_validarFormulario()) return;

    try {
      final resposta = await _controller.submeterFormulario(_respostas);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ResultScreen(resposta: resposta),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar: ${e.toString()}'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Widget _buildQuestaoLikert({
    required String chave,
    required List<String> opcoes,
    required String titulo,
  }) {
    final faltaResponder = _questoesFaltantes.contains(chave);

    return Card(
      color: faltaResponder ? Colors.red.withOpacity(0.1) : null,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: faltaResponder ? Colors.red : null,
              ),
            ),
            if (faltaResponder)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Esta questão é obrigatória',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            ...opcoes.map(
              (opcao) => RadioListTile(
                title: Text(opcao),
                value: opcao,
                groupValue: _respostas[chave],
                onChanged: (value) {
                  setState(() {
                    _respostas[chave] = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestaoDicotomica({
    required String chave,
    required String titulo,
  }) {
    final faltaResponder = _questoesFaltantes.contains(chave);

    return Card(
      color: faltaResponder ? Colors.red.withOpacity(0.1) : null,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: faltaResponder ? Colors.red : null,
              ),
            ),
            if (faltaResponder)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Text(
                  'Esta questão é obrigatória',
                  style: TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: Text('Sim'),
                    value: 'Sim',
                    groupValue: _respostas[chave],
                    onChanged: (value) {
                      setState(() {
                        _respostas[chave] = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: Text('Não'),
                    value: 'Não',
                    groupValue: _respostas[chave],
                    onChanged: (value) {
                      setState(() {
                        _respostas[chave] = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestao(Questao q) {
    if (q.isDicotomica) {
      return _buildQuestaoDicotomica(chave: q.chave, titulo: q.titulo);
    } else {
      return _buildQuestaoLikert(
        chave: q.chave,
        titulo: q.titulo,
        opcoes: q.opcoes,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questionário Q8RN'),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: _submeterQuestionario),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/splash.png',
            opacity: AlwaysStoppedAnimation(0.8),
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Form(
            key: _formKey,
            child: ListView.builder(
              itemCount: questoesPorDominio.length,
              itemBuilder: (context, index) {
                final dominio = questoesPorDominio.keys.elementAt(index);
                return Column(
                  children: [
                    Text(
                      dominio,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ...questoesPorDominio[dominio]!.map(
                      (q) => _buildQuestao(q),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


//
//class QuestionsPage extends StatelessWidget {
// const QuestionsPage({super.key});
//
// @override
//  Widget build(BuildContext context) {
//    return Center(child: Text('Questions Page'));
//  }
//}
//