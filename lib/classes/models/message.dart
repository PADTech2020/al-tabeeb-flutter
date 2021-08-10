class Message {
//   {id: 33, createdDate: 2020-06-17T08:57:23.6995073Z, toUserId: 7fdae044-fe3e-4f81-ddd7-08d811179aee, toUser: nourakarry@gmail.com,
// fromUserId: 8314b546-ade3-4118-2401-08d80d481bf9, fromUser: user@syr-aw.com, message: messsge 3,files: , viewDate: null, isRead: false}
  int id;
  String toUserId;
  String toUser;
  String fromUserId;
  String fromUser;
  String message;
  String files;
  String createdDate;
  String viewDate;
  bool isRead;

  Message(
    this.id,
    this.toUserId,
    this.toUser,
    this.fromUserId,
    this.fromUser,
    this.message,
    this.files,
    this.createdDate,
    this.viewDate,
    this.isRead,
  );

  Message.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    toUserId = json['toUserId'];
    toUser = json['toUser'];
    fromUserId = json['fromUserId'];
    fromUser = json['fromUser'];
    message = json['message'];
    files = json['files'];
    createdDate = json['createdDate'];
    viewDate = json['viewDate'];
    isRead = json['isRead'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    return data;
  }
}
