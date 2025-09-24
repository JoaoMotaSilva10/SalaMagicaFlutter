import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../routes.dart';
import '../widgets/gradient_background.dart';

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
                  child: _emailEnviado ? _buildSucessoWidget() : _buildFormulario(),
                ),
              ),
            ),
          ),
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
                    'Recuperar senha',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Digite seu e-mail e enviaremos instruções para redefinir sua senha.',
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
            'E-mail',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: _validarEmail,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              hintText: 'Digite seu e-mail',
              prefixIcon: Icon(Icons.email_outlined, color: Color(0xFF7e3ff2)),
            ),
          ),
          const SizedBox(height: 24),
          if (_erro != null)
            Container(
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
          if (_erro != null) const SizedBox(height: 16),
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
              onPressed: _carregando ? null : _solicitarResetSenha,
              child: _carregando
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      'Enviar instruções',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Voltar ao login',
                style: TextStyle(
                  color: Color(0xFF7e3ff2),
                  fontWeight: FontWeight.bold,
                ),
              ),
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
            gradient: const LinearGradient(
              colors: [Color(0xFF6200ea), Color(0xFF7e3ff2)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6200ea).withOpacity(0.4),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
          child: const Icon(
            Icons.mark_email_read,
            size: 60,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 24),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Color(0xFFa97fff)],
          ).createShader(bounds),
          child: const Text(
            'E-mail enviado!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Enviamos um código de 6 dígitos para:',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white.withOpacity(0.8)),
        ),
        const SizedBox(height: 8),
        Text(
          _emailController.text,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'Verifique sua caixa de entrada e spam.\nO código expira em 15 minutos.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white.withOpacity(0.7)),
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
            onPressed: () => Navigator.pushNamed(context, AppRoutes.resetSenha),
            child: const Text(
              'Já tenho o código',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            'Voltar ao login',
            style: TextStyle(
              color: Color(0xFF7e3ff2),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
