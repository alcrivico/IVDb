class CommentModel {
  final String id;
  final String content;
  final DateTime createdAt;
  final bool hidden;

  CommentModel({
    required this.id,
    required this.content,
    required this.createdAt,
    this.hidden = false,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      hidden: json['hidden'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'hidden': hidden,
    };
  }
}
