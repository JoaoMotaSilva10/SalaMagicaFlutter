import 'package:flutter/material.dart';

class MinhasReservasScreen extends StatelessWidget {
  const MinhasReservasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Minhas Reservas')),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Data: 20/05/2024', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Hora: 11:00'),
                  Text('Tipo: Sala'),
                  Text('Local: Sala 13'),
                  Row(
                    children: [
                      Text('Status: '),
                      Chip(
                        label: Text('Agendada', style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.blue,
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text('Desmarcar reserva', style: TextStyle(color: Colors.red)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Data: 19/05/2024', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Hora: 14:30'),
                  Text('Tipo: Sala'),
                  Text('Local: Sala 19'),
                  Row(
                    children: [
                      Text('Status: '),
                      Chip(
                        label: Text('Realizada', style: TextStyle(color: Colors.white)),
                        backgroundColor: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}