import 'package:flutter/material.dart';

import '../../data/datasources/local_db.dart';

class AttemptsHistoryScreen extends StatelessWidget {
  const AttemptsHistoryScreen({super.key});

  Future<List<Map<String, dynamic>>> _loadAttempts() async {
    return await LocalDB.getAttemptsWithQuestions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text('Attempts History',style: TextStyle(color: Colors.white),),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _loadAttempts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No attempts yet'));
          }

          final attempts = snapshot.data!;

          return ListView.builder(
            itemCount: attempts.length,
            itemBuilder: (context, index) {
              final item = attempts[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['question_text'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Answer: ${item['answer']}'),
                      const SizedBox(height: 8),
                      Text(
                        'Score: ${item['score']} / 5',
                        style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
