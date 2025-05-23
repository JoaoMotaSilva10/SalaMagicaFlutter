import 'package:flutter/material.dart';
import 'cadastro_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Faça seu login', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 20),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 15),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica de login
              },
              child: const Text('Entrar'),
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const CadastroScreen()),
              ),
              child: const Text('Não tem conta? Cadastre-se!'),
            ),
          ],
        ),
      ),
    );
  }
}