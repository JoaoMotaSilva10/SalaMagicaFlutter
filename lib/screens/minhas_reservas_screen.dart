import 'package:flutter/material.dart';

class MinhasReservasScreen extends StatelessWidget {
  const MinhasReservasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Reservas'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue.shade800,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildReservaCard(
            data: '20/05/2024',
            hora: '11:00',
            tipo: 'Sala',
            local: 'Sala 13',
            status: 'Agendada',
            statusColor: Colors.blue,
            podeCancelar: true,
          ),
          SizedBox(height: 16),
          _buildReservaCard(
            data: '19/05/2024',
            hora: '14:30',
            tipo: 'Sala',
            local: 'Sala 19',
            status: 'Realizada',
            statusColor: Colors.green,
            podeCancelar: false,
          ),
          SizedBox(height: 16),
          _buildReservaCard(
            data: '18/05/2024',
            hora: '09:15',
            tipo: 'Datashow',
            local: 'Auditório',
            status: 'Cancelada',
            statusColor: Colors.red,
            podeCancelar: false,
          ),
        ],
      ),
    );
  }

  Widget _buildReservaCard({
    required String data,
    required String hora,
    required String tipo,
    required String local,
    required String status,
    required Color statusColor,
    required bool podeCancelar,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  data,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildInfoRow(Icons.access_time, 'Horário: $hora'),
            _buildInfoRow(Icons.category, 'Tipo: $tipo'),
            _buildInfoRow(Icons.location_on, 'Local: $local'),
            if (podeCancelar)
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.cancel, color: Colors.red.shade700),
                  label: Text(
                    'Cancelar Reserva',
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade600),
          SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}