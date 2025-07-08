class Usuario {
  final int id;
  final String nome;
  final String email;
  final String nivelAcesso;
  final String statusUsuario;
  final int? rm;
  final String? cpf;
  final String? turma;
  final String? unidade;
  final String? serie;
  final String? periodo;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.nivelAcesso,
    required this.statusUsuario,
    this.rm,
    this.cpf,
    this.turma,
    this.unidade,
    this.serie,
    this.periodo,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      nome: json['nome'],
      email: json['email'],
      nivelAcesso: json['nivelAcesso'],
      statusUsuario: json['statusUsuario'],
      rm: json['rm'],
      cpf: json['cpf'],
      turma: json['turma'],
      unidade: json['unidade'],
      serie: json['serie'],
      periodo: json['periodo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'nivelAcesso': nivelAcesso,
      'statusUsuario': statusUsuario,
      'rm': rm,
      'cpf': cpf,
      'turma': turma,
      'unidade': unidade,
      'serie': serie,
      'periodo': periodo,
    };
  }

}
