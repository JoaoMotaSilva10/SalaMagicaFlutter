import 'package:flutter/material.dart';
import '../model/usuario.dart';
import 'inicio_screen.dart';

class MensagemEnviadaScreen extends StatelessWidget {
  final Usuario usuario;

  const MensagemEnviadaScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.mark_email_read, size: 60, color: Colors.green),
              const SizedBox(height: 20),
              const Text(
                'Mensagem enviada com sucesso!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'Em breve, nossa equipe de suporte entrará em contato.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => InicioScreen(usuario: usuario),
                    ),
                  );
                },
                child: const Text('Voltar ao início'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
