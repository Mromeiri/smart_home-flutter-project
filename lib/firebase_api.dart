import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_home/Screen/home/homePage.dart';
import 'package:smart_home/Screen/notification/notification_provider.dart';
import 'package:smart_home/Screen/notification/notification_screen.dart';
import 'package:smart_home/Screen/temperature/provider/temperature_provider.dart';
import 'package:smart_home/main.dart';
import 'package:smart_home/models/notification.dart';
import 'package:smart_home/models/temperature.dart';
import 'package:smart_home/notificationService.dart';

Future<void> hadleBackgroundMessage(RemoteMessage message) async {
  if (message.data['type'] == 'temperature') {
    final temperatureProvider = Provider.of<TemperatureProvider>(
      navigationKey.currentContext!,
      listen: false,
    );
    temperatureProvider.setTemperature(Temperature(
        temperature: message.data['temerature'],
        humidity: message.data['humidity']));
    if (double.parse(message.data['temperature']) > 40) {
      // NotificationService().showNotification(
      //     title: ('Temperature Too High'),
      //     body:
      //         "The temperature in the room is ${double.parse(message.data['temperature'])}°");
    }
  } else {
    NotificationService()
        .showNotification(title: (message.notification?.title ?? ''));
  }
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    Navigator.push(
      navigationKey.currentContext!,
      MaterialPageRoute(builder: (context) => NotificationScreen()),
    );
  }

  Future<void> initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(hadleBackgroundMessage);
    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (message.data['type'] == 'temperature') {
        final temperatureProvider = Provider.of<TemperatureProvider>(
          navigationKey.currentContext!,
          listen: false,
        );
        temperatureProvider.setTemperature(Temperature(
            temperature: double.parse(message.data['temperature']),
            humidity: double.parse(message.data['humidity'])));
        // if (double.parse(message.data['temperature']) > 40) {
        //   NotificationService().showNotification(
        //       title: ('Temperature Too High'),
        //       body:
        //           "The temperature in the room is ${double.parse(message.data['temperature'])}°");
        // }
      } else {
        print(message.data);
        if (message.data['data_type'] == 'notification' ||
            message.data['data_type'] == 'announcment') {
          final notificationProvider = Provider.of<NotificationProvider>(
            navigationKey.currentContext!,
            listen: false,
          );
          notificationProvider.addNotification(MyNotification(
              id: message.data['id'],
              title: message.data['title'],
              detail: message.data['detail'],
              thumnail: message.data['thumnail'],
              date: message.data['date'],
              type: message.data['data_type']));
        } else {
          final notificationProvider = Provider.of<NotificationProvider>(
            navigationKey.currentContext!,
            listen: false,
          );
          notificationProvider.addNotification(MyNotification(
            id: message.data['id'],
            title: message.data['title'],
            detail: message.data['detail'],
            thumnail: "",
            date: message.data['date'],
            type: message.data['type'],
            itemControlled: message.data['itemControlled'],
            predectedClass: message.data['classWantedToApply'],
          ));
        }
        NotificationService().showNotification(
            title: (message.notification?.title ?? ''),
            body: message.data['detail']);
      }
      print(message.data);
      // NotificationService().showNotification(
      //     title: (notification?.title ?? ''), body: notification?.body);
    });
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();

    print('Token : $fCMToken');
    initPushNotification();
  }
}
