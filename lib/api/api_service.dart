import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../model/reserva.dart';
import '../model/recurso.dart';

class ApiService {
  // ========== CONFIGURAÇÃO DE URL ==========
  
  // NGROK (Produção/Compartilhamento) - mesma URL do projeto React
  static const String baseUrl = 'https://unarrested-unreverentially-valeria.ngrok-free.dev';
  
  /* LOCALHOST (Desenvolvimento local) - descomente para usar
   static String get baseUrl {
     if (kIsWeb) {
       return 'http://localhost:8080';
     } else if (Platform.isAndroid) {
       return 'http://10.0.2.2:8080';
     } else {
       return 'http://localhost:8080';
     }
  */  // }
  
  // Headers (ngrok precisa do skip-browser-warning)
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'ngrok-skip-browser-warning': 'true', // remova se usar localhost
  };

  // LOGIN
  static Future<http.Response> login(String email, String senha) async {
    return await http.post(
      Uri.parse('$baseUrl/usuarios/login'),
      headers: headers,
      body: jsonEncode({'email': email, 'senha': senha}),
    );
  }

  // PERFIL
  static Future<Map<String, dynamic>?> buscarPerfil(String email) async {
    final response = await http.get(
      Uri.parse('$baseUrl/usuarios/perfil?email=$email'),
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
      Uri.parse('$baseUrl/usuarios/${perfil['id']}'),
      headers: headers,
      body: jsonEncode(perfil),
    );
  }

  // CADASTRO
  static Future<http.Response> cadastrarUsuario(Map<String, dynamic> usuario) async {
    return await http.post(
      Uri.parse('$baseUrl/usuarios'),
      headers: headers,
      body: jsonEncode(usuario),
    );
  }

  static Future<http.Response> enviarReservaSala(
      Map<String, dynamic> reserva) async {
    return await http.post(
      Uri.parse('$baseUrl/reservas'),
      headers: headers,
      body: jsonEncode(reserva),
    );
  }

  static Future<http.Response> enviarReservaEquipamento(
      Map<String, dynamic> reserva) async {
    return await http.post(
      Uri.parse('$baseUrl/reservas'),
      headers: headers,
      body: jsonEncode(reserva),
    );
  }

  static Future<http.Response> enviarMensagemSuporte(
      Map<String, String> mensagem) async {
    return await http.post(
      Uri.parse('$baseUrl/mensagens'),
      headers: headers,
      body: jsonEncode(mensagem),
    );
  }

  static Future<List<Reserva>> buscarReservasPorUsuario(int idUsuario) async {
    final response = await http.get(
      Uri.parse('$baseUrl/reservas/user/$idUsuario'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> dados = jsonDecode(response.body);
      return dados.map((r) => Reserva.fromJson(r)).toList();
    } else {
      throw Exception('Erro ao buscar reservas');
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
      Uri.parse('$baseUrl/usuarios/esqueci-senha'),
      headers: headers,
      body: jsonEncode({'email': email}),
    );
  }

  // REDEFINIR SENHA
  static Future<http.Response> redefinirSenha(String email, String codigo, String novaSenha) async {
    return await http.post(
      Uri.parse('$baseUrl/usuarios/redefinir-senha'),
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
      Uri.parse('$baseUrl/usuarios/verificar-codigo'),
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
