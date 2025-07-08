class Recurso {
  final int id;
  final String nome;
  final String descricao;
  final String tipo; // "EQUIPAMENTO" ou "AMBIENTE"
  final String statusRecurso;

  Recurso({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.tipo,
    required this.statusRecurso,
  });

  factory Recurso.fromJson(Map<String, dynamic> json) {
    return Recurso(
      id: json['id'],
      nome: json['nome'],
      descricao: json['descricao'],
      tipo: json['tipo'],
      statusRecurso: json['statusRecurso'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'tipo': tipo,
      'statusRecurso': statusRecurso,
    };
  }
}
