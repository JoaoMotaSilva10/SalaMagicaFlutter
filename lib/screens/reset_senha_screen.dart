import 'package:flutter/material.dart';
import '../api/api_service.dart';

class ResetSenhaScreen extends StatefulWidget {
  const ResetSenhaScreen({super.key});

  @override
  State<ResetSenhaScreen> createState() => _ResetSenhaScreenState();
}

class _ResetSenhaScreenState extends State<ResetSenhaScreen> {
  final TextEditingController tokenController = TextEditingController();
  final TextEditingController senhaController = TextEditingController();
  String mensagem = "";

  Future<void> redefinirSenha() async {
  try {
    final response = await ApiService.redefinirSenha(tokenController.text, senhaController.text);
    if (response.statusCode == 200) {
      setState(() {
        mensagem = "Senha redefinida com sucesso!";
      });
    } else {
      setState(() {
        mensagem = "Erro ao redefinir senha.";
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
      appBar: AppBar(title: const Text("Redefinir Senha")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: tokenController,
              decoration: const InputDecoration(labelText: "Token recebido"),
            ),
            TextField(
              controller: senhaController,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Nova senha"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: redefinirSenha,
              child: const Text("Alterar senha"),
            ),
            const SizedBox(height: 20),
            Text(mensagem),
          ],
        ),
      ),
    );
  }
}
