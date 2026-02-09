import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("Handling a background message: ${message.messageId}");
}

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> init() async {
    // Request Permission
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
    } else {
      debugPrint('User declined or has not accepted permission');
      return;
    }

    // iOS Foreground Notification Settings
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Subscribe to General Topic
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      debugPrint("iOS detected, waiting for APNS token...");
      int retryCount = 0;
      String? apnsToken;
      while (retryCount < 10 && apnsToken == null) {
        try {
          apnsToken = await _firebaseMessaging.getAPNSToken();
        } catch (e) {
          debugPrint("Error fetching APNS token: $e");
        }

        if (apnsToken == null) {
          debugPrint(
            "Waiting for APNS token... (Attempt ${retryCount + 1}/10)",
          );
          await Future.delayed(const Duration(seconds: 2));
          retryCount++;
        }
      }

      if (apnsToken != null) {
        debugPrint("APNS Token Received: $apnsToken");
      } else {
        debugPrint(
          "Could not receive APNS token after 20 seconds. Messaging might fail.",
        );
      }
    }

    try {
      await subscribeToTopic('dryfix_all');
    } catch (e) {
      debugPrint("Initial topic subscription failed: $e");
    }

    // Get FCM Token
    try {
      final fcmToken = await _firebaseMessaging.getToken();
      debugPrint("FCM Token: $fcmToken");
      // TODO: Send this token to backend if needed
    } catch (e) {
      debugPrint("Error getting FCM token: $e");
    }

    // Foreground Message
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint(
          'Message also contained a notification: ${message.notification?.title} - ${message.notification?.body}',
        );
      }
    });

    // Background Message Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      debugPrint("Subscribed to topic: $topic");
    } catch (e) {
      debugPrint("Error subscribing to topic $topic: $e");
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint("Unsubscribed from topic: $topic");
    } catch (e) {
      debugPrint("Error unsubscribing from topic $topic: $e");
    }
  }
}
