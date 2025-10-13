import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/cadastro_screen.dart';
import 'screens/perfil_screen.dart';
import 'screens/editar_perfil_screen.dart';
import 'screens/minhas_reservas_screen.dart';
import 'screens/reserva_screen.dart';
import 'screens/reserva_sala_screen.dart';
import 'screens/reserva_equipamento_screen.dart';
import 'screens/suporte_screen.dart';
import 'screens/inicio_screen.dart';
import 'screens/analise_screen.dart';
import 'screens/esqueci_senha_screen.dart';
import 'screens/reset_senha_screen.dart';
import 'screens/mensagem_enviada_screen.dart';
import 'model/usuario.dart';

class AppRoutes {
  static const String login = '/';
  static const String cadastro = '/cadastro';
  static const String inicio = '/inicio';
  static const String perfil = '/perfil';
  static const String editarPerfil = '/editar_perfil';
  static const String reserva = '/reserva';
  static const String reservaSala = '/reserva_sala';
  static const String reservaEquipamento = '/reserva_equipamento';
  static const String minhasReservas = '/minhas_reservas';
  static const String mensagens = '/mensagens';
  static const String analise = '/analise';
  static const String esqueciSenha = '/esqueci_senha';
  static const String resetSenha = '/reset_senha';
  static const String mensagemEnviada = '/mensagem_enviada';

  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginScreen(),
      cadastro: (context) => const CadastroScreen(),
      esqueciSenha: (context) => const EsqueciSenhaScreen(),
      resetSenha: (context) => const ResetSenhaScreen(),
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

      case editarPerfil:
        final arguments = args as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => EditarPerfilScreen(
            usuario: arguments['usuario'] as Usuario,
            perfil: arguments['perfil'] as Map<String, dynamic>,
          ),
        );

      case reserva:
        final tipoReserva = args as String;
        return MaterialPageRoute(
          builder: (_) => NovaReservaScreen(tipoReserva: tipoReserva),
        );

      case reservaSala:
        return MaterialPageRoute(
          builder: (_) => const ReservaSalaScreen(),
        );

      case reservaEquipamento:
        return MaterialPageRoute(
          builder: (_) => const ReservaEquipamentoScreen(),
        );

      case minhasReservas:
        return MaterialPageRoute(
          builder: (_) => const MinhasReservasScreen(),
        );

      case mensagens:
        return MaterialPageRoute(
          builder: (_) => SuporteScreen(usuario: args as Usuario),
        );

      case analise:
        return MaterialPageRoute(
          builder: (_) => AnaliseScreen(usuario: args as Usuario),
        );

      case mensagemEnviada:
        return MaterialPageRoute(
          builder: (_) => MensagemEnviadaScreen(usuario: args as Usuario),
        );
    }

    return null;
  }
}