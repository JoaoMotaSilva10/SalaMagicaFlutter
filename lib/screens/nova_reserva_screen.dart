import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/recurso.dart';
import '../services/auth_service_new.dart';
import '../services/reserva_service.dart';
import '../widgets/gradient_background.dart';
import '../widgets/modern_button.dart';

class NovaReservaScreen extends StatefulWidget {
  final String tipoReserva; // 'AMBIENTE' ou 'EQUIPAMENTO'

  const NovaReservaScreen({
    super.key,
    required this.tipoReserva,
  });

  @override
  State<NovaReservaScreen> createState() => _NovaReservaScreenState();
}

class _NovaReservaScreenState extends State<NovaReservaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _informacaoController = TextEditingController();
  
  List<Recurso> _recursos = [];
  Recurso? _recursoSelecionado;
  DateTime? _dataHoraSelecionada;
  bool _carregando = false;
  bool _carregandoRecursos = true;

  @override
  void initState() {
    super.initState();
    _carregarRecursos();
  }

  Future<void> _carregarRecursos() async {
    try {
      final recursos = await ReservaService.buscarRecursos(tipo: widget.tipoReserva);
      setState(() {
        _recursos = recursos;
        _carregandoRecursos = false;
      });
    } catch (e) {
      setState(() {
        _carregandoRecursos = false;
      });
      _mostrarErro('Erro ao carregar recursos: $e');
    }
  }

  Future<void> _selecionarDataHora() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      locale: const Locale('pt', 'BR'),
    );

    if (data != null) {
      final hora = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: 8, minute: 0),
      );

      if (hora != null) {
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
  }

  Future<void> _criarReserva() async {
    if (!_formKey.currentState!.validate()) return;
    if (_recursoSelecionado == null) {
      _mostrarErro('Selecione um recurso');
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

      // Verificar disponibilidade
      final disponivel = await ReservaService.verificarDisponibilidade(
        _recursoSelecionado!.id,
        _dataHoraSelecionada!,
      );

      if (!disponivel) {
        _mostrarErro('Recurso não disponível neste horário');
        return;
      }

      await ReservaService.criarReserva(
        informacao: _informacaoController.text.trim(),
        dataReservada: _dataHoraSelecionada!,
        pessoaId: usuario.id,
        recursoId: _recursoSelecionado!.id,
      );

      _mostrarSucesso('Reserva criada com sucesso!');
      Navigator.pop(context, true); // Retorna true para indicar sucesso
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
    final titulo = widget.tipoReserva == 'AMBIENTE' ? 'Reservar Sala' : 'Reservar Equipamento';
    
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(titulo),
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
                  Text(
                    'Selecione o ${widget.tipoReserva == 'AMBIENTE' ? 'ambiente' : 'equipamento'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  if (_carregandoRecursos)
                    const Center(child: CircularProgressIndicator())
                  else if (_recursos.isEmpty)
                    const Text(
                      'Nenhum recurso disponível',
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
                          value: _recursoSelecionado,
                          hint: const Text(
                            'Selecione um recurso',
                            style: TextStyle(color: Colors.white70),
                          ),
                          dropdownColor: const Color(0xFF2a1810),
                          style: const TextStyle(color: Colors.white),
                          isExpanded: true,
                          items: _recursos.map((recurso) {
                            return DropdownMenuItem<Recurso>(
                              value: recurso,
                              child: Text(recurso.nome),
                            );
                          }).toList(),
                          onChanged: (recurso) {
                            setState(() => _recursoSelecionado = recurso);
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
                    'Informações Adicionais',
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
                    decoration: InputDecoration(
                      hintText: 'Descreva o motivo da reserva...',
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
                    text: 'Criar Reserva',
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

  @override
  void dispose() {
    _informacaoController.dispose();
    super.dispose();
  }
}