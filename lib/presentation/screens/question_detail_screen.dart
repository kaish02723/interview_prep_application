import 'dart:ui';
import 'package:flutter/material.dart';

import '../../data/datasources/local_db.dart';
import '../../domain/entities/question.dart';
import '../../domain/scoring/scoring_service.dart';

class QuestionDetailScreen extends StatefulWidget {
  final Question question;

  const QuestionDetailScreen({super.key, required this.question});

  @override
  State<QuestionDetailScreen> createState() => _QuestionDetailScreenState();
}

class _QuestionDetailScreenState extends State<QuestionDetailScreen> {
  final TextEditingController _answerController = TextEditingController();
  bool _submitted = false;
  int _score = 0;
  bool _loading = false;

  Future<void> _submitAnswer() async {
    final answer = _answerController.text.trim();
    if (answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write your answer first')),
      );
      return;
    }

    setState(() => _loading = true);

    final score = ScoringService.calculateScore(answer);

    await LocalDB.database.then((db) {
      db.insert('attempts', {
        'question_id': widget.question.id,
        'answer': answer,
        'score': score,
      });
    });

    await Future.delayed(const Duration(milliseconds: 600));

    setState(() {
      _submitted = true;
      _score = score;
      _loading = false;
    });
  }

  Color get scoreColor {
    if (_score >= 4) return Colors.green;
    if (_score >= 2) return Colors.orange;
    return Colors.red;
  }

  String get feedbackText {
    if (_score >= 4) return 'Excellent Answer';
    if (_score >= 2) return 'Good, but can improve';
    return 'Needs Practice';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        backgroundColor: const Color(0xff4A6CF7),

        title: const Text('Interview Question'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// QUESTION CARD
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.question.text,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      children: [
                        Chip(
                          label: Text(widget.question.role),
                          backgroundColor: Colors.blue.shade50,
                        ),
                        Chip(
                          label: Text(widget.question.difficulty),
                          backgroundColor: Colors.purple.shade50,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// ANSWER INPUT
            TextField(
              controller: _answerController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Write your answer here...',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 24),

            /// SUBMIT BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _loading ? null : _submitAnswer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  'Submit Answer',
                  style: TextStyle(fontSize: 16,color: Colors.white),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// RESULT
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: _submitted
                  ? Card(
                key: const ValueKey(1),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        feedbackText,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: scoreColor,
                        ),
                      ),
                      const SizedBox(height: 12),

                      /// SCORE BAR
                      LinearProgressIndicator(
                        value: _score / 5,
                        color: scoreColor,
                        backgroundColor: Colors.grey.shade300,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(10),
                      ),

                      const SizedBox(height: 12),
                      Text(
                        'Score: $_score / 5',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
