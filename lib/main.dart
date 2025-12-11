import 'package:flutter/material.dart';
// import 'package:flutter_tts/flutter_tts.dart'; // Descomentar após instalar dependência
// import 'package:speech_to_text/speech_to_text.dart'; // Descomentar após instalar dependência

void main() {
  runApp(const ComunicaFacilApp());
}

class ComunicaFacilApp extends StatelessWidget {
  const ComunicaFacilApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ComunicaFácil',
      debugShowCheckedModeBanner: false,
      // [NF001] Usabilidade: Alto contraste e interface minimalista
      theme: ThemeData(
        primaryColor: const Color(0xFF0D47A1), // Azul Institucional
        scaffoldBackgroundColor: const Color(0xFFF5F5F5), // Off-white para contraste
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D47A1),
            foregroundColor: Colors.white,
            textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

// ---------------------------------------------------------
// TELA INICIAL: Seleção de Modo
// ---------------------------------------------------------
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ComunicaFácil', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botão Gigante para "Quero Falar" (Foco no Usuário Surdo)
            _buildBigButton(
              context,
              icon: Icons.record_voice_over,
              label: "QUERO FALAR\n(Usar Ícones)",
              color: const Color(0xFF1565C0), // Azul
              destination: const QueroFalarScreen(),
            ),
            const SizedBox(height: 30),
            // Botão Gigante para "Quero Ouvir" (Foco no Atendente)
            _buildBigButton(
              context,
              icon: Icons.hearing,
              label: "QUERO OUVIR\n(Ler Atendente)",
              color: const Color(0xFF2E7D32), // Verde
              destination: const QueroOuvirScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBigButton(BuildContext context, {required IconData icon, required String label, required Color color, required Widget destination}) {
    return SizedBox(
      width: 300,
      height: 180,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(backgroundColor: color),
        icon: Icon(icon, size: 48),
        label: Text(label, textAlign: TextAlign.center),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => destination));
        },
      ),
    );
  }
}

// ---------------------------------------------------------
// MÓDULO 1: QUERO FALAR (Fluxo Visual + TTS)
// [RF003] Construção de Frases por Fluxo Visual
// [RF002] Conversão de Texto para Voz
// ---------------------------------------------------------
class QueroFalarScreen extends StatefulWidget {
  const QueroFalarScreen({super.key});

  @override
  State<QueroFalarScreen> createState() => _QueroFalarScreenState();
}

class _QueroFalarScreenState extends State<QueroFalarScreen> {
  // Lista de palavras selecionadas
  final List<Map<String, dynamic>> _phraseBuilder = [];

  // Mock de dados (simulando o banco de dados interno de ícones) [cite: 213]
  final List<Map<String, dynamic>> _iconsDb = [
    {'label': 'Olá', 'icon': Icons.waving_hand},
    {'label': 'Eu quero', 'icon': Icons.person},
    {'label': 'Documento', 'icon': Icons.badge},
    {'label': 'Pagar', 'icon': Icons.payment},
    {'label': 'Banheiro', 'icon': Icons.wc},
    {'label': 'Água', 'icon': Icons.water_drop},
    {'label': 'Sim', 'icon': Icons.thumb_up},
    {'label': 'Não', 'icon': Icons.thumb_down},
    {'label': 'Quanto custa?', 'icon': Icons.attach_money},
    {'label': 'Obrigado', 'icon': Icons.sentiment_satisfied_alt},
  ];

  void _addToPhrase(Map<String, dynamic> item) {
    setState(() {
      _phraseBuilder.add(item);
    });
  }

