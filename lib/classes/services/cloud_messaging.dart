import 'dart:developer';
import 'dart:io';
import 'package:elajkom/classes/providers/chat_provider.dart';
import 'package:elajkom/ui/pages/main_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/notification_provider.dart';
import '../../util/utility/global_var.dart';
import '../models/notifications.dart';

class CloudMessaging {
  BuildContext context;
  FirebaseMessaging _firebaseMessaging;
  // LocalNotification localNotification;

  CloudMessaging({this.context}) {
    _firebaseMessaging = FirebaseMessaging();
    init();
  }

  void init() {
    log('****** CloudMessaging init');
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("***************************************** onMessage: $message");
        payloadHandel('onMessage', parsePayload(message));
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("***************************************** onLaunch: $message");
        NotificationProvider notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
        notificationProvider.entityRouting(context, parsePayload(message));
      },
      onResume: (Map<String, dynamic> message) async {
        print("***************************************** onResume: $message");
        NotificationProvider notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
        notificationProvider.entityRouting(context, parsePayload(message));
      },
    );

    _firebaseMessaging.requestNotificationPermissions(const IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      log("************** Settings registered: $settings");
    });

    _firebaseMessaging.getToken().then((String token) {
      assert(token != null);
      {
        print('******************************************* firebase token : $token');
        var topic = MainPage.userProvider?.user?.userTopicId ?? null;
        if (topic != null) subscribeToTopic(topic + "_" + GlobalVar.initializationLanguage);
        subscribeToTopic("all_" + GlobalVar.initializationLanguage);
      }
    });
  }

  void payloadHandel(String source, NotificationPayload payload) {
    print("*************************************** payloadHandel $source payload : ${payload.toJson().toString()}");
    print("*************************payload.entity : ${payload.entity}");
    if (payload.entity == NotificationProvider.EntityTypeChatMessage) {
      ChatProvider chatProvider = Provider.of<ChatProvider>(context, listen: false);
      if (chatProvider.currentChat == null || chatProvider.currentChat.id != payload.entityId) GlobalVar.localNotification.showNotifications(payload);
    } else if (payload.entity == NotificationProvider.EntityTypeMeeting || payload.entity == NotificationProvider.EntityTypeMeetingStarted) {
      GlobalVar.localNotification.showNotifications(payload);
    }
  }

  NotificationPayload parsePayload(data) {
    if (Platform.isIOS) {
      data = data;
    } else {
      data = data['data'];
    }
    NotificationPayload payload = NotificationPayload();
    if (data.containsKey('Id')) payload.id = int.tryParse(data['Id']);
    if (data.containsKey('Title')) payload.title = data['Title'];
    if (data.containsKey('Text')) payload.text = data['Text'];
    if (data.containsKey('ImageUrl')) payload.image = data['ImageUrl'];
    if (data.containsKey('Url')) payload.url = data['Url'];
    if (data.containsKey('Topic')) payload.topic = data['Topic'];
    if (data.containsKey('Entity')) payload.entity = (data['Entity']);
    if (data.containsKey('EntityId')) payload.entityId = data['EntityId'];
    if (data.containsKey('EntityData')) payload.entityData = data['EntityData'];
    if (data.containsKey('CreatedDate')) payload.createdDate = data['CreatedDate'];
    return payload;
  }

  void subscribeToTopic(topic) {
    _firebaseMessaging.subscribeToTopic(topic).then((onValue) {
      log('subscribed To Topic : $topic');
    }).catchError((err) {
      print('subscribed To Topic error : ${err.toString()}');
    });
  }

  void unsubscribeFromTopic(topic) {
    _firebaseMessaging.unsubscribeFromTopic(topic).then((onValue) {
      log('unsubscribed To Topic : $topic');
    });
  }

  void deleteInstance() async {
    if (_firebaseMessaging != null) await _firebaseMessaging.deleteInstanceID();
  }
}
