import 'dart:developer';

import 'package:flutter/foundation.dart';
import '../models/chat.dart';
import '../models/message.dart';
import '../services/chat_hub_connection.dart';

////////////////{ server documentaion :https://docs.google.com/document/d/1sZl70Ou8Qc-mdzRfvbEwnb4IrMwa3zwG9kblfzjZwWc/edit?usp=sharing } ////////////////

class ChatProvider extends ChangeNotifier {
  List<Chat> _chats = [];
  bool chatMoreAvalible = true;
  Chat currentChat;
  List<Message> _messages = [];
  bool messagesMoreAvalible = true;
  List<Message> _messagesSelected = [];
  bool _selectionMode = false;
  String localUserId;
  ChatHubConnection chatHubConnection;

  List<Chat> get chats => _chats;
  set chats(List<Chat> value) {
    _chats = value;
    notifyListeners();
  }

  void initData() {
    _chats.clear();
    chatMoreAvalible = true;
    currentChat = null;
    _messages.clear();
    messagesMoreAvalible = true;
    _messagesSelected.clear();
    _selectionMode = false;
    localUserId = null;
    if (chatHubConnection != null) chatHubConnection.connection.stop();
  }

  void chatPageDispose() => initData();

  void messagePageDispose() {
    _messages = [];
    currentChat = null;
    _selectionMode = false;
    _messagesSelected = [];
  }

  List<Message> get messages => _messages;
  set messages(List<Message> value) {
    _messages = value;
    notifyListeners();
  }

  List<Message> get messagesSelected => _messagesSelected;
  set messagesSelected(List<Message> value) {
    _messagesSelected = value;
    notifyListeners();
  }

  void addToMessageSelection(Message item) {
    _messagesSelected.add(item);
    notifyListeners();
  }

  void deleteFromMessageSelection(Message item) {
    _messagesSelected.remove(item);
    if (_messagesSelected.length == 0) _selectionMode = false;
    notifyListeners();
  }

  void cancelMessageSelection() {
    _messagesSelected.clear();
    _selectionMode = false;
    notifyListeners();
  }

  bool get selectionMode => _selectionMode;
  set selectionMode(bool value) {
    _selectionMode = value;
    notifyListeners();
  }

  ////////////////{ local Method } ////////////////

  // response of GetChatsInfo
  void receiveChatsInfoCallBack(List<dynamic> param) {
    for (final item in param) {
      _chats.add(Chat.fromJson(item));
    }
    if (param.length == 0) chatMoreAvalible = false;
    notifyListeners();
  }

  void chatsCountUpdatedCallBack(dynamic param) {
    var chat = Chat.fromJson(param);
    if (currentChat != null && currentChat.id == chat.id) chat.unreadCount = 0;
    var oldChatIndex = _chats.indexWhere((element) => element.id == chat.id);
    if (oldChatIndex >= 0) {
      if (_chats[oldChatIndex].latestMessageDate == chat.latestMessageDate) {
        _chats[oldChatIndex] = chat;
      } else {
        _chats.removeAt(oldChatIndex);
        _chats.insert(0, chat);
      }
    } else {
      _chats.insert(0, chat);
    }

    notifyListeners();
  }

  // response of GetChatMessages
  void receiveMessagesCallBack(dynamic param) {
    List<Message> list = [];
    for (final item in param) {
      list.insert(0, Message.fromJson(item));
    }
    _messages.addAll(list);
    if (list.length == 0) messagesMoreAvalible = false;
    notifyListeners();
  }

  // response of SendMessage
  void receiveMessageCallBack(dynamic param) {
    Message msg = Message.fromJson(param);
    log('###### msg.fromUserId : ${msg.fromUserId}');
    log('###### localUserId : ${localUserId ?? ''}');
    if (msg.fromUserId == localUserId) {
      // here sender...
      if (currentChat != null && currentChat.id == msg.toUserId) if (checkLastMsgId(msg)) _messages.insert(0, msg);
      var oldChatIndex = _chats.indexWhere((element) => element.id == msg.toUserId);
      if (oldChatIndex >= 0) {
        Chat chat = _chats[oldChatIndex];
        chat.latestMessageDate = msg.createdDate;
        chat.latestMessageText = msg.message;
        chat.latestMessageFiles = msg.files;
        _chats.removeAt(oldChatIndex);
        _chats.insert(0, chat);
      } else {
        // that's means its a new chat
        getChatsInfo(0);
      }
    } else {
      // here receiver...
      if (currentChat != null && currentChat.id == msg.fromUserId) if (checkLastMsgId(msg)) _messages.insert(0, msg);
    }

    notifyListeners();
  }

  bool checkLastMsgId(Message msg) {
    if (_messages != null && _messages.length > 0)
      return _messages.first.id != msg.id;
    else
      return true;
  }

  ////////////////{ invoke server Method } ////////////////

  void sendMsg(String msg, String img, String receiverId) {
    log('/// chat HubConnection invoke : SendMessage');
    //   String message = 'messsge ';
    //   String images = '';
    //   // String receiverId = '33EB149A-2B1E-4235-2400-08D80D481BF9';
    //   String receiverId = '7FDAE044-FE3E-4F81-DDD7-08D811179AEE';
    chatHubConnection.invokeHubConnectionFunctions('SendMessage', [msg, img, receiverId]);
  }

  void getChatsMessages(String withUid, {int page = 0, String q}) {
    log('/// chat HubConnection invoke : GetChatMessages page :$page  ');
    chatHubConnection.invokeHubConnectionFunctions('GetChatMessages', [withUid, page, q]);
  }

  void readAllChats(String withUid) {
    log('/// chat HubConnection invoke : ReadAllChats');
    chatHubConnection.invokeHubConnectionFunctions('ReadAllChats', [withUid]);
  }

  void getChatsInfo(int page, {String q}) {
    log('/// chat HubConnection invoke : GetChatsInfo : page :$page  &&&&& q :');
    if (q != null || page == 0) {
      _chats.clear();
      notifyListeners();
    }
    chatHubConnection.invokeHubConnectionFunctions('GetChatsInfo', [page, q]);
  }

  void deleteSelectedMessage() {
    log('/// chat HubConnection invoke : DeleteAChat ${_messagesSelected.length.toString()}');
    _messagesSelected.forEach((e) {
      chatHubConnection.invokeHubConnectionFunctions('DeleteAChat', [e.id]);
      _messages.removeWhere((element) => element.id == e.id);
    });
    _messagesSelected.clear();
    _selectionMode = false;
    notifyListeners();
  }

  ////////////////{ connection Method } ////////////////
  Future<void> initChatHubConnection() async {
    if (chatHubConnection == null || !chatHubConnection.isConnected()) {
      chatHubConnection = ChatHubConnection(
        chatsCountUpdatedcallBack: chatsCountUpdatedCallBack,
        receiveChatsInfocallBack: receiveChatsInfoCallBack,
        receiveMessagecallBack: receiveMessageCallBack,
        receiveMessagescallBack: receiveMessagesCallBack,
      );
      await chatHubConnection.openHubConnection();
    }
    if (chatHubConnection.isConnected() && _chats.length == 0) {
      getChatsInfo(0);
    }
  }

  Future<void> closeConnection() async {
    if (chatHubConnection != null && chatHubConnection.isConnected()) await chatHubConnection.connection.stop();
  }
}
