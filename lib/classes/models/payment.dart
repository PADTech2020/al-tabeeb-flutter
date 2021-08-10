import 'user.dart';

import 'meeting.dart';

class Payment {
  int id;
  User doctor;
  String doctorId;
  double amount;
  String createdDate;
  String receipt;
  List<Meeting> meetings;
  String meetingsString;
  double meetingsTotalValue;
  Null meetingIds;

  Payment(
      {this.id,
      this.doctor,
      this.doctorId,
      this.amount,
      this.createdDate,
      this.receipt,
      this.meetings,
      this.meetingsString,
      this.meetingsTotalValue,
      this.meetingIds});

  Payment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctor = json['doctor'];
    doctorId = json['doctorId'];
    amount = json['amount'];
    createdDate = json['createdDate'];
    receipt = json['receipt'];
    if (json['meetings'] != null) {
      meetings = [];
      json['meetings'].forEach((v) {
        meetings.add(new Meeting.fromJson(v));
      });
    }
    meetingsString = json['meetingsString'];
    meetingsTotalValue = json['meetingsTotalValue'];
    meetingIds = json['meetingIds'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doctor'] = this.doctor;
    data['doctorId'] = this.doctorId;
    data['amount'] = this.amount;
    data['createdDate'] = this.createdDate;
    data['receipt'] = this.receipt;
    if (this.meetings != null) {
      data['meetings'] = this.meetings.map((v) => v.toJson()).toList();
    }
    data['meetingsString'] = this.meetingsString;
    data['meetingsTotalValue'] = this.meetingsTotalValue;
    data['meetingIds'] = this.meetingIds;
    return data;
  }
}
