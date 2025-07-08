import 'package:flutter/material.dart';
import '../routes.dart';
import '../model/usuario.dart';

class InicioScreen extends StatelessWidget {
  final Usuario usuario;

  const InicioScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Início'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Perfil',
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.perfil, arguments: usuario);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Bem-vindo!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: const Text('Reservas'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.reserva,
                  arguments: usuario,
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.message),
              label: const Text('Mensagens'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.mensagens,
                  arguments: usuario,
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Sair'),
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
            ),
          ],
        ),
      ),
    );
  }
}
