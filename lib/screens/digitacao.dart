import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/tts_service.dart';

class DigitacaoScreen extends StatefulWidget {
  const DigitacaoScreen({super.key});

  @override
  State<DigitacaoScreen> createState() => _DigitacaoScreenState();
}

class _DigitacaoScreenState extends State<DigitacaoScreen> {
  final TextEditingController _controller = TextEditingController();

  void falarTexto() {
    final texto = _controller.text.trim();
    if (texto.isNotEmpty) {
      final tts = Provider.of<TtsService>(context, listen: false);
      tts.speak(texto);
    }
  }

  void limparTexto() {
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Digitação Complementar')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Digite sua mensagem:',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 3,
              style: const TextStyle(fontSize: 24),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Escreva aqui...',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: falarTexto,
                  icon: const Icon(Icons.volume_up),
                  label: const Text('Falar'),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: limparTexto,
                  icon: const Icon(Icons.clear),
                  label: const Text('Limpar'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}