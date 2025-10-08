import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/usuario.dart';

class AuthService {
  static const String baseUrl = 'http://localhost:8080';
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
  };

  // Login unificado
  static Future<Map<String, dynamic>> login(String email, String senha) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: headers,
        body: jsonEncode({'email': email, 'senha': senha}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Salvar token se existir
        if (data['token'] != null) {
          await _saveToken(data['token']);
        }
        
        // Salvar dados do usuário
        if (data['usuario'] != null) {
          await _saveUser(data['usuario']);
        }
        
        return data;
      } else {
        throw Exception('Credenciais inválidas');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Buscar perfil do usuário logado
  static Future<Usuario?> getProfile() async {
    final userData = await _getUser();
    if (userData != null) {
      return Usuario.fromJson(userData);
    }
    return null;
  }

  // Logout
  static Future<void> logout() async {
    try {
      // Chamar endpoint de logout no backend
      final token = await _getToken();
      if (token != null) {
        await http.post(
          Uri.parse('$baseUrl/auth/logout'),
          headers: {
            ...headers,
            'Authorization': 'Bearer $token',
          },
        );
      }
    } catch (e) {
      // Ignorar erros de rede no logout
      print('Erro no logout do servidor: $e');
    } finally {
      // Sempre limpar dados locais
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(tokenKey);
      await prefs.remove(userKey);
    }
  }

  // Verificar se está logado
  static Future<bool> isLoggedIn() async {
    final token = await _getToken();
    return token != null;
  }

  // Cadastro de aluno
  static Future<Map<String, dynamic>> cadastrarAluno(Map<String, dynamic> dados) async {
    final response = await http.post(
      Uri.parse('$baseUrl/alunos'),
      headers: headers,
      body: jsonEncode({...dados, 'tipoUsuario': 'ALUNO'}),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao cadastrar: ${response.body}');
    }
  }

  // Atualizar perfil
  static Future<Map<String, dynamic>> atualizarPerfil(int id, Map<String, dynamic> dados) async {
    final token = await _getToken();
    final user = await _getUser();
    
    if (user == null) throw Exception('Usuário não encontrado');
    
    String endpoint;
    switch (user['tipoUsuario']?.toString().toUpperCase()) {
      case 'ALUNO':
        endpoint = '/alunos/$id';
        break;
      case 'GERENCIADOR':
        endpoint = '/gerenciadores/$id';
        break;
      case 'ADMINISTRADOR':
        endpoint = '/administradores/$id';
        break;
      default:
        endpoint = '/alunos/$id';
    }

    // Limpar campos desnecessários
    final dadosLimpos = Map<String, dynamic>.from(dados);
    dadosLimpos.remove('usuario');
    dadosLimpos.remove('id');
    dadosLimpos.remove('dataCadastro');
    
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        ...headers,
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(dadosLimpos),
    );

    if (response.statusCode == 200) {
      final updatedUser = jsonDecode(response.body);
      await _saveUser(updatedUser);
      return updatedUser;
    } else {
      throw Exception('Erro ao atualizar perfil: ${response.body}');
    }
  }

  // Recuperação de senha
  static Future<void> esqueciSenha(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/alunos/esqueci-senha'),
      headers: headers,
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao enviar código: ${response.body}');
    }
  }

  static Future<void> verificarCodigo(String email, String codigo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/alunos/verificar-codigo'),
      headers: headers,
      body: jsonEncode({'email': email, 'codigo': codigo}),
    );

    if (response.statusCode != 200) {
      throw Exception('Código inválido ou expirado');
    }
  }

  static Future<void> redefinirSenha(String email, String codigo, String novaSenha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/alunos/redefinir-senha'),
      headers: headers,
      body: jsonEncode({
        'email': email,
        'codigo': codigo,
        'novaSenha': novaSenha,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Erro ao redefinir senha: ${response.body}');
    }
  }

  // Métodos privados para gerenciar token e usuário
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }

  static Future<void> _saveUser(Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(userKey, jsonEncode(user));
  }

  static Future<Map<String, dynamic>?> _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(userKey);
    if (userString != null) {
      return jsonDecode(userString);
    }
    return null;
  }

  // Obter headers com token
  static Future<Map<String, String>> getAuthHeaders() async {
    final token = await _getToken();
    return {
      ...headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }
}