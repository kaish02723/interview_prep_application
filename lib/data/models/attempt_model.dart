class Attempt {
  final int questionId;
  final String answer;
  final int score;

  Attempt({
    required this.questionId,
    required this.answer,
    required this.score,
  });

  Map<String, dynamic> toMap() {
    return {
      'question_id': questionId,
      'answer': answer,
      'score': score,
    };
  }
}
