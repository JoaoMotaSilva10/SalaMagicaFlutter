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
      id: json['id'] as int,
      informacao: json['informacao']?.toString() ?? '',
      dataCadastro: _parseDateTime(json['dataCadastro']),
      dataReservada: _parseDateTime(json['dataReservada']),
      pessoaId: json['pessoaId'] as int?,
      pessoaNome: json['pessoaNome']?.toString(),
      pessoaEmail: json['pessoaEmail']?.toString(),
      pessoaTipo: json['pessoaTipo']?.toString(),
      recurso: json['recurso'] != null
          ? Recurso.fromJson(json['recurso'] as Map<String, dynamic>)
          : Recurso(id: json['recursoId'] as int),
      statusReserva: json['statusReserva']?.toString() ?? 'EM_ANALISE',
    );
  }

  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();
    
    // Se for array [ano, mês, dia, hora, minuto, segundo, nanosegundo]
    if (dateValue is List) {
      final year = dateValue[0] as int;
      final month = dateValue[1] as int;
      final day = dateValue[2] as int;
      final hour = dateValue.length > 3 ? dateValue[3] as int : 0;
      final minute = dateValue.length > 4 ? dateValue[4] as int : 0;
      final second = dateValue.length > 5 ? dateValue[5] as int : 0;
      final millisecond = dateValue.length > 6 ? 
        ((dateValue[6] as int) / 1000000).round() : 0; // Convertendo nanosegundos para milissegundos
      
      return DateTime(year, month, day, hour, minute, second, millisecond);
    }
    
    // Se for string ISO
    if (dateValue is String) {
      return DateTime.parse(dateValue);
    }
    
    return DateTime.now();
  }
}
