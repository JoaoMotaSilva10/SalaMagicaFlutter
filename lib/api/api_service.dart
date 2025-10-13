import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8080';
  static const Duration timeout = Duration(seconds: 10);
  static const Map<String, String> defaultHeaders = {'Content-Type': 'application/json'};

  static Future<http.Response> cadastrarUsuario(Map<String, dynamic> usuario) async {
    try {
      print('🚀 Enviando cadastro para: $baseUrl/alunos');
      print('📄 Dados do usuário: ${jsonEncode(usuario)}');
      
      final response = await http.post(
        Uri.parse('$baseUrl/alunos'),
        headers: defaultHeaders,
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

  static Future<http.Response> login(String email, String senha) async {
    try {
      print('🚀 Tentando login: $baseUrl/auth/login');
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: defaultHeaders,
        body: jsonEncode({
          'email': email,
          'senha': senha,
        }),
      ).timeout(timeout);
      
      print('✅ Login - Status: ${response.statusCode}');
      print('📄 Login - Response: ${response.body}');
      return response;
    } catch (e) {
      print('❌ Erro no login: $e');
      rethrow;
    }
  }

  static Future<http.Response> enviarCodigoRecuperacao(String email) async {
    try {
      print('🚀 Enviando código de recuperação para: $baseUrl/alunos/esqueci-senha');
      final response = await http.post(
        Uri.parse('$baseUrl/alunos/esqueci-senha'),
        headers: defaultHeaders,
        body: jsonEncode({'email': email}),
      ).timeout(timeout);
      
      print('✅ Recuperação - Status: ${response.statusCode}');
      print('📄 Recuperação - Response: ${response.body}');
      return response;
    } catch (e) {
      print('❌ Erro ao enviar código: $e');
      rethrow;
    }
  }

  static Future<http.Response> resetarSenha(String email, String codigo, String novaSenha) async {
    try {
      print('🚀 Resetando senha: $baseUrl/alunos/redefinir-senha');
      final response = await http.post(
        Uri.parse('$baseUrl/alunos/redefinir-senha'),
        headers: defaultHeaders,
        body: jsonEncode({
          'email': email,
          'codigo': codigo,
          'novaSenha': novaSenha,
        }),
      ).timeout(timeout);
      
      print('✅ Reset senha - Status: ${response.statusCode}');
      print('📄 Reset senha - Response: ${response.body}');
      return response;
    } catch (e) {
      print('❌ Erro ao resetar senha: $e');
      rethrow;
    }
  }

  static Future<http.Response> enviarMensagemSuporte(Map<String, dynamic> mensagem) async {
    try {
      print('📤 Enviando mensagem para: $baseUrl/mensagens');
      print('📦 Dados: ${jsonEncode(mensagem)}');
      
      final headers = await AuthService.getAuthHeaders();
      final response = await http.post(
        Uri.parse('$baseUrl/mensagens'),
        headers: headers,
        body: jsonEncode(mensagem),
      ).timeout(timeout);
      
      print('📥 Status Code: ${response.statusCode}');
      print('📥 Resposta: ${response.body}');
      return response;
    } catch (e) {
      print('❌ Erro na requisição: $e');
      rethrow;
    }
  }
}