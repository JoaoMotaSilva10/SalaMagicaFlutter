import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'reservar_sala_screen.dart';
import 'reservar_equipamento_screen.dart';
import 'minhas_reservas_screen.dart';
import 'suporte_screen.dart';
import 'perfil_screen.dart';
import '../main.dart'; // Para acessar o ThemeProvider

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo(a), João Pedro!'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: theme.iconTheme.color,
            ),
            onPressed: () => themeProvider.toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PerfilScreen()),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildMenuCard(
              context: context,
              title: 'Reservar Sala',
              icon: Icons.meeting_room,
              destination: const ReservarSalaScreen(),
            ),
            _buildMenuCard(
              context: context,
              title: 'Reservar Equipamento',
              icon: Icons.computer,
              destination: const ReservarEquipamentoScreen(),
            ),
            _buildMenuCard(
              context: context,
              title: 'Minhas Reservas',
              icon: Icons.calendar_today,
              destination: const MinhasReservasScreen(),
            ),
            _buildMenuCard(
              context: context,
              title: 'Suporte',
              icon: Icons.support_agent,
              destination: const SuporteScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Widget destination,
  }) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: theme.cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: theme.primaryColor),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.titleMedium?.color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}