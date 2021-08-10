class NotificationClass {
  int id;
  String title;
  String text;
  String viewDate;
  String createdDate;

  NotificationClass({this.id, this.title, this.text, this.viewDate, this.createdDate});

  NotificationClass.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    text = json['text'];
    viewDate = json['viewDate'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['text'] = this.text;
    data['viewDate'] = this.viewDate;
    data['createdDate'] = this.createdDate;
    return data;
  }
}

class NotificationPayload {
  int id;
  String title;
  String text;
  String image;
  String url;
  String topic;
  String entity;
  String entityId;
  String entityData;
  String createdDate;

  NotificationPayload({
    this.id,
    this.title,
    this.text,
    this.image,
    this.url,
    this.topic,
    this.entity,
    this.entityId,
    this.entityData,
    this.createdDate,
  });

  NotificationPayload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    text = json['text'];
    image = json['image'];
    url = json['url'];
    topic = json['topic'];
    entity = json['entity'];
    entityId = json['entityId'];
    entityData = json['entityData'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['text'] = this.text;
    data['image'] = this.image;
    data['url'] = this.url;
    data['topic'] = this.topic;
    data['entity'] = this.entity;
    data['entityId'] = this.entityId;
    data['entityData'] = this.entityData;
    data['createdDate'] = this.createdDate;
    return data;
  }

  // public enum NotificationEntity
  //   {
  //       Ad = 0,
  //       Category = 1,
  //       ChatMessage = 2,
  //       Currency = 3,
  //       ExternalLink = 4,
  //       GlobalNotification = 5,
  //       Golden = 6,
  //       Prayer = 7,
  //       User = 8,
  //       Shop = 9,
  //       Product = 10
  //   }
}
