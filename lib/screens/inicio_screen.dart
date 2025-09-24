import 'package:flutter/material.dart';
import '../model/usuario.dart';
import '../routes.dart';
import '../widgets/gradient_background.dart';
import '../widgets/modern_card.dart';

class InicioScreen extends StatelessWidget {
  final Usuario usuario;

  const InicioScreen({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Topo: logo + botão de perfil
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6200ea).withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/logo.png',
                        width: 40,
                        color: Colors.white,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6200ea), Color(0xFF7e3ff2)],
                        ),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6200ea).withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.person, color: Colors.white, size: 28),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            AppRoutes.perfil,
                            arguments: usuario,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.white, Color(0xFFa97fff)],
                  ).createShader(bounds),
                  child: Text(
                    'Bem-vindo(a),',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                ShaderMask(
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [Colors.white, Color(0xFFa97fff)],
                  ).createShader(bounds),
                  child: Text(
                    usuario.nome,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
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
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return ModernCard(
      onTap: onTap,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6200ea), Color(0xFF7e3ff2)],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6200ea).withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
