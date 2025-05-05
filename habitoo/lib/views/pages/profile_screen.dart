import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: ProfileScreen()));

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nomeController = TextEditingController();
  DateTime? _dataNascimento;
  String? _genero;
  double _altura = 170;
  double _peso = 70;

  Future<void> _selecionarData() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dataNascimento) {
      setState(() {
        _dataNascimento = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Habitoo'),
        backgroundColor: null,
        foregroundColor: null,
        elevation: 0,
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildCampoTexto("Nome", _nomeController),
                    _buildCampoDataNascimento(),
                    _buildDropdownGenero(),
                    _buildSlider(
                      "Altura (cm)",
                      _altura,
                      100,
                      220,
                      (val) => setState(() => _altura = val),
                    ),
                    _buildSlider(
                      "Peso (kg)",
                      _peso,
                      30,
                      150,
                      (val) => setState(() => _peso = val),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text("ATUALIZAR"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCampoTexto(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: false,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildCampoDataNascimento() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: _selecionarData,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            border: Border.all(),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _dataNascimento == null
                    ? "Data de Nascimento"
                    : "${_dataNascimento!.day}/${_dataNascimento!.month}/${_dataNascimento!.year}",
              ),
              const Icon(Icons.calendar_today),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownGenero() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: _genero,
        decoration: InputDecoration(
          labelText: "Gênero",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items:
            [
              "Masculino",
              "Feminino",
            ].map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
        onChanged: (valor) => setState(() => _genero = valor),
      ),
    );
  }

  Widget _buildSlider(
    String label,
    double valor,
    double min,
    double max,
    ValueChanged<double> onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$label: ${valor.toStringAsFixed(0)}"),
          Slider(
            value: valor,
            min: min,
            max: max,
            divisions: (max - min).toInt(),
            label: valor.toStringAsFixed(0),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
