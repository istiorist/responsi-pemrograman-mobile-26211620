class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMetadata() =>
      {'id': id, 'title': title, 'createdAt': createdAt.toIso8601String()};

  factory Note.fromMetadata(Map<String, dynamic> json, String content) => Note(
        id: json['id'] as String,
        title: json['title'] as String,
        content: content,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}