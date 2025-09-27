import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/reserva.dart';
import '../model/recurso.dart';

class ApiService {
  // ========== CONFIGURAÇÃO DE URL ==========
  
  // URL do ngrok
  static const String baseUrl = 'https://unarrested-unreverentially-valeria.ngrok-free.dev';
  
  // Headers (ngrok precisa do skip-browser-warning)
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'ngrok-skip-browser-warning': 'true',
  };
  
  // Timeout para requisições
  static const Duration timeout = Duration(seconds: 10);

  // LOGIN
  static Future<http.Response> login(String email, String senha) async {
    try {
      print('🔗 Tentando conectar em: $baseUrl/alunos/login');
      print('📧 Email: $email');
      print('🔑 Headers: $headers');
      
      final response = await http.post(
        Uri.parse('$baseUrl/alunos/login'),
        headers: headers,
        body: jsonEncode({'email': email, 'senha': senha}),
      ).timeout(timeout);
      
      print('✅ Status: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');
      print('📄 Response Headers: ${response.headers}');
      
      // Verificar se a resposta é válida
      if (response.body.isEmpty) {
        print('⚠️ Response body está vazio!');
      }
      
      return response;
    } catch (e) {
      print('❌ Erro: $e');
      if (e.toString().contains('SocketException') || e.toString().contains('TimeoutException')) {
        throw Exception('Erro de conexão: Verifique se o servidor está rodando');
      }
      rethrow;
    }
  }

  // PERFIL
  static Future<Map<String, dynamic>?> buscarPerfil(String email) async {
    final response = await http.get(
      Uri.parse('$baseUrl/alunos/perfil?email=$email'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<http.Response> atualizarPerfil(Map<String, dynamic> perfil) async {
    return await http.put(
      Uri.parse('$baseUrl/alunos/${perfil['id']}'),
      headers: headers,
      body: jsonEncode(perfil),
    );
  }

  // CADASTRO
  static Future<http.Response> cadastrarUsuario(Map<String, dynamic> usuario) async {
    try {
      print('🚀 Cadastrando usuário em: $baseUrl/alunos');
      print('📄 Dados: ${jsonEncode(usuario)}');
      print('🔑 Headers: $headers');
      
      final response = await http.post(
        Uri.parse('$baseUrl/alunos'),
        headers: headers,
        body: jsonEncode(usuario),
      ).timeout(timeout);
      
      print('✅ Cadastro - Status: ${response.statusCode}');
      print('📄 Cadastro - Response: ${response.body}');
      return response;
    } catch (e) {
      print('❌ Erro no cadastro: $e');
      rethrow;
    }
  }

  static Future<http.Response> enviarReservaSala(
      Map<String, dynamic> reserva) async {
    try {
      print('🚀 Enviando reserva de sala: ${jsonEncode(reserva)}');
      final response = await http.post(
        Uri.parse('$baseUrl/reservas'),
        headers: headers,
        body: jsonEncode(reserva),
      ).timeout(timeout);
      print('✅ Reserva sala - Status: ${response.statusCode}');
      print('📄 Reserva sala - Response: ${response.body}');
      return response;
    } catch (e) {
      print('❌ Erro ao enviar reserva de sala: $e');
      rethrow;
    }
  }

  static Future<http.Response> enviarReservaEquipamento(
      Map<String, dynamic> reserva) async {
    try {
      print('🚀 Enviando reserva de equipamento: ${jsonEncode(reserva)}');
      final response = await http.post(
        Uri.parse('$baseUrl/reservas'),
        headers: headers,
        body: jsonEncode(reserva),
      ).timeout(timeout);
      print('✅ Reserva equipamento - Status: ${response.statusCode}');
      print('📄 Reserva equipamento - Response: ${response.body}');
      return response;
    } catch (e) {
      print('❌ Erro ao enviar reserva de equipamento: $e');
      rethrow;
    }
  }

  static Future<http.Response> enviarMensagemSuporte(
      Map<String, dynamic> mensagem) async {
    try {
      print('🚀 Enviando mensagem de suporte: ${jsonEncode(mensagem)}');
      final response = await http.post(
        Uri.parse('$baseUrl/mensagens'),
        headers: headers,
        body: jsonEncode(mensagem),
      ).timeout(timeout);
      print('✅ Mensagem suporte - Status: ${response.statusCode}');
      print('📄 Mensagem suporte - Response: ${response.body}');
      return response;
    } catch (e) {
      print('❌ Erro ao enviar mensagem de suporte: $e');
      rethrow;
    }
  }

  static Future<List<Reserva>> buscarReservasPorUsuario(int idUsuario) async {
    try {
      print('🚀 Buscando reservas em: $baseUrl/reservas/pessoa/$idUsuario');
      final response = await http.get(
        Uri.parse('$baseUrl/reservas/pessoa/$idUsuario'),
        headers: headers,
      ).timeout(timeout);
      
      print('✅ Status reservas: ${response.statusCode}');
      print('📄 Response reservas: ${response.body}');
      
      if (response.statusCode == 200) {
        final List<dynamic> dados = jsonDecode(response.body);
        print('📄 ${dados.length} reservas encontradas');
        return dados.map((r) => Reserva.fromJson(r)).toList();
      } else if (response.statusCode == 404) {
        print('📄 Nenhuma reserva encontrada para o usuário');
        return [];
      } else {
        throw Exception('Erro no servidor: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erro ao buscar reservas: $e');
      rethrow;
    }
  }


  static Future<List<Recurso>> buscarRecursos({String? tipo}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/recursos'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final recursos = data.map((r) => Recurso.fromJson(r)).toList();
      if (tipo != null) {
        return recursos.where((r) => r.tipo == tipo).toList();
      }
      return recursos;
    } else {
      throw Exception('Erro ao buscar recursos');
    }
  }
  
  // ESQUECI A SENHA
  static Future<http.Response> esqueciSenha(String email) async {
    return await http.post(
      Uri.parse('$baseUrl/alunos/esqueci-senha'),
      headers: headers,
      body: jsonEncode({'email': email}),
    );
  }

  // REDEFINIR SENHA
  static Future<http.Response> redefinirSenha(String email, String codigo, String novaSenha) async {
    return await http.post(
      Uri.parse('$baseUrl/alunos/redefinir-senha'),
      headers: headers,
      body: jsonEncode({
        'email': email,
        'codigo': codigo,
        'novaSenha': novaSenha,
      }),
    );
  }

  // VERIFICAR CÓDIGO
  static Future<http.Response> verificarCodigo(String email, String codigo) async {
    return await http.post(
      Uri.parse('$baseUrl/alunos/verificar-codigo'),
      headers: headers,
      body: jsonEncode({
        'email': email,
        'codigo': codigo,
      }),
    );
  }

  // TODAS AS RESERVAS (para admin)
  static Future<List<Reserva>> buscarTodasReservas() async {
    final response = await http.get(
      Uri.parse('$baseUrl/reservas'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> dados = jsonDecode(response.body);
      return dados.map((r) => Reserva.fromJson(r)).toList();
    } else {
      throw Exception('Erro ao buscar reservas');
    }
  }

  // ATUALIZAR RESERVA
  static Future<http.Response> atualizarReserva(int id, Map<String, dynamic> reserva) async {
    return await http.put(
      Uri.parse('$baseUrl/reservas/$id'),
      headers: headers,
      body: jsonEncode(reserva),
    );
  }

  // CONFIRMAR REALIZAÇÃO DA RESERVA
  static Future<http.Response> confirmarRealizacao(int reservaId) async {
    return await atualizarReserva(reservaId, {'statusReserva': 'REALIZADA'});
  }

  // BUSCAR MENSAGENS
  static Future<List<Map<String, dynamic>>> buscarMensagens() async {
    final response = await http.get(
      Uri.parse('$baseUrl/mensagens'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Erro ao buscar mensagens');
    }
  }
}
