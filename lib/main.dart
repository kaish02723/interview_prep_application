import 'package:flutter/material.dart';
import 'package:interview_prep_app/presentation/screens/login_screen.dart';

import 'data/datasources/local_db.dart';
import 'notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = NotificationService();
  await notificationService.init();
  await notificationService.showAfterOneMinuteTest();
  await notificationService.scheduleDailyAtFixedTime(
    hour: DateTime.now().hour,
    minute: DateTime.now().minute + 1,
  );

  // FIXED DAILY TIME (7:00 AM)
  await notificationService.scheduleDailyAtFixedTime(
    hour: 7,
    minute: 0,
  );

  await LocalDB.database;
  await LocalDB.insertDummyQuestions();

  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Assignment',
      home: LoginScreen(),
    );
  }
}
