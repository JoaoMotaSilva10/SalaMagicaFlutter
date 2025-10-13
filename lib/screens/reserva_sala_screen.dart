import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/recurso.dart';
import '../services/auth_service.dart';
import '../services/reserva_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/modern_button.dart';

class ReservaSalaScreen extends StatefulWidget {
  const ReservaSalaScreen({super.key});

  @override
  State<ReservaSalaScreen> createState() => _ReservaSalaScreenState();
}

class _ReservaSalaScreenState extends State<ReservaSalaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _informacaoController = TextEditingController();
  
  List<Recurso> _salas = [];
  Recurso? _salaSelecionada;
  DateTime? _dataHoraSelecionada;
  bool _carregando = false;
  bool _carregandoSalas = true;

  @override
  void initState() {
    super.initState();
    _carregarSalas();
  }

  @override
  void dispose() {
    _informacaoController.dispose();
    super.dispose();
  }

  Future<void> _carregarSalas() async {
    try {
      final salas = await ReservaService.buscarSalas();
      setState(() {
        _salas = salas;
        _carregandoSalas = false;
      });
    } catch (e) {
      setState(() {
        _carregandoSalas = false;
      });
      _mostrarErro('Erro ao carregar salas: $e');
    }
  }

  Future<void> _selecionarDataHora() async {
    try {
      final data = await showDatePicker(
        context: context,
        initialDate: _dataHoraSelecionada ?? DateTime.now().add(const Duration(days: 1)),
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 365)),
        locale: const Locale('pt', 'BR'),
      );

      if (data != null && mounted) {
        final hora = await showTimePicker(
          context: context,
          initialTime: _dataHoraSelecionada != null 
              ? TimeOfDay.fromDateTime(_dataHoraSelecionada!)
              : const TimeOfDay(hour: 8, minute: 0),
        );

        if (hora != null && mounted) {
          setState(() {
            _dataHoraSelecionada = DateTime(
              data.year,
              data.month,
              data.day,
              hora.hour,
              hora.minute,
            );
          });
        }
      }
    } catch (e) {
      if (mounted) {
        _mostrarErro('Erro ao selecionar data e hora');
      }
    }
  }

  Future<void> _criarReserva() async {
    if (!_formKey.currentState!.validate()) return;
    if (_salaSelecionada == null) {
      _mostrarErro('Selecione uma sala');
      return;
    }
    if (_dataHoraSelecionada == null) {
      _mostrarErro('Selecione data e hora');
      return;
    }

    setState(() => _carregando = true);

    try {
      final usuario = await AuthService.getProfile();
      if (usuario == null) {
        throw Exception('Usuário não logado');
      }

      final disponivel = await ReservaService.verificarDisponibilidade(
        _salaSelecionada!.id,
        _dataHoraSelecionada!,
      );

      if (!disponivel) {
        _mostrarErro('Sala não disponível neste horário');
        return;
      }

      await ReservaService.criarReserva(
        informacao: _informacaoController.text.trim(),
        dataReservada: _dataHoraSelecionada!,
        pessoaId: usuario.id,
        recursoId: _salaSelecionada!.id,
      );

      _mostrarSucesso('Reserva de sala criada com sucesso!');
      Navigator.pop(context, true);
    } catch (e) {
      _mostrarErro('Erro ao criar reserva: $e');
    } finally {
      setState(() => _carregando = false);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Reservar Sala'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selecione a sala',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  if (_carregandoSalas)
                    const Center(child: CircularProgressIndicator())
                  else if (_salas.isEmpty)
                    const Text(
                      'Nenhuma sala disponível',
                      style: TextStyle(color: Colors.white70),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Recurso>(
                          value: _salaSelecionada,
                          hint: const Text(
                            'Selecione uma sala',
                            style: TextStyle(color: Colors.white70),
                          ),
                          dropdownColor: const Color(0xFF2a1810),
                          style: const TextStyle(color: Colors.white),
                          isExpanded: true,
                          items: _salas.map((sala) {
                            return DropdownMenuItem<Recurso>(
                              value: sala,
                              child: Text(sala.nome),
                            );
                          }).toList(),
                          onChanged: (sala) {
                            setState(() => _salaSelecionada = sala);
                          },
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Data e Hora',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  GestureDetector(
                    onTap: _selecionarDataHora,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today, color: Colors.white70),
                          const SizedBox(width: 12),
                          Text(
                            _dataHoraSelecionada != null
                                ? DateFormat('dd/MM/yyyy HH:mm').format(_dataHoraSelecionada!)
                                : 'Selecionar data e hora',
                            style: TextStyle(
                              color: _dataHoraSelecionada != null ? Colors.white : Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  const Text(
                    'Motivo da Reserva',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  TextFormField(
                    controller: _informacaoController,
                    style: const TextStyle(color: Colors.white),
                    maxLines: 3,
                    maxLength: 500,
                    buildCounter: (context, {required currentLength, required isFocused, maxLength}) {
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Ex: Aula de matemática, reunião de projeto...',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xFF6200ea)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe o motivo da reserva';
                      }
                      return null;
                    },
                  ),
                  
                  const Spacer(),
                  
                  ModernButton(
                    text: 'Reservar Sala',
                    onPressed: _carregando ? null : _criarReserva,
                    isLoading: _carregando,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}