import 'package:flutter/material.dart';
import 'package:smart_home/models/notification.dart';

class NotificationProvider with ChangeNotifier {
  List<MyNotification> _notificationsItems = [];

  List<MyNotification> get notificationsItems => _notificationsItems;

  void addNotification(MyNotification notification) {
    _notificationsItems.add(notification);
    _notificationsItems.sort(
        (a, b) => DateTime.parse(b.date).compareTo(DateTime.parse(a.date)));

    notifyListeners();
  }

  void removeNotification(MyNotification notification) {
    _notificationsItems.remove(notification);

    notifyListeners();
  }

  void setNotifications(List<MyNotification> notifications) {
    _notificationsItems = notifications;
    notifyListeners();
  }

  void clearNotification() {
    _notificationsItems.clear();
    notifyListeners();
  }
}
