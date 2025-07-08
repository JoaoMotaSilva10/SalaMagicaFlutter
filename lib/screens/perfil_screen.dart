
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../api/api_service.dart';
import '../model/usuario.dart';
import '../providers/theme_provider.dart';
import 'login_screen.dart';

class PerfilScreen extends StatefulWidget {
  final Usuario usuario;

  const PerfilScreen({super.key, required this.usuario});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  Usuario? perfil;
  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    _carregarPerfil();
  }

  Future<void> _carregarPerfil() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final usuario = await ApiService.buscarPerfil(widget.usuario.email);
      if (usuario != null) {
        setState(() {
          perfil = usuario;
        });
      } else {
        setState(() => erro = 'Perfil não encontrado.');
      }
    } catch (e) {
      setState(() => erro = 'Erro de conexão.');
    } finally {
      setState(() => carregando = false);
    }
  }



  void _confirmarLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair da conta'),
        content: const Text('Tem certeza que deseja sair da sua conta?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: carregando
          ? const Center(child: CircularProgressIndicator())
          : erro != null
              ? Center(child: Text(erro!, style: const TextStyle(color: Colors.red)))
              : perfil == null
                  ? const Center(child: Text('Nenhum dado encontrado.'))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: theme.primaryColor,
                              child: Icon(Icons.person, size: 50, color: theme.colorScheme.onPrimary),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              perfil!.nome.toString(),
                              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildProfileItem(context, 'RM:', perfil!.rm?.toString() ?? '-'),
                          _buildProfileItem(context, 'Unidade:', perfil!.unidade?.toString() ?? '-'),
                          _buildProfileItem(context, 'Turma:', perfil!.turma?.toString() ?? '-'),
                          _buildProfileItem(context, 'Série:', perfil!.serie?.toString() ?? '-'),
                          _buildProfileItem(context, 'Período:', perfil!.periodo?.toString() ?? '-'),
                          _buildProfileItem(context, 'CPF:', perfil!.cpf?.toString() ?? '-'),
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
                              onPressed: () => _confirmarLogout(context),
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
              style: TextStyle(fontWeight: FontWeight.bold, color: theme.textTheme.titleMedium?.color),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: theme.textTheme.bodyMedium?.color),
            ),
          ),
        ],
      ),
    );
  }
}
