import 'package:speech_to_text/speech_to_text.dart' as stt;

class SttService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool available = false;

  Future<void> init() async {
    available = await _speech.initialize();
  }

  Future<void> start(Function(String) onResult) async {
    if (!available) await init();
    await _speech.listen(
      onResult: (result) {
        if (result.finalResult) {
          onResult(result.recognizedWords);
        }
      },
      localeId: 'pt_BR',
    );
  }

  Future<void> stop() async {
    await _speech.stop();
  }
}