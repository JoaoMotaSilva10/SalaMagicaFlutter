import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../routes.dart';
import '../widgets/gradient_background.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool _carregando = false;
  bool _mostrarSenha = false;
  bool _mostrarConfirmarSenha = false;
  String? _erro;

  Future<void> _cadastrar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _carregando = true;
      _erro = null;
    });

    final novoUsuario = {
      "nome": _nomeController.text.trim(),
      "email": _emailController.text.trim(),
      "senha": _senhaController.text.trim(),
      "nivelAcesso": "USER",
      "statusUsuario": "ATIVO",
      "foto": null,
    };

    try {
      final response = await ApiService.cadastrarUsuario(novoUsuario);
      if (response.statusCode == 200) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        setState(() => _erro = 'Erro: ${response.body}');
      }
    } catch (e) {
      setState(() => _erro = 'Erro ao conectar ao servidor');
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
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height - 
                      MediaQuery.of(context).padding.top - 
                      MediaQuery.of(context).padding.bottom - 48,
                ),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
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
                              'Registre sua conta!',
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Abra as portas para um mundo de possibilidades.',
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
                      'Email',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Digite aqui seu email',
                        prefixIcon: Icon(Icons.email, color: Color(0xFF7e3ff2)),
                      ),
                      validator: (value) => value!.isEmpty ? 'Informe seu email' : null,
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Nome de usuário',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nomeController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Digite aqui seu nome de usuário',
                        prefixIcon: Icon(Icons.person, color: Color(0xFF7e3ff2)),
                      ),
                      validator: (value) => value!.isEmpty ? 'Informe seu nome' : null,
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
                    TextFormField(
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
                          onPressed: () => setState(() => _mostrarSenha = !_mostrarSenha),
                        ),
                      ),
                      validator: (value) =>
                          value!.length < 6 ? 'Senha muito curta (mín. 6 caracteres)' : null,
                    ),
                    const SizedBox(height: 24),

                    const Text(
                      'Confirmar senha',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _confirmarSenhaController,
                      obscureText: !_mostrarConfirmarSenha,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Confirme aqui sua senha',
                        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF7e3ff2)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _mostrarConfirmarSenha ? Icons.visibility : Icons.visibility_off,
                            color: const Color(0xFF7e3ff2),
                          ),
                          onPressed: () =>
                              setState(() => _mostrarConfirmarSenha = !_mostrarConfirmarSenha),
                        ),
                      ),
                      validator: (value) {
                        if (value != _senhaController.text) {
                          return 'As senhas não coincidem';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    if (_erro != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
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
                        onPressed: _carregando ? null : _cadastrar,
                        child: _carregando
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Cadastrar-se',
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
                          'Já possui uma conta? ',
                          style: TextStyle(color: Colors.white.withOpacity(0.8)),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Entre!',
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
          ),
        ),
      ),
    );
  }
}
