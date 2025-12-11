import 'package:flutter/material.dart';
import '../models/fluxo_icon.dart';
import '../widgets/icon_grid.dart';
import '../services/tts_service.dart';
import 'package:provider/provider.dart';

class QueroFalarScreen extends StatefulWidget {
  const QueroFalarScreen({super.key});

  @override
  _QueroFalarScreenState createState() => _QueroFalarScreenState();
  
}

class _QueroFalarScreenState extends State<QueroFalarScreen> {
  List<FluxoIcon> selecionados = [];

  List<FluxoIcon> todosIcones = [
    FluxoIcon(id: '1', label: 'Olá', asset: 'assets/ola.png'),
    FluxoIcon(id: '2', label: 'Quero', asset: 'assets/quero.png'),
    FluxoIcon(id: '3', label: 'Comer', asset: 'assets/comer.png'),
    FluxoIcon(id: '4', label: 'Água', asset: 'assets/agua.png'),
    // Adicione mais ícones conforme necessário
  ];

  String montarFrase() {
    return selecionados.map((e) => e.label).join(' ');
  }

  void falarFrase() {
    final frase = montarFrase();
    final tts = Provider.of<TtsService>(context, listen: false);
    tts.speak(frase);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quero Falar')),
      body: Column(
        children: [
          IconGrid(
            icons: todosIcones,
            onSelect: (ic) {
              setState(() {
                selecionados.add(ic);
              });
            },
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              montarFrase(),
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            onPressed: falarFrase,
            child: Text('Falar Frase'),
          ),
        ],
      ),
    );
  }
}
