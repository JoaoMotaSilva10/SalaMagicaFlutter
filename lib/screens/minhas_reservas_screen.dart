import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api/api_service.dart';
import '../model/usuario.dart';
import '../model/reserva.dart';

class MinhasReservasScreen extends StatefulWidget {
  final Usuario usuario;

  const MinhasReservasScreen({super.key, required this.usuario});

  @override
  State<MinhasReservasScreen> createState() => _MinhasReservasScreenState();
}

class _MinhasReservasScreenState extends State<MinhasReservasScreen> {
  List<Reserva> reservas = [];
  bool carregando = true;
  String? erro;

  @override
  void initState() {
    super.initState();
    _carregarReservas();
  }

  Future<void> _carregarReservas() async {
    setState(() {
      carregando = true;
      erro = null;
    });

    try {
      final lista = await ApiService.buscarReservasPorUsuario(
        widget.usuario.id,
      );
      setState(() {
        reservas = lista;
      });
    } catch (e) {
      setState(() => erro = 'Erro ao carregar reservas.');
    } finally {
      setState(() => carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Reservas'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade800,
      ),
      body:
          carregando
              ? const Center(child: CircularProgressIndicator())
              : erro != null
              ? Center(
                child: Text(erro!, style: const TextStyle(color: Colors.red)),
              )
              : reservas.isEmpty
              ? const Center(child: Text('Nenhuma reserva encontrada.'))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: reservas.length,
                itemBuilder: (context, index) {
                  final reserva = reservas[index];
                  return _buildReservaCard(reserva);
                },
              ),
    );
  }

  Widget _buildReservaCard(Reserva reserva) {
  final status = reserva.statusReserva;
  final statusColor = _getStatusColor(status);

  final data = DateFormat('dd/MM/yyyy').format(reserva.dataReservada);
  final hora = DateFormat('HH:mm').format(reserva.dataReservada);
  final tipo = reserva.recurso.tipo;
  final local = reserva.recurso.descricao;

  return Card(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    margin: const EdgeInsets.only(bottom: 16),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data, // ✅ corrigido aqui
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade800,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
          const SizedBox(height: 12),
          _buildInfoRow(Icons.access_time, 'Horário: $hora'), // ✅ corrigido aqui
          _buildInfoRow(Icons.category, 'Tipo: $tipo'),
          _buildInfoRow(Icons.location_on, 'Descrição: $local'),
        ],
      ),
    ),
  );
}


  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.blue.shade600),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'agendada':
        return Colors.blue;
      case 'realizada':
        return Colors.green;
      case 'cancelada':
        return Colors.red;
      case 'em_analise':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
