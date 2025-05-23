import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';
import '../providers/theme_provider.dart'; // Importação correta do ThemeProvider

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: theme.primaryColor,
                child: Icon(
                  Icons.person,
                  size: 50,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'João Pedro Mota Silva',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildProfileItem(context, 'RM:', '90319'),
            _buildProfileItem(context, 'Unidade:', 'ITB - Brasília Flores de Azevedo'),
            _buildProfileItem(context, 'Turma:', 'INF2CM'),
            _buildProfileItem(context, 'Série:', '2º série'),
            _buildProfileItem(context, 'Período:', 'Manhã'),
            _buildProfileItem(context, 'CPF:', 'XXX.XXX.XXX-46'),
            const Divider(height: 40),
            SwitchListTile(
              title: const Text('Modo Escuro'),
              value: themeProvider.isDarkMode,
              onChanged: (value) => themeProvider.toggleTheme(),
              secondary: Icon(
                themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color: theme.iconTheme.color,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Sair da conta'),
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, String label, String value) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleMedium?.color,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}