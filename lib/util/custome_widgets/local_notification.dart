import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import '../../classes/models/notifications.dart';
import '../../classes/providers/notification_provider.dart';
import '../../util/utility/custom_theme.dart';

/// dependencies:
//   flutter_local_notifications: ^1.4.3

class LocalNotification {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  BuildContext context;
  LocalNotification(this.context) {
    initializing();
  }

  void _requestIOSPermissions() {
    flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('ic_launcher');
    iosInitializationSettings = IOSInitializationSettings(onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
    _requestIOSPermissions();
  }

  void showNotifications(NotificationPayload item) async {
    await _notification(item);
  }

  Future<void> _notification(NotificationPayload item) async {
    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails('GlobalNotification_5', 'اشعارات التطبيق', 'اشعارات التطبيق',
        priority: Priority.High, importance: Importance.Max, ticker: item.title, color: CustomTheme.accentColor);

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(1, item.title ?? '', item.text ?? '', notificationDetails, payload: json.encode(item.toJson()));
  }

  Future onSelectNotification(String payload) {
    openNotification(payload);
    return Future.delayed(Duration(microseconds: 0));
  }

  Future onDidReceiveLocalNotification(int id, String title, String body, String payload) async {
    openNotification(payload);
  }

  void openNotification(String payload) {
    if (payload != null) {
      log(' ******** onDidReceiveLocalNotification payload: $payload');
      NotificationPayload notificationPayload = NotificationPayload.fromJson(json.decode(payload));
      NotificationProvider notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
      notificationProvider.entityRouting(context, notificationPayload);
    }
  }
}
