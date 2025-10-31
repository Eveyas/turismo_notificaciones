import 'dart:io'; 
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'app.dart';
import 'core/notifications/notification_service.dart';
import 'firebase_messaging_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase
  await Firebase.initializeApp();

  // Configurar handler para mensajes en background
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Inicializar servicio de notificaciones
  await NotificationService.initialize();

  // Configurar canal por defecto y permisos
  await _ensureFcmDefaultChannel();
  await _requestPermissions();

  // Configurar handlers para mensajes en foreground
  _configureForegroundHandlers();

  // Probar configuración de Firebase
  _testFirebaseConfig();

  runApp(const ProviderScope(child: TurismoApp()));
}

Future<void> _requestPermissions() async {
  final messaging = FirebaseMessaging.instance;
  if (Platform.isIOS) {
    await messaging.requestPermission(alert: true, badge: true, sound: true);
  } else if (Platform.isAndroid) {
    final androidImpl = FlutterLocalNotificationsPlugin()
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImpl?.requestNotificationsPermission();
  }
}

void _configureForegroundHandlers() {
  FirebaseMessaging.onMessage.listen((message) {
    final title = message.notification?.title ?? 'Mensaje';
    final body = message.notification?.body ?? 'Tienes una notificación';

    // Mostrar notificación local cuando la app está en foreground
    NotificationService.showNotification(
      title: title,
      body: body,
    );
  });

  FirebaseMessaging.onMessageOpenedApp.listen((message) {
    log('onMessageOpenedApp: ${message.data}');
  });
}

Future<void> _ensureFcmDefaultChannel() async {
  const channel = AndroidNotificationChannel(
    'default_channel_fcm',
    'General (FCM)',
    description: 'Canal por defecto para mensajes FCM',
    importance: Importance.high,
    playSound: true,
  );

  final plugin = FlutterLocalNotificationsPlugin()
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();
  await plugin?.createNotificationChannel(channel);
}

void _testFirebaseConfig() async {
  try {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    log('✅ FCM Token: $fcmToken');

    // Suscribir a tópico de prueba
    await FirebaseMessaging.instance.subscribeToTopic('test');
    log('✅ Suscrito al tópico: test');
  } catch (e) {
    log('❌ Error en configuración FCM: $e');
  }
}
