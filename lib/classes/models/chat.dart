import 'dart:developer';

class Chat {
  //[{id: 7fdae044-fe3e-4f81-ddd7-08d811179aee, fullName: nourakrry, photo: null, unreadCount: 0,
  //latestMessageDate: 2020-06-16T13:32:17.7658992, latestMessageText: messsge 1}
  String id;
  String fullName;
  String photo;
  int unreadCount;
  String latestMessageDate;
  String latestMessageText;
  String latestMessageFiles;

  Chat({this.id, this.fullName, this.photo, this.unreadCount, this.latestMessageDate, this.latestMessageText, this.latestMessageFiles});

  Chat.fromJson(Map<String, dynamic> json) {
    try {
      id = json['id'];
      fullName = json['fullName'];
      photo = json['photo'];
      unreadCount = json['unreadCount'];
      latestMessageDate = json['latestMessageDate'];
      latestMessageText = json['latestMessageText'];
      latestMessageFiles = json['latestMessageFiles'];
    } catch (err) {
      log(err.toString());
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['photo'] = this.photo;
    data['unreadCount'] = this.unreadCount;
    data['latestMessageDate'] = this.latestMessageDate;
    data['latestMessageText'] = this.latestMessageText;
    data['latestMessageFiles'] = this.latestMessageFiles;
    return data;
  }
}
