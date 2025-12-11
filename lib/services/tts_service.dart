import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _tts = FlutterTts();

  TtsService() {
    _tts.setLanguage("pt-BR");      // idioma português
    _tts.setSpeechRate(0.45);       // velocidade da fala
    _tts.setVolume(1.0);            // volume máximo
    _tts.setPitch(1.0);             // tom normal
  }

  Future<void> speak(String text) async {
    await _tts.stop();              // para qualquer fala anterior
    await _tts.speak(text);         // fala o texto
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}