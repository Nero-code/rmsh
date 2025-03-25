import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

/// Firebase NotificationService integration, But [onBackgroundMessage]
/// throws null [Exception] for unknown resons...
///
/// Needs more refactoring and error handling
class NotificationService {
  /// Stream Subscription for adding listeners and maneging Subscriptions...
  StreamSubscription<RemoteMessage>? _subscription;

  /// A getter for the private field to deny any accedental modification
  /// of the property...
  get subscription => _subscription;

  /// Initialization of the service needs to be a singleton
  Future<void> init() async {
    FirebaseMessaging.onBackgroundMessage(_backgroundNotificationHandler);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    if (kDebugMode) FirebaseMessaging.onMessage.listen((e) => print(e.toMap()));
  }

  /// background message to fetch notifications on the fly,
  ///
  /// and showing the notification dialog on screen while the app is `Dismissed`.
  Future<void> _backgroundNotificationHandler(RemoteMessage message) async {
    print("Background Service");
    print(message.toMap());
  }

  /// Adds a listener on the `onMessage` stream and calls `onNotification`
  /// on new events...
  ///
  /// if (`subscription != null`) => cancel old then add new...
  void addListener(void Function(RemoteMessage) onNotification) async {
    if (_subscription != null) await _subscription!.cancel();
    _subscription = FirebaseMessaging.onMessage.listen(onNotification);
  }

  /// Safety valve for whatever could go wrong...
  void dispose() async {
    if (_subscription != null) await _subscription!.cancel();
  }
}
