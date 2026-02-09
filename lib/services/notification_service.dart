import 'dart:developer' as developer;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Top-level function to handle background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  developer.log(
    '📬 Background message received: ${message.messageId}',
    name: 'FCM',
  );
}

class NotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  Future<void> init() async {
    try {
      developer.log('🚀 Initializing Notification Service', name: 'FCM');

      // Permission Request
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(
            alert: true,
            announcement: false,
            badge: true,
            carPlay: false,
            criticalAlert: false,
            provisional: false,
            sound: true,
          );

      developer.log(
        '📱 Permission status: ${settings.authorizationStatus}',
        name: 'FCM',
      );

      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        developer.log('⚠️ User declined notification permissions', name: 'FCM');
        return;
      }

      // iOS Foreground Notification Settings
      await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );

      // Handle Initial Message (Terminated State)
      RemoteMessage? initialMessage = await _firebaseMessaging
          .getInitialMessage();
      if (initialMessage != null) {
        developer.log(
          '🔔 App opened from terminated state via FCM',
          name: 'FCM',
        );
        _handleMessageNavigation(initialMessage);
      }

      // Handle Notification Taps (Background State)
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageNavigation);

      // Foreground Message - Sadece Loglama
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        developer.log('📨 Foreground message received', name: 'FCM');
        developer.log('Payload data: ${message.data}', name: 'FCM');
      });

      // Background Message Handler
      FirebaseMessaging.onBackgroundMessage(
        _firebaseMessagingBackgroundHandler,
      );

      // Topic Subscription
      await subscribeToTopic('dryfix_all');

      // Get FCM Token
      final fcmToken = await _firebaseMessaging.getToken();
      developer.log('🔑 FCM Token: $fcmToken', name: 'FCM');
    } catch (e, stackTrace) {
      developer.log(
        '❌ Error initializing FCM',
        name: 'FCM',
        error: e,
        stackTrace: stackTrace,
      );
    }
  }

  void _handleMessageNavigation(RemoteMessage message) {
    developer.log(
      '🚀 Processing Navigation Data: ${message.data}',
      name: 'FCM',
    );
    final data = message.data;
    if (data.isEmpty) return;

    final type = data['type']?.toString();
    final id = data['id']?.toString();

    if (type != null) {
      developer.log('📍 Navigation Target: $type - ID: $id', name: 'FCM');
    }
  }

  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      developer.log('📌 Subscribed to topic: $topic', name: 'FCM');
    } catch (e) {
      developer.log('❌ Error subscribing to topic $topic: $e', name: 'FCM');
    }
  }

  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      developer.log('📌 Unsubscribed from topic: $topic', name: 'FCM');
    } catch (e) {
      developer.log('❌ Error unsubscribing from topic $topic: $e', name: 'FCM');
    }
  }
}
