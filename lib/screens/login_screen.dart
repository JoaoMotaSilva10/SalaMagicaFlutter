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

      if (response.statusCode == 200 && response.body.toLowerCase() == 'true') {
        final perfil = await ApiService.buscarPerfil(usuario);
        if (perfil != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => InicioScreen(usuario: perfil)),
          );
        } else {
          setState(() => _erro = 'Erro ao carregar perfil');
        }
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  'lib/assets/logo.png', // coloque sua logo aqui
                  height: 40,
                ),
                const SizedBox(height: 32),

                const Text('Bem-vindo(a)!'),
                const SizedBox(height: 8),
                const Text('Acesse sua conta!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text(
                  'Garanta seus equipamentos com rapidez e segurança.',
                  style: TextStyle(color: Colors.black54),
                ),
                const SizedBox(height: 32),

                Text('Nome de usuário'),
                const SizedBox(height: 6),
                TextField(
                  controller: _usuarioController,
                  decoration: InputDecoration(
                    hintText: 'Digite aqui seu nome de usuário',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(height: 20),

                Text('Senha'),
                const SizedBox(height: 6),
                TextField(
                  controller: _senhaController,
                  obscureText: !_mostrarSenha,
                  decoration: InputDecoration(
                    hintText: 'Digite aqui sua senha',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    suffixIcon: IconButton(
                      icon: Icon(_mostrarSenha ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() => _mostrarSenha = !_mostrarSenha);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: _manterConexao,
                          onChanged: (value) => setState(() => _manterConexao = value!),
                        ),
                        const Text('Manter conexão'),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Esqueceu a senha?'),
                    ),
                  ],
                ),

                if (_erro != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(_erro!, style: const TextStyle(color: Colors.red)),
                  ),

                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _carregando ? null : _login,
                    child: _carregando
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Entrar', style: TextStyle(fontSize: 16)),
                  ),
                ),

                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Não possui uma conta?', style: TextStyle(color: Colors.grey)),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, AppRoutes.cadastro);
                      },
                      child: const Text('Cadastre-se!', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
