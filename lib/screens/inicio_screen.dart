import 'package:flutter/material.dart';
import '../model/usuario.dart';
import '../routes.dart';

class InicioScreen extends StatelessWidget {
  final Usuario usuario;

  const InicioScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Topo: logo + botão de perfil
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'lib/assets/logo.png',
                    width: 40,
                    color: isDark ? Colors.white : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.person, color: textColor, size: 28),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.perfil,
                        arguments: usuario,
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                'Bem-vindo(a) de volta,',
                style: TextStyle(
                  fontSize: 16,
                  color: textColor.withOpacity(0.8),
                ),
              ),
              Text(
                usuario.nome,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 24,
                  crossAxisSpacing: 24,
                  children: [
                    _buildMenuButton(
                      context,
                      icon: Icons.bookmark,
                      label: 'Reservar Sala',
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.reservarSala,
                        arguments: usuario,
                      ),
                    ),
                    _buildMenuButton(
                      context,
                      icon: Icons.desktop_mac,
                      label: 'Reservar Equipamento',
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.reservarEquipamento,
                        arguments: usuario,
                      ),
                    ),
                    _buildMenuButton(
                      context,
                      icon: Icons.calendar_month,
                      label: 'Minhas Reservas',
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.minhasReservas,
                        arguments: usuario,
                      ),
                    ),
                    _buildMenuButton(
                      context,
                      icon: Icons.support_agent,
                      label: 'Suporte',
                      onTap: () => Navigator.pushNamed(
                        context,
                        AppRoutes.mensagens,
                        arguments: usuario,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isDark ? Colors.black : Colors.white,
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
