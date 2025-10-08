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
      informacao: json['informacao'] ?? '',
      dataCadastro: _parseDateTime(json['dataCadastro']),
      dataReservada: _parseDateTime(json['dataReservada']),
      pessoaId: json['pessoaId'],
      pessoaNome: json['pessoaNome'],
      pessoaEmail: json['pessoaEmail'],
      pessoaTipo: json['pessoaTipo'],
      recurso: Recurso.fromJson(json['recurso']),
      statusReserva: json['statusReserva'] ?? 'EM_ANALISE',
    );
  }

  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();
    
    // Se for array [ano, mês, dia, hora, minuto, segundo]
    if (dateValue is List && dateValue.length >= 3) {
      final year = dateValue[0] as int;
      final month = dateValue[1] as int;
      final day = dateValue[2] as int;
      final hour = dateValue.length > 3 ? dateValue[3] as int : 0;
      final minute = dateValue.length > 4 ? dateValue[4] as int : 0;
      final second = dateValue.length > 5 ? dateValue[5] as int : 0;
      
      return DateTime(year, month, day, hour, minute, second);
    }
    
    // Se for string ISO
    if (dateValue is String) {
      return DateTime.parse(dateValue);
    }
    
    return DateTime.now();
  }
}
