import 'package:flutter/material.dart';
import 'package:sala_magica/screens/inicio_screen.dart';
import '../api/api_service.dart';
import '../routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _carregando = false;
  String? _erro;

  Future<void> _login() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    try {
      final response = await ApiService.login(email, senha);

      if (response.statusCode == 200) {
        final sucesso = response.body.toLowerCase() == 'true';
        if (sucesso) {
          final usuario = await ApiService.buscarPerfil(email);

          if (usuario != null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => InicioScreen(usuario: usuario)),
            );
          } else {
            setState(() => _erro = 'Erro ao carregar perfil');
          }
        } else {
          setState(() => _erro = 'E-mail ou senha incorretos');
        }
      } else {
        setState(() => _erro = 'Erro ao fazer login (${response.statusCode})');
      }
    } catch (e) {
      setState(() => _erro = 'Erro de conexão');
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Bem-vindo!',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _senhaController,
                  decoration: const InputDecoration(labelText: 'Senha'),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                if (_erro != null)
                  Text(
                    _erro!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                if (_carregando)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: _login,
                    child: const Text('Entrar'),
                  ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.cadastro);
                  },
                  child: const Text('Criar conta'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
