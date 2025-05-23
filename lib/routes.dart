// lib/routes.dart
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/cadastro_screen.dart';
import 'screens/inicio_screen.dart'; // Importação corrigida

class AppRoutes {
  static const String login = '/';
  static const String cadastro = '/cadastro';
  static const String inicio = '/inicio';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginScreen(),
      cadastro: (context) => const CadastroScreen(),
      inicio: (context) => const InicioScreen(), // Referência corrigida
    };
  }

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    return null;
  }
}