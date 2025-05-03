import 'package:flutter/material.dart';
import 'analise_screen.dart';

class SuporteScreen extends StatefulWidget {
  const SuporteScreen({super.key});

  @override
  _SuporteScreenState createState() => _SuporteScreenState();
}

class _SuporteScreenState extends State<SuporteScreen> {
  String? selectedCategory;
  String? selectedSubCategory;
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
            ExpansionTile(
              title: Text('Equipamento'),
              children: [
                ListTile(
                  title: Text('Sala'),
                  leading: Radio(
                    value: 'sala',
                    groupValue: selectedSubCategory,
                    onChanged: (val) => setState(() => selectedSubCategory = val),
                  ),
                ),
                ListTile(
                  title: Text('Reserva'),
                  leading: Radio(
                    value: 'reserva',
                    groupValue: selectedSubCategory,
                    onChanged: (val) => setState(() => selectedSubCategory = val),
                  ),
                ),
                ListTile(
                  title: Text('DataShow'),
                  leading: Radio(
                    value: 'datashow',
                    groupValue: selectedSubCategory,
                    onChanged: (val) => setState(() => selectedSubCategory = val),
                  ),
                ),
              ],
            ),
            ExpansionTile(
              title: Text('Notebook'),
              children: [
                ListTile(
                  title: Text('Outros'),
                  leading: Radio(
                    value: 'outros',
                    groupValue: selectedSubCategory,
                    onChanged: (val) => setState(() => selectedSubCategory = val),
                  ),
                ),
              ],
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
            Text('Resposta será enviada para: rm90319@estudante.fleb.edu.br'),
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