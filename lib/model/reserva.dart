import 'recurso.dart';
import 'usuario.dart';

class Reserva {
  final int id;
  final String informacao;
  final DateTime dataReservada;
  final Usuario? pessoa;
  final Recurso recurso;
  final String statusReserva;

  Reserva({
    required this.id,
    required this.informacao,
    required this.dataReservada,
    this.pessoa,
    required this.recurso,
    required this.statusReserva,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: json['id'],
      informacao: json['informacao'],
      dataReservada: DateTime.parse(json['dataReservada']),
      pessoa: json['pessoa'] != null ? Usuario.fromJson(json['pessoa']) : null,
      recurso: Recurso.fromJson(json['recurso']),
      statusReserva: json['statusReserva'],
    );
  }
}
