import 'recurso.dart';

class Reserva {
  final int id;
  final String informacao;
  final DateTime dataCadastro;
  final DateTime dataReservada;
  final int? pessoaId;
  final String? pessoaNome;
  final String? pessoaEmail;
  final String? pessoaTipo;
  final Recurso recurso;
  final String statusReserva;

  Reserva({
    required this.id,
    required this.informacao,
    required this.dataCadastro,
    required this.dataReservada,
    this.pessoaId,
    this.pessoaNome,
    this.pessoaEmail,
    this.pessoaTipo,
    required this.recurso,
    required this.statusReserva,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: json['id'],
      informacao: json['informacao'],
      dataCadastro: DateTime.parse(json['dataCadastro']),
      dataReservada: DateTime.parse(json['dataReservada']),
      pessoaId: json['pessoaId'],
      pessoaNome: json['pessoaNome'],
      pessoaEmail: json['pessoaEmail'],
      pessoaTipo: json['pessoaTipo'],
      recurso: Recurso.fromJson(json['recurso']),
      statusReserva: json['statusReserva'],
    );
  }
}
