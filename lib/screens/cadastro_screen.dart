import 'package:flutter/material.dart';
import 'login_screen.dart';

class CadastroScreen extends StatelessWidget {
  const CadastroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Registre sua conta!', style: TextStyle(fontSize: 24)),
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
              decoration: const InputDecoration(
                labelText: 'Nome de usuário',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar senha',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Lógica de cadastro
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              child: const Text('Cadastrar-se'),
            ),
            TextButton(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              ),
              child: const Text('Já possui uma conta? Entre!'),
            ),
          ],
        ),
      ),
    );
  }
}