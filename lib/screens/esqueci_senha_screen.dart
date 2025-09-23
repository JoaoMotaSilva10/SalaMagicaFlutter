import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../routes.dart';

class EsqueciSenhaScreen extends StatefulWidget {
  const EsqueciSenhaScreen({super.key});

  @override
  State<EsqueciSenhaScreen> createState() => _EsqueciSenhaScreenState();
}

class _EsqueciSenhaScreenState extends State<EsqueciSenhaScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _carregando = false;
  String? _erro;
  bool _emailEnviado = false;

  Future<void> _solicitarResetSenha() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final response = await ApiService.esqueciSenha(_emailController.text.trim());
      if (response.statusCode == 200) {
        setState(() {
          _emailEnviado = true;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _erro = "E-mail não encontrado.";
        });
      } else {
        setState(() {
          _erro = "Erro no servidor. Tente novamente mais tarde.";
        });
      }
    } catch (e) {
      setState(() {
        if (e.toString().contains('404')) {
          _erro = "E-mail não encontrado.";
        } else {
          _erro = "Serviço de e-mail temporariamente indisponível.\nPor favor, contate o administrador.";
        }
      });
    } finally {
      setState(() {
        _carregando = false;
      });
    }
  }

  String? _validarEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite seu e-mail';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Digite um e-mail válido';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Esqueci minha senha"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _emailEnviado ? _buildSucessoWidget() : _buildFormulario(),
        ),
      ),
    );
  }

  Widget _buildFormulario() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recuperar senha',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Digite seu e-mail e enviaremos instruções para redefinir sua senha.',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          const Text('E-mail'),
          const SizedBox(height: 6),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: _validarEmail,
            decoration: const InputDecoration(
              hintText: 'Digite seu e-mail',
              prefixIcon: Icon(Icons.email_outlined),
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
              onPressed: _carregando ? null : _solicitarResetSenha,
              child: _carregando
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Enviar instruções'),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Voltar ao login'),
            ),
          ),
        ],
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
            Icons.mark_email_read,
            size: 60,
            color: Colors.green.shade600,
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'E-mail enviado!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'Enviamos um código de 6 dígitos para:',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          _emailController.text,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),
        const Text(
          'Verifique sua caixa de entrada e spam.\nO código expira em 15 minutos.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.resetSenha),
            child: const Text('Já tenho o código'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Voltar ao login'),
          ),
        ),
      ],
    );
  }
}
