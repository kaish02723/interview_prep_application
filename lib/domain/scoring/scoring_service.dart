class ScoringService {
  static int calculateScore(String answer) {
    if (answer.length < 20) return 1;
    if (answer.length < 50) return 2;
    if (answer.length < 100) return 3;
    if (answer.length < 150) return 4;
    return 5;
  }
}
