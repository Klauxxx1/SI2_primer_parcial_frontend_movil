class RecomendacionInteligente {
  final int id;
  final double score;
  final int productoId;

  RecomendacionInteligente({
    required this.id,
    required this.score,
    required this.productoId,
  });

  factory RecomendacionInteligente.fromJson(Map<String, dynamic> json) {
    return RecomendacionInteligente(
      id: json['id'],
      score: double.parse(json['score'].toString()),
      productoId: json['producto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'score': score,
      'producto': productoId,
    };
  }
}