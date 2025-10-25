import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (kIsWeb) return; // ⚡ En web no inicializa nada

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings();
    const settings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _local.initialize(settings);

    const channel = AndroidNotificationChannel(
      'default_channel',
      'General',
      description: 'Canal de notificaciones generales',
      importance: Importance.high,
    );

    await _local
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> showLocal({
    required BuildContext context,
    required String title,
    required String body,
    String? payload,
  }) async {
    if (kIsWeb) {
      // 💻 Simular notificación en Web
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$title: $body'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.teal,
          duration: const Duration(seconds: 3),
        ),
      );
      return;
    }

    const androidDetails = AndroidNotificationDetails(
      'default_channel',
      'General',
      importance: Importance.high,
      priority: Priority.high,
    );
    const iosDetails = DarwinNotificationDetails();

    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
      payload: payload,
    );
  }
}
