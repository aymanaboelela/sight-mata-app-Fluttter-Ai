import 'dart:async';
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:sight_mate_app/core/constants/cach_data_const.dart';
import 'package:sight_mate_app/core/helper/cach_data.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationService.instance.setupFlutterNotifications();
  await NotificationService.instance.showNotification(message);
}

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _messaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final FlutterTts _tts = FlutterTts();
  bool _isFlutterLocalNotificationsInitialized = false;

  Future<void> initialize(BuildContext context) async {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    final token = await _messaging.getToken();
    if (token != null) {
      CacheData.setData(key: AppCacheData.deviceToken, value: token);
      log("===================Device FirebaseMessaging Token====================");
      log(token);
      log("===================Device FirebaseMessaging Token====================");
    }

    await setupFlutterNotifications();
    await _setupMessageHandlers(context);
    await requestNotificationPermission();
  }

  Future<void> requestNotificationPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    log('Notification permission status: ${settings.authorizationStatus}');

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> setupFlutterNotifications() async {
    if (_isFlutterLocalNotificationsInitialized) return;

    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        log('Notification tapped: ${details.payload}');
      },
    );

    _isFlutterLocalNotificationsInitialized = true;
  }

  Future<void> showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    final body = notification?.body ?? "";

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription:
                'This channel is used for important notifications.',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );

      // ✅ نطق الإشعار
      await _speakNotification(body);
    }
  }

  Future<void> _speakNotification(String text) async {
    try {
      // (اختياري) تفعيل بناءً على user_type من الكاش
      // final isBlind = CacheData.getData(key: AppCacheData.isBlind) ?? false;
      // if (!isBlind) return;

      await _tts.setLanguage("ar-SA"); // أو "en-US"
      await _tts.setPitch(1.0);
      await _tts.setSpeechRate(0.5);
      await _tts.speak(text);
    } catch (e) {
      log("❌ TTS error: $e");
    }
  }

  Future<void> _setupMessageHandlers(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((message) {
      showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleMessageNavigation(message, context);
    });

    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageNavigation(initialMessage, context);
    }
  }

  void _handleMessageNavigation(RemoteMessage message, BuildContext context) {
    final type = message.data['type'];
    // يمكنك استخدام هذا السويتش للتوجيه حسب نوع الإشعار
    // switch (type) {
    //   case 'confirm':
    //     break;
    //   case 'reject':
    //     break;
    //   default:
    //     break;
    // }
  }
}
