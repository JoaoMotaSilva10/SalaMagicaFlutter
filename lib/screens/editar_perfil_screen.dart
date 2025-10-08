import 'package:flutter/material.dart';
import '../services/auth_service_new.dart';
import '../model/usuario.dart';
import '../widgets/gradient_background.dart';
import '../widgets/modern_button.dart';

class EditarPerfilScreen extends StatefulWidget {
  final Usuario usuario;
  final Map<String, dynamic> perfil;

  const EditarPerfilScreen({
    super.key,
    required this.usuario,
    required this.perfil,
  });

  @override
  State<EditarPerfilScreen> createState() => _EditarPerfilScreenState();
}

class _EditarPerfilScreenState extends State<EditarPerfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final _rmController = TextEditingController();
  final _turmaController = TextEditingController();
  final _serieController = TextEditingController();
  final _periodoController = TextEditingController();
  final _cpfController = TextEditingController();

  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _preencherCampos();
  }

  void _preencherCampos() {
    _rmController.text = widget.perfil['rm']?.toString() ?? widget.usuario.rm ?? '';
    _turmaController.text = widget.perfil['turma']?.toString() ?? widget.usuario.turma ?? '';
    _serieController.text = widget.perfil['serie']?.toString() ?? widget.usuario.serie ?? '';
    _periodoController.text = widget.perfil['periodo']?.toString() ?? widget.usuario.periodo ?? '';
    _cpfController.text = widget.perfil['cpf']?.toString() ?? widget.usuario.cpf ?? '';
  }

  Future<void> _salvarPerfil() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _carregando = true);

    final perfilAtualizado = {
      'nome': widget.usuario.nome,
      'email': widget.usuario.email,
      'rm': _rmController.text.trim().isEmpty ? null : _rmController.text.trim(),
      'turma': _turmaController.text.trim().isEmpty ? null : _turmaController.text.trim(),
      'serie': _serieController.text.trim().isEmpty ? null : _serieController.text.trim(),
      'periodo': _periodoController.text.trim().isEmpty ? null : _periodoController.text.trim(),
      'cpf': _cpfController.text.trim().isEmpty ? null : _cpfController.text.trim(),
    };

    try {
      await AuthService.atualizarPerfil(widget.usuario.id, perfilAtualizado);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro: ${e.toString().replaceAll('Exception: ', '')}')),
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
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Colors.white, Color(0xFFa97fff)],
          ).createShader(bounds),
          child: const Text(
            'Editar Perfil',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        centerTitle: true,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6200ea), Color(0xFF7e3ff2)],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Color(0xFF6200ea).withOpacity(0.3),
                blurRadius: 15,
                spreadRadius: 2,
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                _buildTextField('RM', _rmController),
                const SizedBox(height: 16),
                _buildTextField('Turma', _turmaController),
                const SizedBox(height: 16),
                _buildTextField('Série', _serieController),
                const SizedBox(height: 16),
                _buildTextField('Período', _periodoController),
                const SizedBox(height: 16),
                _buildTextField('CPF', _cpfController),
                const SizedBox(height: 32),
                ModernButton(
                  text: _carregando ? 'Salvando...' : 'Salvar Alterações',
                  icon: Icons.save,
                  onPressed: _carregando ? null : _salvarPerfil,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1f1f1f), Color(0xFF2a2a2a)],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF6200ea).withOpacity(0.2),
        ),
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFF7e3ff2)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }
}