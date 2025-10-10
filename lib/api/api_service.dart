import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/reserva.dart';
import '../model/recurso.dart';

class ApiService {
  // ========== CONFIGURAÇÃO DE URL ==========
  
  // URL para emulador Android (10.0.2.2 mapeia para localhost da máquina host)
  static const String baseUrl = 'http://10.0.2.2:8080';
  
  // Headers padrão
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
  };
  
  // Timeout para requisições
  static const Duration timeout = Duration(seconds: 10);

  // LOGIN
  static Future<http.Response> login(String email, String senha) async {
    try {
      print('🔗 Tentando conectar em: $baseUrl/auth/login');
      print('📧 Email: $email');
      print('🔑 Headers: $headers');
      
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
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
    try {
      final userId = perfil['usuario']['id'];
      print('🚀 Atualizando perfil do usuário $userId: ${jsonEncode(perfil)}');
      final response = await http.put(
        Uri.parse('$baseUrl/alunos/$userId'),
        headers: headers,
        body: jsonEncode(perfil),
      ).timeout(timeout);
      print('✅ Atualizar perfil - Status: ${response.statusCode}');
      print('📄 Atualizar perfil - Response: ${response.body}');
      return response;
    } catch (e) {
      print('❌ Erro ao atualizar perfil: $e');
      rethrow;
    }
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
    return await http.put(
      Uri.parse('$baseUrl/reservas/$reservaId/confirmar'),
      headers: headers,
    );
  }

  // DELETAR RESERVA
  static Future<http.Response> deletarReserva(int id) async {
    return await http.delete(
      Uri.parse('$baseUrl/reservas/$id'),
      headers: headers,
    );
  }

  // BUSCAR RESERVA POR ID
  static Future<Reserva?> buscarReservaPorId(int id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/reservas/$id'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return Reserva.fromJson(jsonDecode(response.body));
    } else {
      return null;
    }
  }

  // RESERVAS POR RECURSO
  static Future<List<Reserva>> buscarReservasPorRecurso(int recursoId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/reservas/recurso/$recursoId'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> dados = jsonDecode(response.body);
      return dados.map((r) => Reserva.fromJson(r)).toList();
    } else {
      throw Exception('Erro ao buscar reservas do recurso');
    }
  }

  // ESTATÍSTICAS DE RESERVAS
  static Future<int> contarTodasReservas() async {
    final response = await http.get(
      Uri.parse('$baseUrl/reservas/count'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Erro ao contar reservas');
    }
  }

  static Future<int> contarReservasHoje() async {
    final response = await http.get(
      Uri.parse('$baseUrl/reservas/count/today'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Erro ao contar reservas de hoje');
    }
  }

  static Future<int> contarReservasPendentes() async {
    final response = await http.get(
      Uri.parse('$baseUrl/reservas/count/pendentes'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Erro ao contar reservas pendentes');
    }
  }

  static Future<int> contarReservasMarcadas() async {
    final response = await http.get(
      Uri.parse('$baseUrl/reservas/count/marcadas'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Erro ao contar reservas marcadas');
    }
  }

  static Future<int> contarReservasRealizadas() async {
    final response = await http.get(
      Uri.parse('$baseUrl/reservas/count/realizadas'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      return int.parse(response.body);
    } else {
      throw Exception('Erro ao contar reservas realizadas');
    }
  }

  // DEBUG - LISTAR TODAS AS RESERVAS
  static Future<List<Reserva>> debugReservas() async {
    final response = await http.get(
      Uri.parse('$baseUrl/reservas/debug'),
      headers: headers,
    );
    if (response.statusCode == 200) {
      final List<dynamic> dados = jsonDecode(response.body);
      return dados.map((r) => Reserva.fromJson(r)).toList();
    } else {
      throw Exception('Erro no debug de reservas');
    }
  }

  // DEBUG - TESTAR FLUXO COMPLETO
  static Future<void> debugFluxoReserva(Map<String, dynamic> reserva, int idUsuario) async {
    print('🔍 === DEBUG FLUXO RESERVA ===');
    print('👤 ID do usuário logado: $idUsuario');
    print('📤 Dados enviados: ${jsonEncode(reserva)}');
    
    // 1. Enviar reserva
    final envioResponse = await http.post(
      Uri.parse('$baseUrl/reservas'),
      headers: headers,
      body: jsonEncode(reserva),
    );
    print('📥 Resposta envio - Status: ${envioResponse.statusCode}');
    print('📥 Resposta envio - Body: ${envioResponse.body}');
    
    // 2. Aguardar um pouco
    await Future.delayed(Duration(seconds: 2));
    
    // 3. Buscar reservas do usuário
    final buscaResponse = await http.get(
      Uri.parse('$baseUrl/reservas/pessoa/$idUsuario'),
      headers: headers,
    );
    print('🔍 Busca reservas - Status: ${buscaResponse.statusCode}');
    print('🔍 Busca reservas - Body: ${buscaResponse.body}');
    
    // 4. Buscar todas as reservas (debug)
    final todasResponse = await http.get(
      Uri.parse('$baseUrl/reservas/debug'),
      headers: headers,
    );
    print('🔍 Todas reservas - Status: ${todasResponse.statusCode}');
    print('🔍 Todas reservas - Body: ${todasResponse.body}');
    
    // 5. Listar todas as pessoas para verificar IDs
    final pessoasResponse = await http.get(
      Uri.parse('$baseUrl/alunos'),
      headers: headers,
    );
    print('👥 Todas as pessoas - Status: ${pessoasResponse.statusCode}');
    print('👥 Todas as pessoas - Body: ${pessoasResponse.body}');
    
    print('🔍 === FIM DEBUG ===');
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
