import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../routes.dart';

class ResetSenhaScreen extends StatefulWidget {
  const ResetSenhaScreen({super.key});

  @override
  State<ResetSenhaScreen> createState() => _ResetSenhaScreenState();
}

class _ResetSenhaScreenState extends State<ResetSenhaScreen> {
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  final TextEditingController _confirmarSenhaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _carregando = false;
  bool _mostrarSenha = false;
  bool _mostrarConfirmarSenha = false;
  String? _erro;
  bool _senhaRedefinida = false;

  Future<void> _redefinirSenha() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final response = await ApiService.redefinirSenha(
        _tokenController.text.trim(),
        _senhaController.text,
      );
      if (response.statusCode == 200) {
        setState(() {
          _senhaRedefinida = true;
        });
      } else {
        setState(() {
          _erro = "Erro ao redefinir senha. Verifique os dados.";
        });
      }
    } catch (e) {
      setState(() {
        _erro = "Erro de conexão. Tente novamente.";
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  String? _validarToken(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite o código recebido';
    }
    if (value.length < 6) {
      return 'O código deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  String? _validarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite uma senha';
    }
    if (value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  String? _validarConfirmarSenha(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, confirme sua senha';
    }
    if (value != _senhaController.text) {
      return 'As senhas não coincidem';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Redefinir senha"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _senhaRedefinida ? _buildSucessoWidget() : _buildFormulario(),
        ),
      ),
    );
  }

  Widget _buildFormulario() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nova senha',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Digite o código recebido por e-mail e crie uma nova senha.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 32),
            const Text('Código de recuperação'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _tokenController,
              keyboardType: TextInputType.text,
              validator: _validarToken,
              decoration: const InputDecoration(
                hintText: 'Digite o código recebido',
                prefixIcon: Icon(Icons.security),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Nova senha'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _senhaController,
              obscureText: !_mostrarSenha,
              validator: _validarSenha,
              decoration: InputDecoration(
                hintText: 'Digite sua nova senha',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_mostrarSenha ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() => _mostrarSenha = !_mostrarSenha);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Confirmar nova senha'),
            const SizedBox(height: 6),
            TextFormField(
              controller: _confirmarSenhaController,
              obscureText: !_mostrarConfirmarSenha,
              validator: _validarConfirmarSenha,
              decoration: InputDecoration(
                hintText: 'Confirme sua nova senha',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_mostrarConfirmarSenha ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() => _mostrarConfirmarSenha = !_mostrarConfirmarSenha);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_erro != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade600, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _erro!,
                        style: TextStyle(color: Colors.red.shade600),
                      ),
                    ),
                  ],
                ),
              ),
            if (_erro != null) const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _carregando ? null : _redefinirSenha,
                child: _carregando
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Redefinir senha'),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Voltar'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSucessoWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle,
            size: 60,
            color: Colors.green.shade600,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Senha redefinida!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sua senha foi alterada com sucesso.\nAgora você pode fazer login com sua nova senha.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            child: const Text('Fazer login'),
          ),
        ),
      ],
    );
  }
}
