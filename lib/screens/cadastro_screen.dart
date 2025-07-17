import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../routes.dart';

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  Image.asset(
                    'assets/logo.png',
                    height: 40,
                  ),
                  const SizedBox(height: 32),

                  const Text('Bem-vindo(a)!'),
                  const SizedBox(height: 8),
                  const Text(
                    'Registre sua conta!',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Abra as portas para um mundo de possibilidades.',
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 32),

                  const Text('Email'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      hintText: 'Digite aqui seu email',
                    ),
                    validator: (value) => value!.isEmpty ? 'Informe seu email' : null,
                  ),
                  const SizedBox(height: 20),

                  const Text('Nome de usuário'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(
                      hintText: 'Digite aqui seu nome de usuário',
                    ),
                    validator: (value) => value!.isEmpty ? 'Informe seu nome' : null,
                  ),
                  const SizedBox(height: 20),

                  const Text('Senha'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _senhaController,
                    obscureText: !_mostrarSenha,
                    decoration: InputDecoration(
                      hintText: 'Digite aqui sua senha',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _mostrarSenha ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () => setState(() => _mostrarSenha = !_mostrarSenha),
                      ),
                    ),
                    validator: (value) =>
                        value!.length < 6 ? 'Senha muito curta (mín. 6 caracteres)' : null,
                  ),
                  const SizedBox(height: 20),

                  const Text('Confirmar senha'),
                  const SizedBox(height: 6),
                  TextFormField(
                    controller: _confirmarSenhaController,
                    obscureText: !_mostrarConfirmarSenha,
                    decoration: InputDecoration(
                      hintText: 'Confirme aqui sua senha',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _mostrarConfirmarSenha ? Icons.visibility : Icons.visibility_off,
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
                  const SizedBox(height: 24),

                  if (_erro != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text(_erro!, style: const TextStyle(color: Colors.red)),
                    ),

                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _carregando ? null : _cadastrar,
                      child: _carregando
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Cadastrar-se'),
                    ),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Já possui uma conta?', style: TextStyle(color: Colors.grey)),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Entre!', style: TextStyle(fontWeight: FontWeight.bold)),
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
