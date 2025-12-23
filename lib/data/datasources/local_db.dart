import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'interview_prep.db');

    return openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE user (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            email TEXT
          )
        ''');
        // onCreate ke andar ye bhi add karo
        await db.execute('''
  CREATE TABLE questions (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    text TEXT,
    role TEXT,
    difficulty TEXT
  )
''');
        await db.execute('''
  CREATE TABLE attempts (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    question_id INTEGER,
    answer TEXT,
    score INTEGER
  )
''');

      },
    );
  }

  static Future<List<Map<String, dynamic>>> getAttemptsWithQuestions() async {
    final db = await database;

    return await db.rawQuery('''
    SELECT 
      a.id,
      a.answer,
      a.score,
      q.text AS question_text
    FROM attempts a
    JOIN questions q
    ON a.question_id = q.id
    ORDER BY a.id DESC
  ''');
  }


  static Future<void> insertDummyQuestions() async {
    final db = await database;

    final count = Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM questions'),
    );

    if (count == 0) {
      final questions = [
        {
          'text': 'What is StatefulWidget in Flutter?',
          'role': 'Flutter',
          'difficulty': 'Easy',
        },
        {
          'text': 'Difference between Future and Stream?',
          'role': 'Flutter',
          'difficulty': 'Medium',
        },
        {
          'text': 'Explain MVVM architecture.',
          'role': 'Architecture',
          'difficulty': 'Medium',
        },
        {
          'text': 'What is the difference between hot reload and hot restart?',
          'role': 'Flutter',
          'difficulty': 'Easy',
        },
        {
          'text': 'What is the purpose of the build() method in Flutter?',
          'role': 'Flutter',
          'difficulty': 'Easy',
        },
        {
          'text': 'Explain the concept of InheritedWidget.',
          'role': 'Flutter',
          'difficulty': 'Medium',
        },
        {
          'text': 'What are keys in Flutter and why are they important?',
          'role': 'Flutter',
          'difficulty': 'Medium',
        },
        {
          'text': 'Difference between StatelessWidget and StatefulWidget?',
          'role': 'Flutter',
          'difficulty': 'Easy',
        },
        {
          'text': 'Explain FutureBuilder and StreamBuilder.',
          'role': 'Flutter',
          'difficulty': 'Medium',
        },
        {
          'text': 'What is the difference between async and await in Dart?',
          'role': 'Dart',
          'difficulty': 'Easy',
        },
        {
          'text': 'Explain the concept of Provider for state management.',
          'role': 'Flutter',
          'difficulty': 'Medium',
        },
        {
          'text': 'What is the purpose of the main() function in Flutter?',
          'role': 'Flutter',
          'difficulty': 'Easy',
        },
        {
          'text': 'Explain the difference between hot reload and hot restart.',
          'role': 'Flutter',
          'difficulty': 'Easy',
        },
        {
          'text': 'What is the difference between ListView and GridView?',
          'role': 'Flutter',
          'difficulty': 'Easy',
        },
        {
          'text': 'Explain null safety in Dart.',
          'role': 'Dart',
          'difficulty': 'Medium',
        },
        {
          'text': 'What are mixins in Dart and how are they used?',
          'role': 'Dart',
          'difficulty': 'Medium',
        },
        {
          'text': 'Difference between push and pushReplacement in Navigator.',
          'role': 'Flutter',
          'difficulty': 'Medium',
        },
        {
          'text': 'What is the difference between hot reload and rebuilding widgets?',
          'role': 'Flutter',
          'difficulty': 'Medium',
        },
        {
          'text': 'Explain the difference between mainAxisAlignment and crossAxisAlignment.',
          'role': 'Flutter',
          'difficulty': 'Easy',
        },
        {
          'text': 'What are the different types of animations in Flutter?',
          'role': 'Flutter',
          'difficulty': 'Medium',
        },
      ];

      for (var q in questions) {
        await db.insert('questions', q);
      }
    }
  }


  static Future<List<Map<String, dynamic>>> getQuestions() async {
    final db = await database;
    return await db.query('questions');
  }


  // save user (dummy login)
  static Future<void> saveUser(String name, String email) async {
    final db = await database;
    await db.insert('user', {
      'name': name,
      'email': email,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // check login
  static Future<bool> isLoggedIn() async {
    final db = await database;
    final result = await db.query('user');
    return result.isNotEmpty;
  }

  // get user
  static Future<Map<String, dynamic>?> getUser() async {
    final db = await database;
    final result = await db.query('user');
    return result.isNotEmpty ? result.first : null;
  }
}
