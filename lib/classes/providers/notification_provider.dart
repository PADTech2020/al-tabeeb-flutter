import 'dart:convert';
import 'dart:developer';
import 'package:elajkom/classes/models/chat.dart';
import 'package:elajkom/ui/pages/chat/Message_page.dart';
import 'package:elajkom/ui/pages/meetings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../models/notifications.dart';
import '../services/cloud_messaging.dart';
import '../services/notification_hub_connection.dart';
import '../../util/utility/api_provider.dart';
import '../../util/utility/global_var.dart';
import 'chat_provider.dart';

class NotificationProvider extends ChangeNotifier {
  NotificationHubConnection notificationHubConnection;
  static const String EntityTypeMeeting = "Meeting";
  static const String EntityTypeMeetingStarted = "MeetingStarted";
  static const String EntityTypeChatMessage = "ChatMessage";

  // CloudMessaging cloudMessaging;

  List<NotificationPayload> _notifications = [];
  List<NotificationPayload> get notifications => _notifications;
  set notifications(List<NotificationPayload> notifications) {
    _notifications = notifications;
    notifyListeners();
  }

  int _notificationItemCount = 0;
  int get notificationItemCount => _notificationItemCount;
  set notificationItemCount(int notificationItemCount) {
    _notificationItemCount = notificationItemCount;
    notifyListeners();
  }

  int _chatCount = 0;
  int get chatCount => _chatCount;
  set chatCount(int chatCount) {
    _chatCount = chatCount;
    notifyListeners();
  }

  void initData() {
    _notifications.clear();
    _notificationItemCount = 0;
    _chatCount = 0;
    closeConnection();
    GlobalVar.cloudMessaging = null;
  }

  Future<List<NotificationPayload>> loadUserNotifications(int page) async {
    String subUrl = '/api/v1/Notifications/$page';

    List<NotificationPayload> list = [];
    var res = await ApiProvider().getRequest(subUrl);
    if (res is List) {
      if (page == 0) _notifications.clear();
      res.forEach((element) {
        list.add(NotificationPayload.fromJson(element));
      }); // for (var i = 0; i < 20; i++) list.add(NotificationPayload(id: _notifications.length > 0 ? _notifications.last.id + 1 : 0));
    }
    _notifications.addAll(list);
    notifyListeners();
    return list;
  }

  Future<void> subscribe(int entity, String topic) async {
    await ApiProvider().postRequest('/api/v1/Notifications/Subscribe/$entity/$topic', json.encode('{}}'));
  }

  Future<void> unsubscribe(int entity, String topic) async {
    await ApiProvider().postRequest('/api/v1/Notifications/Unsubscribe/$entity/$topic', json.encode('{}}'));
  }

  void entityRouting(BuildContext context, NotificationPayload item) async {
    switch (item.entity) {
      case EntityTypeChatMessage: //ChatMessage
        if (GlobalVar.isLogin(context)) {
          try {
            ChatProvider chatProvider = Provider.of<ChatProvider>(context, listen: false);
            if (chatProvider.currentChat == null || chatProvider.currentChat.id != item.entityId) {
              var userData = json.decode(item.entityData);
              Chat chat = Chat(
                id: userData['Id'],
                fullName: userData['FullName'],
                photo: userData['ProfilePhoto'],
              );
              Navigator.pushNamed(context, MessagePage.routeName, arguments: [chat, int.tryParse(item.entityId)]);
            }
          } catch (err) {
            print(err.toString());
          }
        }
        break;

      case EntityTypeMeeting: // meeting
        if (GlobalVar.isLogin(context)) Navigator.of(context).pushNamed(MeetingsPage.routeName, arguments: false);
        break;
      case EntityTypeMeetingStarted: //ChatMessage
        if (GlobalVar.isLogin(context)) {
          try {
            Chat chat = Chat(id: "", fullName: "", photo: "");
            Navigator.pushNamed(context, MessagePage.routeName, arguments: [chat, int.tryParse(item.entityId)]);
          } catch (err) {
            print(err.toString());
          }
        }
        break;
      default:
    }
  }

////////////////{ Local Method } ////////////////
  void notificationCountUpdatedcallBack(dynamic param) {
    if (param is int) notificationItemCount = param;
  }

  void chatsCountUpdatedcallBack(dynamic param) {
    if (param is int) chatCount = param;
  }

  void subscribecallBack(dynamic param) {
    for (final item in param) {
      GlobalVar.cloudMessaging.subscribeToTopic(item);
    }
  }

  void unsubscribecallBack(dynamic param) {
    for (final item in param) {
      GlobalVar.cloudMessaging.unsubscribeFromTopic(item);
    }
  }

  ////////////////{ invoke server Method } ////////////////

  void readAllNotifications() {
    log('/// notification HubConnection invoke : ReadAllNotifications  ');
    if (notificationHubConnection.isConnected()) notificationHubConnection.invokeHubConnectionFunctions('ReadAllNotifications', []);
  }

  ////////////////{ connection Method } ////////////////
  Future<void> initNotificationConnection() async {
    if (notificationHubConnection == null || !notificationHubConnection.isConnected()) {
      notificationHubConnection = NotificationHubConnection(
        notificationCountUpdatedcallBack: notificationCountUpdatedcallBack,
        chatsCountUpdatedcallBack: chatsCountUpdatedcallBack,
        subscribecallBack: subscribecallBack,
        unsubscribecallBack: unsubscribecallBack,
      );
      await notificationHubConnection.openHubConnection();
    }
  }

  Future<void> closeConnection() async {
    if (notificationHubConnection != null && notificationHubConnection.isConnected()) await notificationHubConnection.connection.stop();
  }

  //////////////// { firebase section } ////////////////
  void initFirebaseConnection() async {
    if (GlobalVar.cloudMessaging == null) {
      GlobalVar.cloudMessaging = CloudMessaging();
    }
  }
}
