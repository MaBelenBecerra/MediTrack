import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHelper {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    
    await _notifications.initialize(settings: initSettings);
  }

  static Future<void> showNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      'meditrack_channel', 'Recordatorios',
      importance: Importance.max, priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);
    
    await _notifications.show(
      id: 0, 
      title: title, 
      body: body, 
      notificationDetails: details,
    );
  }
}