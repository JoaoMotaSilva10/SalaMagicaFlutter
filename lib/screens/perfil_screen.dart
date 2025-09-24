import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../model/usuario.dart';
import '../widgets/gradient_background.dart';
import '../widgets/modern_button.dart';
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Color(0xFFa97fff)],
          ).createShader(bounds),
          child: const Text(
            'Meu Perfil',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6200ea), Color(0xFF7e3ff2)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: GradientBackground(
        child: carregando
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF7e3ff2),
                ),
              )
            : erro != null
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Text(
                        erro!,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  )
                : perfil == null
                    ? const Center(
                        child: Text(
                          'Nenhum dado encontrado.',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF6200ea), Color(0xFF7e3ff2)],
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF6200ea).withOpacity(0.4),
                                      blurRadius: 20,
                                      spreadRadius: 5,
                                    ),
                                  ],
                                ),
                                child: const CircleAvatar(
                                  radius: 60,
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    Icons.person,
                                    size: 60,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Center(
                              child: ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [Colors.white, Color(0xFFa97fff)],
                                ).createShader(bounds),
                                child: Text(
                                  perfil!.nome.toString(),
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            _buildProfileItem(context, 'RM:', perfil!.rm?.toString() ?? '-'),
                            _buildProfileItem(context, 'Unidade:', perfil!.unidade?.toString() ?? '-'),
                            _buildProfileItem(context, 'Turma:', perfil!.turma?.toString() ?? '-'),
                            _buildProfileItem(context, 'Série:', perfil!.serie?.toString() ?? '-'),
                            _buildProfileItem(context, 'Período:', perfil!.periodo?.toString() ?? '-'),
                            _buildProfileItem(context, 'CPF:', perfil!.cpf?.toString() ?? '-'),
                            const SizedBox(height: 40),
                            ModernButton(
                              text: 'Sair da conta',
                              icon: Icons.logout,
                              backgroundColor: Colors.red,
                              onPressed: () => _confirmarLogout(context),
                            ),
                          ],
                        ),
                      ),
      ),
    );
  }

  Widget _buildProfileItem(BuildContext context, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1f1f1f), Color(0xFF2a2a2a)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF6200ea).withOpacity(0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF7e3ff2),
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
