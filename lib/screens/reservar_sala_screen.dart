import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api/api_service.dart';
import '../model/usuario.dart';
import '../model/recurso.dart';
import '../widgets/gradient_background.dart';

class ReservarSalaScreen extends StatefulWidget {
  final Usuario usuario;

  const ReservarSalaScreen({Key? key, required this.usuario}) : super(key: key);

  @override
  State<ReservarSalaScreen> createState() => _ReservarSalaScreenState();
}

class _ReservarSalaScreenState extends State<ReservarSalaScreen> {
  final _formKey = GlobalKey<FormState>();
  Recurso? _salaSelecionada;
  DateTime? _dataSelecionada;
  TimeOfDay? _horaSelecionada;
  bool _carregando = false;
  List<Recurso> _salas = [];

  @override
  void initState() {
    super.initState();
    _carregarSalas();
  }

  Future<void> _carregarSalas() async {
    try {
      final lista = await ApiService.buscarRecursos(tipo: 'AMBIENTE');
      setState(() => _salas = lista);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar salas')),
      );
    }
  }

  Future<void> _selecionarData() async {
    final DateTime? data = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (data != null) setState(() => _dataSelecionada = data);
  }

  Future<void> _selecionarHora() async {
    final TimeOfDay? hora = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (hora != null) setState(() => _horaSelecionada = hora);
  }

  Future<void> _enviarReserva() async {
    if (!_formKey.currentState!.validate() ||
        _dataSelecionada == null ||
        _horaSelecionada == null) {
      return;
    }

    setState(() => _carregando = true);

    final dataHora = DateTime(
      _dataSelecionada!.year,
      _dataSelecionada!.month,
      _dataSelecionada!.day,
      _horaSelecionada!.hour,
      _horaSelecionada!.minute,
    );

    final reserva = {
      "informacao": "Reserva de ${_salaSelecionada!.nome}",
      "dataReservada": dataHora.toIso8601String(),
      "statusReserva": "EM_ANALISE",
      "pessoaId": widget.usuario.id,
      "recurso": {"id": _salaSelecionada!.id},
    };

    try {
      final response = await ApiService.enviarReservaSala(reserva);
      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Reserva enviada com sucesso')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro: ${response.body}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro de conexão')),
      );
    } finally {
      setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1a1a1a),
        elevation: 0,
        title: const Text(
          'Reservar Sala',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
              DropdownButtonFormField<Recurso>(
                value: _salaSelecionada,
                items: _salas
                    .map(
                      (sala) => DropdownMenuItem(
                        value: sala,
                        child: Text(sala.nome),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setState(() => _salaSelecionada = value),
                validator: (value) =>
                    value == null ? 'Escolha uma sala' : null,
                decoration: const InputDecoration(labelText: 'Sala'),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  _dataSelecionada == null
                      ? 'Selecione a data'
                      : DateFormat('dd/MM/yyyy').format(_dataSelecionada!),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selecionarData,
              ),
              ListTile(
                title: Text(
                  _horaSelecionada == null
                      ? 'Selecione o horário'
                      : _horaSelecionada!.format(context),
                ),
                trailing: const Icon(Icons.access_time),
                onTap: _selecionarHora,
              ),
              const SizedBox(height: 24),
              _carregando
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _enviarReserva,
                      child: const Text('Confirmar Reserva'),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
