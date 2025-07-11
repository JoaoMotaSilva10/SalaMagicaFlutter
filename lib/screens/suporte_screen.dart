import 'package:flutter/material.dart';
import '../api/api_service.dart';
import 'analise_screen.dart';
import '../model/usuario.dart';

class SuporteScreen extends StatefulWidget {
  final Usuario usuario;

  const SuporteScreen({super.key, required this.usuario});

  @override
  _SuporteScreenState createState() => _SuporteScreenState();
}

class _SuporteScreenState extends State<SuporteScreen> {
  String? selectedOption;
  final TextEditingController _messageController = TextEditingController();
  bool _loading = false;
  String? _errorMessage;
  String? _successMessage;

  void _enviarMensagem() async {
    setState(() {
      _loading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    if (selectedOption == null || _messageController.text.trim().isEmpty) {
      setState(() {
        _loading = false;
        _errorMessage = 'Por favor, selecione um assunto e digite a mensagem.';
      });
      return;
    }

    final mensagem = {
      'emissor': widget.usuario.nome,
      'email': widget.usuario.email,
      'texto': _messageController.text.trim(),
      'statusMensagem': selectedOption ?? 'outros',
    };

    try {
      final response = await ApiService.enviarMensagemSuporte(mensagem);
      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          _successMessage = 'Mensagem enviada com sucesso!';
        });
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => AnaliseScreen(usuario: widget.usuario),
            ),
          );
        });
      } else {
        setState(() {
          _errorMessage = 'Erro ao enviar mensagem.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Erro de conexão com o servidor.';
      });
    } finally {
      setState(() => _loading = false);
    }
  }

  Widget _buildRadio(String label) {
    return RadioListTile<String>(
      title: Text(label),
      value: label.toLowerCase(),
      groupValue: selectedOption,
      onChanged: (value) => setState(() => selectedOption = value),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Suporte')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Qual é o assunto?', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 10),
              _buildRadio('Equipamentos'),
              _buildRadio('Sala'),
              _buildRadio('Reserva'),
              _buildRadio('Outros'),
              const SizedBox(height: 20),
              TextField(
                controller: _messageController,
                decoration: const InputDecoration(
                  labelText: 'Descreva seu problema',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Text(_errorMessage!,
                    style: const TextStyle(color: Colors.red)),
              if (_successMessage != null)
                Text(_successMessage!,
                    style: const TextStyle(color: Colors.green)),
              const SizedBox(height: 20),
              _loading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _enviarMensagem,
                      child: const Text('Enviar mensagem'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
