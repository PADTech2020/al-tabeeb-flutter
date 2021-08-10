class MeetingPrices {
  String doctorId;
  int meetingDurationId;
  MeetingDuration meetingDuration;
  double videoPrice;
  double audioPrice;
  double chatPrice;
  bool isActive;

  MeetingPrices({this.doctorId, this.meetingDurationId, this.meetingDuration, this.videoPrice, this.audioPrice, this.chatPrice, this.isActive});

  MeetingPrices.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    meetingDurationId = json['meetingDurationId'];
    meetingDuration = json['meetingDuration'] != null ? new MeetingDuration.fromJson(json['meetingDuration']) : null;
    videoPrice = json['videoPrice'].toDouble();
    audioPrice = json['audioPrice'].toDouble();
    chatPrice = json['chatPrice'].toDouble();
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['doctorId'] = this.doctorId;
    data['meetingDurationId'] = this.meetingDurationId;
    if (this.meetingDuration != null) {
      data['meetingDuration'] = this.meetingDuration.toJson();
    }
    data['videoPrice'] = this.videoPrice;
    data['audioPrice'] = this.audioPrice;
    data['chatPrice'] = this.chatPrice;
    data['isActive'] = this.isActive;
    return data;
  }

  @override
  String toString() {
    return meetingDuration.durationInMinutes.toString();
  }
}

class MeetingDuration {
  int id;
  int durationInMinutes;
  int videoMinPrice;
  int videoMaxPrice;
  int audioMinPrice;
  int audioMaxPrice;
  int chatMinPrice;
  int chatMaxPrice;

  MeetingDuration(
      {this.id,
      this.durationInMinutes,
      this.videoMinPrice,
      this.videoMaxPrice,
      this.audioMinPrice,
      this.audioMaxPrice,
      this.chatMinPrice,
      this.chatMaxPrice});

  MeetingDuration.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    durationInMinutes = json['durationInMinutes'];
    videoMinPrice = json['videoMinPrice'];
    videoMaxPrice = json['videoMaxPrice'];
    audioMinPrice = json['audioMinPrice'];
    audioMaxPrice = json['audioMaxPrice'];
    chatMinPrice = json['chatMinPrice'];
    chatMaxPrice = json['chatMaxPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['durationInMinutes'] = this.durationInMinutes;
    data['videoMinPrice'] = this.videoMinPrice;
    data['videoMaxPrice'] = this.videoMaxPrice;
    data['audioMinPrice'] = this.audioMinPrice;
    data['audioMaxPrice'] = this.audioMaxPrice;
    data['chatMinPrice'] = this.chatMinPrice;
    data['chatMaxPrice'] = this.chatMaxPrice;
    return data;
  }
}
