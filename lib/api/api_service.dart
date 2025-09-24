import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/usuario.dart';
import '../model/reserva.dart';
import '../model/recurso.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080';

  // LOGIN
  static Future<http.Response> login(String email, String senha) async {
    return await http.post(
      Uri.parse('$baseUrl/usuarios/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );
  }

  // PERFIL
  static Future<Map<String, dynamic>?> buscarPerfil(String email) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/perfil/$email'),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<http.Response> atualizarPerfil(Map<String, dynamic> perfil) async {
    return await http.put(
      Uri.parse('$baseUrl/api/perfil'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(perfil),
    );
  }

  // CADASTRO
  static Future<http.Response> cadastrarUsuario(Map<String, dynamic> usuario) async {
    return await http.post(
      Uri.parse('$baseUrl/usuarios'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(usuario),
    );
  }

  static Future<http.Response> enviarReservaSala(
      Map<String, dynamic> reserva) async {
    return await http.post(
      Uri.parse('$baseUrl/reservas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reserva),
    );
  }

  static Future<http.Response> enviarReservaEquipamento(
      Map<String, dynamic> reserva) async {
    return await http.post(
      Uri.parse('$baseUrl/reservas'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(reserva),
    );
  }

  static Future<http.Response> enviarMensagemSuporte(
      Map<String, String> mensagem) async {
    return await http.post(
      Uri.parse('$baseUrl/mensagens'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(mensagem),
    );
  }

  static Future<List<Reserva>> buscarReservasPorUsuario(int idUsuario) async {
  final response = await http.get(
    Uri.parse('$baseUrl/reservas/user/$idUsuario'),
    headers: {'Content-Type': 'application/json'},
  );
  if (response.statusCode == 200) {
    final List<dynamic> dados = jsonDecode(response.body);
    return dados.map((r) => Reserva.fromJson(r)).toList();
  } else {
    throw Exception('Erro ao buscar reservas');
  }
}


  static Future<List<Recurso>> buscarRecursos({String? tipo}) async {
    final response = await http.get(Uri.parse('$baseUrl/recursos'));
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
      Uri.parse('$baseUrl/usuarios/esqueci-senha?email=$email'),
      headers: {'Content-Type': 'application/json'},
    );
  }

  // REDEFINIR SENHA
  static Future<http.Response> redefinirSenha(String token, String novaSenha) async {
    return await http.post(
      Uri.parse('$baseUrl/usuarios/redefinir-senha?token=$token&novaSenha=$novaSenha'),
      headers: {'Content-Type': 'application/json'},
    );
  }
}
