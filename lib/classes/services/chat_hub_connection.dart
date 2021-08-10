import 'dart:developer';

import '../../util/utility/api_provider.dart';
import 'package:signalr_core/signalr_core.dart';

class ChatHubConnection {
  HubConnection connection;

  final Function receiveMessagecallBack;
  final Function chatsCountUpdatedcallBack;
  final Function receiveMessagescallBack;
  final Function receiveChatsInfocallBack;

  ChatHubConnection({
    this.receiveMessagecallBack,
    this.chatsCountUpdatedcallBack,
    this.receiveMessagescallBack,
    this.receiveChatsInfocallBack,
  });

  Future<void> openHubConnection() async {
    connection = HubConnectionBuilder()
        .withUrl(
          '${ApiProvider.baseUrl}/chat',
          HttpConnectionOptions(logging: (level, message) => print(message), accessTokenFactory: () async => await ApiProvider().getAccessToken()),
        )
        .withAutomaticReconnect()
        .build();

    await connection.start();

    localHubConnectionFunctions('ReceiveMessage', receiveMessagecallBack);
    localHubConnectionFunctions('ChatsCountUpdated', chatsCountUpdatedcallBack);
    localHubConnectionFunctions('ReceiveMessages', receiveMessagescallBack);
    localHubConnectionFunctions('ReceiveChatsInfo', receiveChatsInfocallBack);

    connection.onclose((exception) {
      log('/////////////////////////////////////////////////////// chat HubConnection onclose  ');
      log('//  chat connection.onclose:' + exception.toString());
    });
    connection.onreconnecting((exception) {
      log('////////////////////////////////////////////////////// chat HubConnection onreconnecting  ');
      log('//  chat connection.onreconnecting:' + exception.toString());
    });
    connection.onreconnected((exception) {
      log('////////////////////////////////////////////////////// chat HubConnection onreconnected  ');
      log('//  chat connection.onreconnected:' + exception.toString());
    });
    log('////  init chat HubConnection finish :');
  }

  void localHubConnectionFunctions(String funName, Function callBack) {
    try {
      connection.on(funName, (List<dynamic> parameters) {
        // var param = json.decode(parameters.toString());
        log('/// chat HubConnection on : $funName');
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
      log('/// invoke Chat HubConnectionFunctions ERROR');
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
