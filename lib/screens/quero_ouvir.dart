import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/stt_service.dart';
import '../models/fluxo_icon.dart';

class QueroOuvirScreen extends StatefulWidget {
  const QueroOuvirScreen({super.key});

  @override
  State<QueroOuvirScreen> createState() => _QueroOuvirScreenState();
}

class _QueroOuvirScreenState extends State<QueroOuvirScreen> {
  String textoCapturado = '';
  List<FluxoIcon> iconesDeApoio = [];

  // Vocabulário de ícones para apoio visual
  final List<FluxoIcon> vocabulario = [
    FluxoIcon(id: '1', label: 'Comer', asset: 'assets/comer.png'),
    FluxoIcon(id: '2', label: 'Água', asset: 'assets/agua.png'),
    FluxoIcon(id: '3', label: 'Ajuda', asset: 'assets/ajuda.png'),
    FluxoIcon(id: '4', label: 'Banheiro', asset: 'assets/banheiro.png'),
    FluxoIcon(id: '5', label: 'Olá', asset: 'assets/ola.png'),
  ];

  void iniciarEscuta() async {
    final stt = Provider.of<SttService>(context, listen: false);
    await stt.start((texto) {
      setState(() {
        textoCapturado = texto;
        iconesDeApoio = vocabularioPorPalavras(texto);
      });
    });
  }

  List<FluxoIcon> vocabularioPorPalavras(String texto) {
    final palavras = texto.toLowerCase().split(RegExp(r'\s+'));
    return vocabulario.where((ic) => palavras.contains(ic.label.toLowerCase())).toList();
  }

  void pararEscuta() async {
    final stt = Provider.of<SttService>(context, listen: false);
    await stt.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quero Ouvir')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: iniciarEscuta,
                  icon: const Icon(Icons.mic),
                  label: const Text('Capturar Fala'),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: pararEscuta,
                  icon: const Icon(Icons.stop),
                  label: const Text('Parar'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              textoCapturado.isEmpty ? 'Nenhum texto capturado ainda' : textoCapturado,
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: iconesDeApoio.map((ic) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(ic.asset, width: 60, height: 60),
                    Text(ic.label),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}