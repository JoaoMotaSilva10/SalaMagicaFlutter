import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sala_magica/model/usuario.dart';
import 'package:sala_magica/screens/inicio_screen.dart';
import '../api/api_service.dart';
import '../routes.dart';
import '../widgets/gradient_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _carregando = false;
  bool _manterConexao = false;
  bool _mostrarSenha = false;
  String? _erro;

  Future<void> _login() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    final usuario = _usuarioController.text.trim();
    final senha = _senhaController.text.trim();

    try {
  final response = await ApiService.login(usuario, senha);

  if (response.statusCode == 200) {
    final usuarioJson = jsonDecode(response.body);
    final perfil = Usuario.fromJson(usuarioJson);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => InicioScreen(usuario: perfil)),
    );
  } else {
    setState(() => _erro = 'Nome de usuário ou senha incorretos');
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
      backgroundColor: Colors.transparent,
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6200ea).withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/logo.png',
                        height: 60,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported,
                            size: 60,
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  Center(
                    child: Column(
                      children: [
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Colors.white, Color(0xFFa97fff)],
                          ).createShader(bounds),
                          child: const Text(
                            'Bem-vindo(a)!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Colors.white, Color(0xFFa97fff)],
                          ).createShader(bounds),
                          child: const Text(
                            'Acesse sua conta!',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Garanta seus equipamentos com rapidez e segurança.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  const Text(
                    'Nome de usuário',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _usuarioController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Digite aqui seu nome de usuário',
                      prefixIcon: Icon(Icons.person, color: Color(0xFF7e3ff2)),
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'Senha',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _senhaController,
                    obscureText: !_mostrarSenha,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Digite aqui sua senha',
                      prefixIcon: const Icon(Icons.lock, color: Color(0xFF7e3ff2)),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _mostrarSenha ? Icons.visibility : Icons.visibility_off,
                          color: const Color(0xFF7e3ff2),
                        ),
                        onPressed: () {
                          setState(() => _mostrarSenha = !_mostrarSenha);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _manterConexao,
                            onChanged: (value) => setState(() => _manterConexao = value!),
                          ),
                          const Text(
                            'Manter conexão',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.esqueciSenha);
                        },
                        child: const Text('Esqueceu a senha?'),
                      ),
                    ],
                  ),

                  if (_erro != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                        ),
                        child: Text(
                          _erro!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),

                  const SizedBox(height: 32),

                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6200ea), Color(0xFF7e3ff2)],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6200ea).withOpacity(0.4),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: _carregando ? null : _login,
                      child: _carregando
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Entrar',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Não possui uma conta? ',
                        style: TextStyle(color: Colors.white.withOpacity(0.8)),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.cadastro);
                        },
                        child: const Text(
                          'Cadastre-se!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7e3ff2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
