import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/reserva.dart';
import '../services/reserva_service.dart';
import '../widgets/gradient_background.dart';

class MinhasReservasScreen extends StatefulWidget {
  const MinhasReservasScreen({super.key});

  @override
  State<MinhasReservasScreen> createState() => _MinhasReservasScreenState();
}

class _MinhasReservasScreenState extends State<MinhasReservasScreen> {
  List<Reserva> _reservas = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarReservas();
  }

  Future<void> _carregarReservas() async {
    try {
      final reservas = await ReservaService.buscarMinhasReservas();
      setState(() {
        _reservas = reservas;
        _carregando = false;
      });
    } catch (e) {
      setState(() {
        _carregando = false;
      });
      _mostrarErro('Erro ao carregar reservas: $e');
    }
  }

  void _mostrarErro(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color cor;
    String texto;
    IconData icone;

    switch (status) {
      case 'EM_ANALISE':
        cor = Colors.orange;
        texto = 'Em Análise';
        icone = Icons.hourglass_empty;
        break;
      case 'ACEITA':
        cor = Colors.green;
        texto = 'Aceita';
        icone = Icons.check_circle;
        break;
      case 'RECUSADA':
        cor = Colors.red;
        texto = 'Recusada';
        icone = Icons.cancel;
        break;
      case 'CANCELADA':
        cor = Colors.grey;
        texto = 'Cancelada';
        icone = Icons.block;
        break;
      case 'REALIZADA':
        cor = Colors.blue;
        texto = 'Realizada';
        icone = Icons.done_all;
        break;
      default:
        cor = Colors.grey;
        texto = status;
        icone = Icons.help;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cor.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icone, color: cor, size: 14),
          const SizedBox(width: 4),
          Text(
            texto,
            style: TextStyle(
              color: cor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Minhas Reservas'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: GradientBackground(
        child: SafeArea(
          child: _carregando
              ? const Center(child: CircularProgressIndicator())
              : _reservas.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhuma reserva encontrada',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: _reservas.length,
                      itemBuilder: (context, index) {
                        final reserva = _reservas[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          color: Colors.white.withOpacity(0.1),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        reserva.recurso.nome,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    _buildStatusChip(reserva.statusReserva),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateFormat('dd/MM/yyyy HH:mm').format(reserva.dataReservada),
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      reserva.recurso.tipo == 'AMBIENTE' ? Icons.room : Icons.devices,
                                      color: Colors.white70,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      reserva.recurso.tipo == 'AMBIENTE' ? 'Sala' : 'Equipamento',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                if (reserva.informacao.isNotEmpty) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    reserva.informacao,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}