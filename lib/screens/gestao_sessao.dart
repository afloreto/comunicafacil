import 'package:flutter/material.dart';

class GestaoSessaoScreen extends StatelessWidget {
  const GestaoSessaoScreen({super.key});

  void novaSessao(BuildContext context) {
    // Aqui você pode limpar variáveis globais, histórico, etc.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Nova sessão iniciada')),
    );
    // Navegar para tela inicial ou reiniciar estado
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gestão de Sessão')),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => novaSessao(context),
          icon: const Icon(Icons.refresh),
          label: const Text('Iniciar Nova Sessão'),
        ),
      ),
    );
  }
}
