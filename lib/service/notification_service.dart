import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _notif = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);
    await _notif.initialize(settings);
  }

  Future<void> showAdzan(String prayer) async {
    await _notif.show(
      0,
      "Waktu Shalat",
      "Saatnya $prayer",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'adzan',
          'Adzan',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }
}