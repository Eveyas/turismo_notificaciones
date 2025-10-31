import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'default_channel_fcm';
  static const String _channelName = 'General (FCM)';
  static const String _channelDesc = 'Canal por defecto para mensajes FCM';

  static Future<void> initialize() async {
    // Configuración para Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuración para iOS
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    // Inicializar el sistema
    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await _notificationsPlugin.initialize(initializationSettings);

    // Crear canal de notificaciones en Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDesc,
      importance: Importance.high,
      playSound: true,
    );

    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidImplementation?.createNotificationChannel(channel);

    // Solicitud de permisos para Android
    if (Platform.isAndroid) {
      var status = await Permission.notification.status;
      if (!status.isGranted) {
        await Permission.notification.request();
      }
    }
  }

  // Enviar notificación local
  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
      payload: payload,
    );
  }

  // Método para mostrar notificación con imagen (Big Picture)
  static Future<void> showBigPicture({
    required String title,
    required String body,
    required String imageUrl,
  }) async {
    // Para imágenes remotas, debemos usar downloadPath
    final bigPicture = BigPictureStyleInformation(
      FilePathAndroidBitmap(imageUrl),
      contentTitle: title,
      summaryText: body,
      hideExpandedLargeIcon: false,
      // Añadimos HTML format para imágenes remotas
      htmlFormatContentTitle: true,
      htmlFormatSummaryText: true,
    );

    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          styleInformation: bigPicture,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          largeIcon: FilePathAndroidBitmap(imageUrl), // Icono grande
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }

  // Versión alternativa más simple para Big Picture
  static Future<void> showBigPictureSimple({
    required String title,
    required String body,
    required String imageUrl,
  }) async {
    final AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDesc,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          styleInformation: BigPictureStyleInformation(
            FilePathAndroidBitmap(imageUrl),
            contentTitle: title,
            summaryText: body,
          ),
          largeIcon: FilePathAndroidBitmap(imageUrl),
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      details,
    );
  }

  static Future<void> showLocal({
    required String title,
    required String body,
  }) async {
    await showNotification(title: title, body: body);
  }
}
