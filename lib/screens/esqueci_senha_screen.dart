import 'package:flutter/material.dart';
import '../api/api_service.dart';

class EsqueciSenhaScreen extends StatefulWidget {
  const EsqueciSenhaScreen({super.key});

  @override
  State<EsqueciSenhaScreen> createState() => _EsqueciSenhaScreenState();
}

class _EsqueciSenhaScreenState extends State<EsqueciSenhaScreen> {
  final TextEditingController emailController = TextEditingController();
  String mensagem = "";

  Future<void> solicitarResetSenha() async {
  try {
    final response = await ApiService.esqueciSenha(emailController.text);
    if (response.statusCode == 200) {
      setState(() {
        mensagem = "Se o e-mail existir, enviaremos instruções.";
      });
    } else {
      setState(() {
        mensagem = "Erro ao solicitar redefinição.";
      });
    }
  } catch (e) {
    setState(() {
      mensagem = "Erro de conexão.";
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Esqueci minha senha")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Digite seu e-mail"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: solicitarResetSenha,
              child: const Text("Enviar"),
            ),
            const SizedBox(height: 20),
            Text(mensagem),
          ],
        ),
      ),
    );
  }
}
