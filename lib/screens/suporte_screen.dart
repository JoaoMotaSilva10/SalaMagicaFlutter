import 'package:flutter/material.dart';
import 'analise_screen.dart';

class SuporteScreen extends StatefulWidget {
  const SuporteScreen({super.key});

  @override
  _SuporteScreenState createState() => _SuporteScreenState();
}

class _SuporteScreenState extends State<SuporteScreen> {
  String? selectedOption; // Agora só uma seleção direta
  final TextEditingController _messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Suporte')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Qual é o assunto?', style: TextStyle(fontSize: 18)),
            SizedBox(height: 10),
            // Opções diretas como RadioListTile
            RadioListTile<String>(
              title: Text('Equipamentos'),
              value: 'equipamentos',
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
              },
            ),
            RadioListTile<String>(
              title: Text('Sala'),
              value: 'sala',
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
              },
            ),
            RadioListTile<String>(
              title: Text('Reserva'),
              value: 'reserva',
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
              },
            ),
            RadioListTile<String>(
              title: Text('Outros'),
              value: 'outros',
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
              },
            ),
            SizedBox(height: 20),
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Descreva seu problema',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            Text('Resposta será enviada para o email cadastrado no aplicativo.'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnaliseScreen()),
              ),
              child: Text('Enviar mensagem'),
            ),
          ],
        ),
      ),
    );
  }
}