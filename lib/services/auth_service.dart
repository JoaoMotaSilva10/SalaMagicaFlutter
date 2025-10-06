import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/usuario.dart';

class AuthService {
  static const String _userKey = 'usuario_logado';

  static Future<void> salvarUsuario(Usuario usuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(usuario.toJson()));
  }

  static Future<Usuario?> carregarUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    final usuarioSalvo = prefs.getString(_userKey);
    
    if (usuarioSalvo != null) {
      try {
        final userData = jsonDecode(usuarioSalvo);
        return Usuario.fromJson(userData);
      } catch (e) {
        await logout();
        return null;
      }
    }
    return null;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}