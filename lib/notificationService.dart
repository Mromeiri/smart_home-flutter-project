import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:smart_home/Screen/home/homePage.dart';
import 'package:smart_home/main.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {
          _handleNotificationTap(payload);
        });

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
      _handleNotificationTap(notificationResponse.payload);
    });
  }

  notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future showNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payLoad,
      String? subtitle}) async {
    return notificationsPlugin.show(
        id, title, body, await notificationDetails());
  }

  void _handleNotificationTap(String? payload) {
    // Add your logic to navigate to the desired page based on the payload
    if (payload != null) {
      // Extract information from the payload, e.g., route name

      // Navigate to the desired page using Navigator
      Navigator.push(
        navigationKey.currentContext!,
        MaterialPageRoute(builder: (context) => MyHomePage()),
      );
    }
  }
}
