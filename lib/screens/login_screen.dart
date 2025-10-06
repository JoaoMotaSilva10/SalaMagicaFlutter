import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sala_magica/model/usuario.dart';
import 'package:sala_magica/screens/inicio_screen.dart';
import '../api/api_service.dart';
import '../routes.dart';
import '../services/auth_service.dart';
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

  @override
  void initState() {
    super.initState();
    _verificarUsuarioSalvo();
  }

  Future<void> _verificarUsuarioSalvo() async {
    final usuario = await AuthService.carregarUsuario();
    
    if (usuario != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => InicioScreen(usuario: usuario)),
      );
    }
  }

  Future<void> _salvarUsuario(Usuario usuario) async {
    if (_manterConexao) {
      await AuthService.salvarUsuario(usuario);
    }
  }

  Future<void> _login() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    final usuario = _usuarioController.text.trim();
    final senha = _senhaController.text.trim();

    if (usuario.isEmpty || senha.isEmpty) {
      setState(() {
        _erro = 'Preencha todos os campos';
        _carregando = false;
      });
      return;
    }

    try {
      final response = await ApiService.login(usuario, senha);

      if (response.statusCode == 200) {
        try {
          final responseData = jsonDecode(response.body);
          
          // Debug: verificar dados do login
          print('🔍 DEBUG LOGIN - Response do backend:');
          print('📄 ${jsonEncode(responseData)}');
          
          if (responseData is Map<String, dynamic>) {
            final perfil = Usuario.fromJson(responseData);
            
            // Debug: verificar dados do usuário criado
            print('🔍 DEBUG LOGIN - Usuário criado:');
            print('📄 Nome: ${perfil.nome}');
            print('📄 Email: ${perfil.email}');
            print('📄 RM: ${perfil.rm}');
            print('📄 ID: ${perfil.id}');

            // Salvar usuário se "manter conexão" estiver marcado
            await _salvarUsuario(perfil);

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => InicioScreen(usuario: perfil)),
            );
          } else {
            setState(() => _erro = 'Formato de resposta inválido');
          }
        } catch (parseError) {
          setState(() => _erro = 'Erro ao processar dados do usuário');
        }
      } else if (response.statusCode == 401) {
        setState(() => _erro = 'Email ou senha incorretos');
      } else {
        setState(() => _erro = 'Erro no servidor. Status: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _erro = 'Erro de conexão');
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: GradientBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 24,
                  right: 24,
                  top: 24,
                  bottom: keyboardHeight > 0 ? keyboardHeight + 24 : 24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 48,
                  ),
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
                            height: screenHeight < 700 ? 50 : 60,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.image_not_supported,
                                size: screenHeight < 700 ? 50 : 60,
                                color: Colors.white,
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: screenHeight < 700 ? 20 : 40),

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
                            SizedBox(height: screenHeight < 700 ? 8 : 12),
                            Text(
                              'Garanta seus equipamentos com rapidez e segurança.',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: screenHeight < 700 ? 14 : 16,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: screenHeight < 700 ? 20 : 40),

                      const Text(
                        'Email',
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
                          hintText: 'Digite aqui seu email',
                          prefixIcon: Icon(Icons.person, color: Color(0xFF7e3ff2)),
                        ),
                      ),
                      SizedBox(height: screenHeight < 700 ? 16 : 24),

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
                      SizedBox(height: screenHeight < 700 ? 12 : 16),

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
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.red.withOpacity(0.3)),
                            ),
                            child: Text(
                              _erro!,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),
                        ),

                      SizedBox(height: screenHeight < 700 ? 16 : 24),

                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _carregando ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6200ea),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _carregando
                              ? const CircularProgressIndicator(color: Colors.white)
                              : const Text(
                                  'Entrar',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(height: screenHeight < 700 ? 16 : 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Não tem uma conta? ',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.cadastro);
                            },
                            child: const Text('Cadastre-se'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}