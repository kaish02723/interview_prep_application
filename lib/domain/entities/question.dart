class Question {
  final int? id;
  final String text;
  final String role;
  final String difficulty;

  Question({
    this.id,
    required this.text,
    required this.role,
    required this.difficulty,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'role': role,
      'difficulty': difficulty,
    };
  }

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'],
      text: map['text'],
      role: map['role'],
      difficulty: map['difficulty'],
    );
  }
}