  void _speakPhrase() {
    // Aqui entra a lógica do pacote flutter_tts
    String textToSpeak = _phraseBuilder.map((e) => e['label']).join(" ");
    print("FALANDO: $textToSpeak"); // Mock
    
    // Feedback visual
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Falando: "$textToSpeak"'), duration: const Duration(seconds: 2)),
    );
  }

  void _clearPhrase() {
    setState(() {
      _phraseBuilder.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Construir Frase'),
        actions: [
          // [RF005] Botão Nova Sessão (Limpar)
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 30),
            onPressed: _clearPhrase,
            tooltip: 'Limpar Frase',
          )
        ],
      ),
      body: Column(
        children: [
          // Área de Visualização da Frase (Barra Superior)
          Container(
            height: 120,
            padding: const EdgeInsets.all(10),
            color: Colors.grey[200],
            width: double.infinity,
            child: _phraseBuilder.isEmpty
                ? const Center(child: Text("Selecione os ícones abaixo...", style: TextStyle(fontSize: 18, color: Colors.grey)))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _phraseBuilder.length,
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(_phraseBuilder[index]['icon'], size: 40, color: Colors.blue[800]),
                            Text(_phraseBuilder[index]['label'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          
          const Divider(height: 1, thickness: 2),

          // Grade de Ícones (Fluxo Visual) 
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Ícones grandes
                childAspectRatio: 1.0,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _iconsDb.length,
              itemBuilder: (ctx, index) {
                final item = _iconsDb[index];
                return GestureDetector(
                  onTap: () => _addToPhrase(item),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item['icon'], size: 48, color: Colors.black87),
                        const SizedBox(height: 5),
                        Text(item['label'], textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Botão de Ação Principal (Falar)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2E7D32), minimumSize: const Size(double.infinity, 60)),
              icon: const Icon(Icons.play_circle_fill, size: 32),
              label: const Text("FALAR FRASE", style: TextStyle(fontSize: 24)),
              onPressed: _phraseBuilder.isNotEmpty ? _speakPhrase : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------
// MÓDULO 2: QUERO OUVIR (STT + Texto Grande)
// [RF001] Conversão de Voz para Texto
// ---------------------------------------------------------
class QueroOuvirScreen extends StatefulWidget {
  const QueroOuvirScreen({super.key});

  @override
  State<QueroOuvirScreen> createState() => _QueroOuvirScreenState();
}

class _QueroOuvirScreenState extends State<QueroOuvirScreen> {
  bool _isListening = false;
  String _text = "Pressione o microfone para começar a ouvir o atendente.";
  
  // Simulação de palavras-chave para Apoio Visual [cite: 49, 50]
  String? _visualSupportIcon; 

  void _toggleListening() {
    // Aqui entra a lógica do pacote speech_to_text
    setState(() {
      _isListening = !_isListening;
      if (_isListening) {
        _text = "Ouvindo... (fale agora)";
        _visualSupportIcon = null;
      } else {
        // Simulação de resultado final
        _text = "Por favor, eu preciso ver o seu documento.";
        // Lógica simples de detectar palavra-chave "documento"
        if (_text.toLowerCase().contains("documento")) {
          _visualSupportIcon = "badge"; // Nome do ícone a ser renderizado
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ouvir Atendente'),
        actions: [
            // [RF005] Nova Sessão
             IconButton(
            icon: const Icon(Icons.refresh, size: 30),
            onPressed: () {
                setState(() {
                    _text = "Pressione o microfone...";
                    _visualSupportIcon = null;
                    _isListening = false;
                });
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Área de Texto Transcrito (Fonte Grande) 
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Text(
                        _text,
                        style: const TextStyle(
                          fontSize: 32, // Fonte muito grande conforme requisito
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          height: 1.3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 30),
                      // Área de Apoio Visual (Ícone condicional) 
                      if (_visualSupportIcon != null)
                        Container(
                           padding: const EdgeInsets.all(20),
                           decoration: BoxDecoration(color: Colors.yellow[100], borderRadius: BorderRadius.circular(10)),
                           child: Column(
                             children: const [
                               Icon(Icons.badge, size: 80, color: Colors.orange), // Exemplo fixo
                               Text("PEDIU DOCUMENTO", style: TextStyle(fontWeight: FontWeight.bold))
                             ],
                           ),
                        )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Controle de Microfone
            SizedBox(
              width: double.infinity,
              height: 80,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isListening ? Colors.red : const Color(0xFF0D47A1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                ),
                icon: Icon(_isListening ? Icons.stop : Icons.mic, size: 40),
                label: Text(_isListening ? "PARAR ESCUTA" : "OUVIR AGORA", style: const TextStyle(fontSize: 20)),
                onPressed: _toggleListening,
              ),
            ),
          ],
        ),
      ),
    );
  }
}