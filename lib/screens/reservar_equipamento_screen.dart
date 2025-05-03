import 'package:flutter/material.dart';
import 'analise_screen.dart';

class ReservarEquipamentoScreen extends StatefulWidget {
  const ReservarEquipamentoScreen({super.key});

  @override
  _ReservarEquipamentoScreenState createState() => _ReservarEquipamentoScreenState();
}

class _ReservarEquipamentoScreenState extends State<ReservarEquipamentoScreen> {
  int quantidade = 1;
  String? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reservar Equipamento')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Qual equipamento?', style: TextStyle(fontSize: 18)),
            ListTile(
              title: Text('Computador de informática'),
              leading: Checkbox(value: true, onChanged: (val) {}),
            ),
            SizedBox(height: 15),
            Text('Quantidade:', style: TextStyle(fontSize: 16)),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () => setState(() => quantidade = quantidade > 1 ? quantidade - 1 : 1),
                ),
                Text('$quantidade'),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () => setState(() => quantidade++),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Selecione a data:', style: TextStyle(fontSize: 18)),
            // Implementar calendário aqui
            SizedBox(height: 20),
            Text('Horários disponíveis:', style: TextStyle(fontSize: 18)),
            Wrap(
              spacing: 10,
              children: ['10:30','11:30','12:30'].map((time) => 
                ChoiceChip(
                  label: Text(time),
                  selected: selectedTime == time,
                  onSelected: (selected) => setState(() => selectedTime = time),
                  backgroundColor: time == '10:30' ? Colors.grey[300] : null,
                  labelStyle: TextStyle(
                    color: time == '10:30' ? Colors.grey : null,
                  ),
                )).toList(),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnaliseScreen()),
              ),
              child: Text('Reservar Equipamento'),
            ),
          ],
        ),
      ),
    );
  }
}