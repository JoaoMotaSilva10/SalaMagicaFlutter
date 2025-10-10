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
  String _filtroStatus = 'TODAS';

  @override
  void initState() {
    super.initState();
    _carregarReservas();
  }

  Future<void> _carregarReservas() async {
    setState(() => _carregando = true);
    
    try {
      final reservas = await ReservaService.buscarMinhasReservas();
      setState(() {
        _reservas = reservas;
        _carregando = false;
      });
    } catch (e) {
      setState(() => _carregando = false);
      _mostrarErro('Erro ao carregar reservas: $e');
    }
  }

  List<Reserva> get _reservasFiltradas {
    if (_filtroStatus == 'TODAS') return _reservas;
    return _reservas.where((r) => r.statusReserva == _filtroStatus).toList();
  }

  Future<void> _cancelarReserva(Reserva reserva) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancelar Reserva'),
        content: const Text('Tem certeza que deseja cancelar esta reserva?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Sim'),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      try {
        await ReservaService.cancelarReserva(reserva.id);
        _mostrarSucesso('Reserva cancelada com sucesso');
        _carregarReservas();
      } catch (e) {
        _mostrarErro('Erro ao cancelar reserva: $e');
      }
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

  void _mostrarSucesso(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: Colors.green,
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'EM_ANALISE':
        return Colors.orange;
      case 'ACEITA':
        return Colors.green;
      case 'RECUSADA':
        return Colors.red;
      case 'REALIZADA':
        return Colors.blue;
      case 'CANCELADA':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'EM_ANALISE':
        return 'Em Análise';
      case 'ACEITA':
        return 'Aceita';
      case 'RECUSADA':
        return 'Recusada';
      case 'REALIZADA':
        return 'Realizada';
      case 'CANCELADA':
        return 'Cancelada';
      default:
        return status;
    }
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _carregarReservas,
          ),
        ],
      ),
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Filtros
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _filtroStatus,
                    dropdownColor: const Color(0xFF2a1810),
                    style: const TextStyle(color: Colors.white),
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'TODAS', child: Text('Todas')),
                      DropdownMenuItem(value: 'EM_ANALISE', child: Text('Em Análise')),
                      DropdownMenuItem(value: 'ACEITA', child: Text('Aceitas')),
                      DropdownMenuItem(value: 'RECUSADA', child: Text('Recusadas')),
                      DropdownMenuItem(value: 'REALIZADA', child: Text('Realizadas')),
                      DropdownMenuItem(value: 'CANCELADA', child: Text('Canceladas')),
                    ],
                    onChanged: (value) {
                      setState(() => _filtroStatus = value!);
                    },
                  ),
                ),
              ),
              
              // Lista de reservas
              Expanded(
                child: _carregando
                    ? const Center(child: CircularProgressIndicator())
                    : _reservasFiltradas.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.event_busy,
                                  size: 64,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Nenhuma reserva encontrada',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.7),
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : RefreshIndicator(
                            onRefresh: _carregarReservas,
                            child: ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: _reservasFiltradas.length,
                              itemBuilder: (context, index) {
                                final reserva = _reservasFiltradas[index];
                                return _buildReservaCard(reserva);
                              },
                            ),
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReservaCard(Reserva reserva) {
    final podeCancel = reserva.statusReserva == 'EM_ANALISE' || reserva.statusReserva == 'ACEITA';
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reserva #${reserva.id}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(reserva.statusReserva).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _getStatusColor(reserva.statusReserva)),
                ),
                child: Text(
                  _getStatusText(reserva.statusReserva),
                  style: TextStyle(
                    color: _getStatusColor(reserva.statusReserva),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          Row(
            children: [
              const Icon(Icons.room, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  reserva.recurso.nome,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          Row(
            children: [
              const Icon(Icons.access_time, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              Text(
                DateFormat('dd/MM/yyyy HH:mm').format(reserva.dataReservada),
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          
          if (reserva.informacao.isNotEmpty) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, color: Colors.white70, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    reserva.informacao,
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          
          Row(
            children: [
              const Icon(Icons.calendar_today, color: Colors.white70, size: 20),
              const SizedBox(width: 8),
              Text(
                'Criada em ${DateFormat('dd/MM/yyyy').format(reserva.dataCadastro)}',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
          
          if (podeCancel) ...[
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _cancelarReserva(reserva),
                icon: const Icon(Icons.cancel, color: Colors.red),
                label: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}