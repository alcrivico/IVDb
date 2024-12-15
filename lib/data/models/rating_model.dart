class RatingModel {
  final int id;
  final int rate;
  final DateTime? createdAt;

  RatingModel({
    required this.id,
    required this.rate,
    required this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'],
      rate: json['rate'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rate': rate,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
