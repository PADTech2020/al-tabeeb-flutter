import 'user.dart';

enum MeetingType { Video, Voice, Chat }

class Meeting {
  int id;
  String userId;
  User user;
  String doctorId;
  User doctor;
  String meetingDateTime;
  double price;
  int meetingDurationId;
  int durationInMinutes;
  String finishDateTime;
  String startedDateTime;
  String finishedDateTime;
  double usedDurationInMinutes;
  int meetingType;
  String meetingTypeString;
  int orderStatus;
  int paymentMethod;
  String physicalMeetingDate;

  Meeting({
    this.id,
    this.userId,
    this.user,
    this.doctorId,
    this.doctor,
    this.meetingDateTime,
    this.price,
    this.meetingDurationId,
    this.durationInMinutes,
    this.finishDateTime,
    this.startedDateTime,
    this.finishedDateTime,
    this.usedDurationInMinutes,
    this.meetingType,
    this.meetingTypeString,
    this.orderStatus,
    this.paymentMethod,
    this.physicalMeetingDate,
  });

  Meeting.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['userId'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    doctorId = json['doctorId'];
    doctor = json['doctor'] != null ? new User.fromJson(json['doctor']) : null;
    meetingDateTime = json['meetingDateTime'];
    price = json['price'].toDouble();
    meetingDurationId = json['meetingDurationId'];
    durationInMinutes = json['durationInMinutes'];
    finishDateTime = json['finishDateTime'];
    startedDateTime = json['startedDateTime'];
    finishedDateTime = json['finishedDateTime'];
    usedDurationInMinutes = json['usedDurationInMinutes'].toDouble();
    meetingType = json['meetingType'];
    meetingTypeString = json['meetingTypeString'];
    orderStatus = json['orderStatus'];
    paymentMethod = json['paymentMethod'];
    physicalMeetingDate = json['physicalMeetingDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['userId'] = this.userId;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    data['doctorId'] = this.doctorId;
    if (this.doctor != null) {
      data['doctor'] = this.doctor.toJson();
    }
    data['meetingDateTime'] = this.meetingDateTime;
    data['price'] = this.price;
    data['meetingDurationId'] = this.meetingDurationId;
    data['durationInMinutes'] = this.durationInMinutes;
    data['finishDateTime'] = this.finishDateTime;
    data['startedDateTime'] = this.startedDateTime;
    data['finishedDateTime'] = this.finishedDateTime;
    data['usedDurationInMinutes'] = this.usedDurationInMinutes;
    data['meetingType'] = this.meetingType;
    data['meetingTypeString'] = this.meetingTypeString;
    data['orderStatus'] = this.orderStatus;
    data['paymentMethod'] = this.paymentMethod;
    data['physicalMeetingDate'] = this.physicalMeetingDate;

    return data;
  }
}
