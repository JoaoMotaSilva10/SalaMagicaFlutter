class Usuario {
  final int id;
  final String nome;
  final String email;
  final String statusUsuario;
  final String? rm;
  final String? cpf;
  final String? turma;
  final String? serie;
  final String? periodo;
  final String? unidade;
  final String tipoUsuario;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.statusUsuario,
    this.rm,
    this.cpf,
    this.turma,
    this.serie,
    this.periodo,
    this.unidade,
    required this.tipoUsuario,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    try {
      return Usuario(
        id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
        nome: json['nome']?.toString() ?? 'Sem nome',
        email: json['email']?.toString() ?? 'Sem email',
        statusUsuario: json['statusUsuario']?.toString() ?? 'ATIVO',
        rm: json['rm']?.toString(),
        cpf: json['cpf']?.toString(),
        turma: json['turma']?.toString(),
        serie: json['serie']?.toString(),
        periodo: json['periodo']?.toString(),
        unidade: json['unidade']?.toString(),
        tipoUsuario: json['tipoUsuario']?.toString() ?? 'ALUNO',
      );
    } catch (e) {
      print('Erro ao criar Usuario: $e');
      print('JSON recebido: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'statusUsuario': statusUsuario,
      'rm': rm,
      'cpf': cpf,
      'turma': turma,
      'serie': serie,
      'periodo': periodo,
      'unidade': unidade,
      'tipoUsuario': tipoUsuario,
    };
  }

}
