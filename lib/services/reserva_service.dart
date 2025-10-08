import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/reserva.dart';
import '../model/recurso.dart';
import 'auth_service_new.dart';

class ReservaService {
  static const String baseUrl = 'http://localhost:8080';

  // Criar nova reserva
  static Future<Reserva> criarReserva({
    required String informacao,
    required DateTime dataReservada,
    required int pessoaId,
    required int recursoId,
  }) async {
    final headers = await AuthService.getAuthHeaders();
    
    final reservaData = {
      'informacao': informacao,
      'dataReservada': dataReservada.toIso8601String(),
      'pessoaId': pessoaId,
      'recurso': {'id': recursoId},
      'statusReserva': 'EM_ANALISE',
    };

    final response = await http.post(
      Uri.parse('$baseUrl/reservas'),
      headers: headers,
      body: jsonEncode(reservaData),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Reserva.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao criar reserva: ${response.body}');
    }
  }

  // Buscar reservas do usuário logado
  static Future<List<Reserva>> buscarMinhasReservas() async {
    final user = await AuthService.getProfile();
    if (user == null) throw Exception('Usuário não logado');

    final headers = await AuthService.getAuthHeaders();
    
    final response = await http.get(
      Uri.parse('$baseUrl/reservas/pessoa/${user.id}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((r) => Reserva.fromJson(r)).toList();
    } else if (response.statusCode == 404) {
      return []; // Nenhuma reserva encontrada
    } else {
      throw Exception('Erro ao buscar reservas: ${response.body}');
    }
  }

  // Buscar todas as reservas (para gerenciadores/admins)
  static Future<List<Reserva>> buscarTodasReservas() async {
    final headers = await AuthService.getAuthHeaders();
    
    final response = await http.get(
      Uri.parse('$baseUrl/reservas'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((r) => Reserva.fromJson(r)).toList();
    } else {
      throw Exception('Erro ao buscar reservas: ${response.body}');
    }
  }

  // Atualizar status da reserva
  static Future<Reserva> atualizarStatusReserva(int reservaId, String novoStatus) async {
    final headers = await AuthService.getAuthHeaders();
    
    final response = await http.put(
      Uri.parse('$baseUrl/reservas/$reservaId'),
      headers: headers,
      body: jsonEncode({'statusReserva': novoStatus}),
    );

    if (response.statusCode == 200) {
      return Reserva.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao atualizar reserva: ${response.body}');
    }
  }

  // Confirmar realização da reserva
  static Future<void> confirmarRealizacao(int reservaId) async {
    final headers = await AuthService.getAuthHeaders();
    
    final response = await http.put(
      Uri.parse('$baseUrl/reservas/$reservaId/confirmar'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao confirmar realização: ${response.body}');
    }
  }

  // Cancelar reserva
  static Future<void> cancelarReserva(int reservaId) async {
    final headers = await AuthService.getAuthHeaders();
    
    final response = await http.delete(
      Uri.parse('$baseUrl/reservas/$reservaId'),
      headers: headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception('Erro ao cancelar reserva: ${response.body}');
    }
  }

  // Buscar recursos disponíveis
  static Future<List<Recurso>> buscarRecursos({String? tipo}) async {
    final headers = await AuthService.getAuthHeaders();
    
    final response = await http.get(
      Uri.parse('$baseUrl/recursos'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final recursos = data.map((r) => Recurso.fromJson(r)).toList();
      
      if (tipo != null) {
        return recursos.where((r) => r.tipo.toUpperCase() == tipo.toUpperCase()).toList();
      }
      
      return recursos;
    } else {
      throw Exception('Erro ao buscar recursos: ${response.body}');
    }
  }

  // Buscar salas (ambientes)
  static Future<List<Recurso>> buscarSalas() async {
    return await buscarRecursos(tipo: 'AMBIENTE');
  }

  // Buscar equipamentos
  static Future<List<Recurso>> buscarEquipamentos() async {
    return await buscarRecursos(tipo: 'EQUIPAMENTO');
  }

  // Verificar disponibilidade de recurso
  static Future<bool> verificarDisponibilidade(int recursoId, DateTime dataHora) async {
    final headers = await AuthService.getAuthHeaders();
    
    final response = await http.get(
      Uri.parse('$baseUrl/reservas/recurso/$recursoId'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final reservas = data.map((r) => Reserva.fromJson(r)).toList();
      
      // Verificar se há conflito de horário
      for (final reserva in reservas) {
        if (reserva.statusReserva == 'ACEITA' || reserva.statusReserva == 'EM_ANALISE') {
          final inicio = reserva.dataReservada;
          final fim = inicio.add(Duration(hours: 2)); // Assumindo 2h de duração
          
          if (dataHora.isAfter(inicio) && dataHora.isBefore(fim)) {
            return false; // Conflito encontrado
          }
        }
      }
      
      return true; // Disponível
    } else {
      return true; // Em caso de erro, assume disponível
    }
  }
}