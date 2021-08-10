import 'dart:developer';

import '../../util/utility/api_provider.dart';
import 'package:signalr_core/signalr_core.dart';

class NotificationHubConnection {
  HubConnection connection;

  final Function notificationCountUpdatedcallBack;
  final Function chatsCountUpdatedcallBack;
  final Function subscribecallBack;
  final Function unsubscribecallBack;

  NotificationHubConnection({
    this.notificationCountUpdatedcallBack,
    this.chatsCountUpdatedcallBack,
    this.subscribecallBack,
    this.unsubscribecallBack,
  });

  Future<void> openHubConnection() async {
    connection = HubConnectionBuilder()
        .withUrl(
          '${ApiProvider.baseUrl}/notification',
          HttpConnectionOptions(
            logging: (level, message) {
              // print(message);
            },
            accessTokenFactory: () async => await ApiProvider().getAccessToken(),
          ),
        )
        .withAutomaticReconnect()
        .build();

    await connection.start();

    localHubConnectionFunctions('NotificationCountUpdated', notificationCountUpdatedcallBack);
    localHubConnectionFunctions('ChatsCountUpdated', chatsCountUpdatedcallBack);
    localHubConnectionFunctions('Subscribe', subscribecallBack);
    localHubConnectionFunctions('Unsubscribe', unsubscribecallBack);

    connection.onclose((exception) {
      log('/////////////////////////////////////////////////////// Notification HubConnection onclose  ');
      log('//  Notification connection.onclose:' + exception.toString());
    });
    connection.onreconnecting((exception) {
      log('////////////////////////////////////////////////////// Notification HubConnection onreconnecting  ');
      log('//  Notification connection.onreconnecting:' + exception.toString());
    });
    connection.onreconnected((exception) {
      log('////////////////////////////////////////////////////// Notification HubConnection onreconnected  ');
      log('//  Notification connection.onreconnected:' + exception.toString());
    });
    log('////  init Notification HubConnection finish :');
  }

  void localHubConnectionFunctions(String funName, Function callBack) {
    try {
      connection.on(funName, (List<dynamic> parameters) {
        // var param = json.decode(parameters.toString());
        log('/// Notification HubConnection on : $funName');
        if (parameters.length > 0) {
          print('// $funName :' + parameters[0].toString());
          callBack(parameters[0]);
        }
      });
    } catch (err) {
      log('/// local HubConnection Functions ERROR');
      print(err.toString());
    }
  }

  void invokeHubConnectionFunctions(String funName, List<dynamic> args) {
    try {
      if (isConnected()) connection.invoke(funName, args: args);
    } catch (err) {
      log('/// invoke Notification HubConnectionFunctions ERROR');
      print(err.toString());
    }
  }

  void closeHubConnection() {
    connection.stop();
  }

  bool isConnected() {
    return connection != null && connection.state == HubConnectionState.connected;
  }
}
