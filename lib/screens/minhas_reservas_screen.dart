import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api/api_service.dart';
import '../model/usuario.dart';
import '../model/reserva.dart';
import '../widgets/gradient_background.dart';

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
        backgroundColor: const Color(0xFF1a1a1a),
        elevation: 0,
        title: const Text(
          'Minhas Reservas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      backgroundColor: Colors.transparent,
      body: GradientBackground(
        child: carregando
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF7e3ff2),
                ),
              )
            : erro != null
                ? Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: Text(
                        erro!,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  )
                : reservas.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma reserva encontrada.',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: reservas.length,
                        itemBuilder: (context, index) {
                          final reserva = reservas[index];
                          return _buildReservaCard(reserva);
                        },
                      ),
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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.only(bottom: 16),
      color: Colors.grey.shade900, // fundo escuro moderno
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Data e Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$data · $hora',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.devices_other, 'Tipo: $tipo'),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.location_on, 'Local: $local'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Colors.blue.shade300),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'aceita':
        return Colors.blue;
      case 'realizada':
        return Colors.green;
      case 'recusada':
        return Colors.red;
      case 'em_analise':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}
