import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _notificationPlugin =
      FlutterLocalNotificationsPlugin();
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // Initialize Notification Plugin
  Future<void> initNotification() async {
    if (_isInitialized) return;

    try {
      // Android initialization settings
      const AndroidInitializationSettings initSettingsAndroid =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      // Combined initialization settings
      const InitializationSettings initSettings =
          InitializationSettings(android: initSettingsAndroid);

      // Initialize plugin
      await _notificationPlugin.initialize(initSettings);

      // Request permission
      final bool? result = await _notificationPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
      if (result != true) {
        print("Notification permission not granted.");
      }

      _isInitialized = true; // Mark as initialized
    } catch (e) {
      print("Error initializing notifications: $e");
    }
  }

  // Notification Details
  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        "daily_channel_id",
        "Daily Notifications",
        channelDescription: "Daily Notification Channel",
        importance: Importance.high,
        priority: Priority.high,
      ),
    );
  }

  // Show Notification
  Future<void> showNotification({
    int id = 0,
    required String title,
    required String body,
  }) async {
    try {
      await _notificationPlugin.show(
        id,
        title,
        body,
        _notificationDetails(),
      );
    } catch (e) {
      print("Error showing notification: $e");
    }
  }
}
