import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _instance =
  NotificationService._internal();

  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();
  Future<void> showAfterOneMinuteTest() async {
    final scheduledTime =
    tz.TZDateTime.now(tz.local).add(const Duration(minutes: 1));

    await _plugin.zonedSchedule(
      99,
      'Test Notification',
      '1 minute test successful',
      scheduledTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );

    print('Test notification scheduled for $scheduledTime');
  }


  /// INIT (APP START)
  Future<void> init() async {
    tz.initializeTimeZones();

    const androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: androidInit);

    await _plugin.initialize(settings);
    await _requestNotificationPermission();
  }
  Future<void> _requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }
  ///DAILY FIXED TIME (EX: 7:00 AM)
  Future<void> scheduleDailyAtFixedTime({
    required int hour,
    required int minute,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'daily_channel',
      'Daily Interview Reminder',
      channelDescription: 'Daily interview question reminder',
      importance: Importance.max,
      priority: Priority.high,
    );

    final details = NotificationDetails(android: androidDetails);

    final scheduledTime = _nextTime(hour, minute);

    print('Notification scheduled for: $scheduledTime');

    await _plugin.zonedSchedule(
      0,
      'Interview Prep',
      'Daily interview question ready',
      scheduledTime,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );

  }

  tz.TZDateTime _nextTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);

    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }
  Future<void> showNow() async {
    const androidDetails = AndroidNotificationDetails(
      'test_channel',
      'Test Channel',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      999,
      'Test Notification',
      'Abhi turant show hona chahiye',
      details,
    );

    print('showNow() called');
  }

}