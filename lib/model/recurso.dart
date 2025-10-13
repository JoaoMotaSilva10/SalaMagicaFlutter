class Recurso {
  final int id;
  final String nome;
  final String descricao;
  final String tipo; // "EQUIPAMENTO" ou "AMBIENTE"
  final String statusRecurso;
  
  const Recurso({
    required this.id,
    this.nome = '',
    this.descricao = '',
    this.tipo = '',
    this.statusRecurso = 'ATIVO',
  });

  factory Recurso.fromJson(Map<String, dynamic> json) {
    return Recurso(
      id: json['id'] as int,
      nome: json['nome']?.toString() ?? '',
      descricao: json['descricao']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? '',
      statusRecurso: json['statusRecurso']?.toString() ?? 'ATIVO',
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
