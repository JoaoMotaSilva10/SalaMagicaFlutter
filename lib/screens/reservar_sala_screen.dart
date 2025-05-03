import 'package:flutter/material.dart';
import 'analise_screen.dart';

class ReservarSalaScreen extends StatefulWidget {
  const ReservarSalaScreen({super.key});

  @override
  _ReservarSalaScreenState createState() => _ReservarSalaScreenState();
}

class _ReservarSalaScreenState extends State<ReservarSalaScreen> {
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reservar Sala')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Qual tipo de sala?', style: TextStyle(fontSize: 18)),
            ListTile(
              title: Text('Auditório'),
              leading: Radio(value: 'auditorio', groupValue: null, onChanged: (val) {}),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Quantas pessoas?',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            Text('Selecione a data:', style: TextStyle(fontSize: 18)),
            // Implementar calendário aqui
            SizedBox(height: 20),
            Text('Horários disponíveis:', style: TextStyle(fontSize: 18)),
            Wrap(
              spacing: 10,
              children: ['10:00','11:00','12:00','13:00','14:00'].map((time) => 
                ChoiceChip(
                  label: Text(time),
                  selected: selectedTime == time,
                  onSelected: (selected) => setState(() => selectedTime = time),
                )).toList(),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnaliseScreen()),
              ),
              child: Text('Reservar Sala'),
            ),
          ],
        ),
      ),
    );
  }
}