import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/utils/navigation_service.dart';

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

      if (message.notification != null || message.data.isNotEmpty) {
        _showInAppNotification(message);
      }
    });

    // Background Message Handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  void _showInAppNotification(RemoteMessage message) {
    final context = NavigationService.navigatorKey.currentContext;
    if (context == null) return;

    final title = message.notification?.title ?? "Yeni Bildirim";
    final body = message.notification?.body ?? "";
    final imageUrl = message.data['image'];

    OverlayEntry? overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 10,
        left: 15,
        right: 15,
        child: Material(
          color: Colors.transparent,
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.up,
            onDismissed: (_) => overlayEntry?.remove(),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
                border: Border.all(color: Colors.blue.shade50, width: 1),
              ),
              child: Row(
                children: [
                  if (imageUrl != null)
                    Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Colors.black87,
                          ),
                        ),
                        if (body.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              body,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: Colors.grey),
                    onPressed: () => overlayEntry?.remove(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // 5 saniye sonra otomatik kapat
    Future.delayed(const Duration(seconds: 5), () {
      if (overlayEntry != null && overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
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
