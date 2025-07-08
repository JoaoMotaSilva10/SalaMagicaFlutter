import 'package:flutter/material.dart';
import '../routes.dart';
import '../model/usuario.dart';

class TipoReservaScreen extends StatelessWidget {
  final Usuario usuario;

  const TipoReservaScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reservas')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.meeting_room),
              label: const Text('Reservar Sala'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.reservarSala,
                  arguments: usuario,
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.devices_other),
              label: const Text('Reservar Equipamento'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.reservarEquipamento,
                  arguments: usuario,
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              label: const Text('Minhas Reservas'),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.minhasReservas,
                  arguments: usuario,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
