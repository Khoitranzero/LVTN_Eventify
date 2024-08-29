import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier {
  List<dynamic> _notifications = [];

  List<dynamic> get notifications => _notifications;

  void setNotifications(List<dynamic> notifications) {
    _notifications = notifications;
    notifyListeners();
  }

  void addNotification(dynamic notification) {
    _notifications.add(notification);
    notifyListeners();
  }
}
