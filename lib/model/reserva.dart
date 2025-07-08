import 'recurso.dart';
import 'usuario.dart';

class Reserva {
  final int id;
  final String informacao;
  final DateTime dataCadastro;
  final DateTime dataReservada;
  final Usuario usuario;
  final Recurso recurso;
  final String statusReserva;

  Reserva({
    required this.id,
    required this.informacao,
    required this.dataCadastro,
    required this.dataReservada,
    required this.usuario,
    required this.recurso,
    required this.statusReserva,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: json['id'],
      informacao: json['informacao'],
      dataCadastro: DateTime.parse(json['dataCadastro']),
      dataReservada: DateTime.parse(json['dataReservada']),
      usuario: Usuario.fromJson(json['usuario']),
      recurso: Recurso.fromJson(json['recurso']),
      statusReserva: json['statusReserva'],
    );
  }
}
