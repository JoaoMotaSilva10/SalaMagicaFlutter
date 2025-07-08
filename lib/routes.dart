import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/cadastro_screen.dart';
import 'screens/perfil_screen.dart';
import 'screens/reserva_equipamento_screen.dart';
import 'screens/reservar_sala_screen.dart';
import 'screens/minhas_reservas_screen.dart';
import 'screens/suporte_screen.dart';
import 'screens/tipo_reserva_screen.dart';
import 'screens/inicio_screen.dart';
import 'screens/analise_screen.dart';
import 'model/usuario.dart';

class AppRoutes {
  static const String login = '/';
  static const String cadastro = '/cadastro';
  static const String inicio = '/inicio';
  static const String perfil = '/perfil';
  static const String reserva = '/reserva';
  static const String reservarEquipamento = '/reserva_equipamento';
  static const String reservarSala = '/reserva_sala';
  static const String minhasReservas = '/minhas_reservas';
  static const String mensagens = '/mensagens';
  static const String analise = '/analise';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginScreen(),
      cadastro: (context) => const CadastroScreen(),
      // As rotas com argumentos devem ser removidas daqui e tratadas no generateRoute
    };
  }

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case inicio:
        return MaterialPageRoute(
          builder: (_) => InicioScreen(usuario: args as Usuario),
        );

      case perfil:
        return MaterialPageRoute(
          builder: (_) => PerfilScreen(usuario: args as Usuario),
        );

      case reserva:
        return MaterialPageRoute(
          builder: (_) => TipoReservaScreen(usuario: args as Usuario),
        );

      case reservarEquipamento:
        return MaterialPageRoute(
          builder: (_) => ReservaEquipamentoScreen(usuario: args as Usuario),
        );

      case reservarSala:
        return MaterialPageRoute(
          builder: (_) => ReservarSalaScreen(usuario: args as Usuario),
        );

      case minhasReservas:
        return MaterialPageRoute(
          builder: (_) => MinhasReservasScreen(usuario: args as Usuario),
        );

      case mensagens:
        return MaterialPageRoute(
          builder: (_) => SuporteScreen(usuario: args as Usuario),
        );

      case analise:
        return MaterialPageRoute(
          builder: (_) => AnaliseScreen(usuario: args as Usuario),
        );
    }

    return null;
  }
}
