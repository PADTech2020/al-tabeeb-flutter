class AvailabilityPlans {
  int id;
  String doctorId;
  int dayOfWeek;
  String dayOfWeekString;
  int fromHour;
  String fromHourString;
  int toHour;
  String toHourString;
  bool isActive;

  AvailabilityPlans(
      {this.id,
      this.doctorId,
      this.dayOfWeek,
      this.dayOfWeekString,
      this.fromHour,
      this.fromHourString,
      this.toHour,
      this.toHourString,
      this.isActive});

  AvailabilityPlans.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorId = json['doctorId'];
    dayOfWeek = json['dayOfWeek'];
    dayOfWeekString = json['dayOfWeekString'];
    fromHour = json['fromHour'];
    fromHourString = json['fromHourString'];
    toHour = json['toHour'];
    toHourString = json['toHourString'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['doctorId'] = this.doctorId;
    data['dayOfWeek'] = this.dayOfWeek;
    data['dayOfWeekString'] = this.dayOfWeekString;
    data['fromHour'] = this.fromHour;
    data['fromHourString'] = this.fromHourString;
    data['toHour'] = this.toHour;
    data['toHourString'] = this.toHourString;
    data['isActive'] = this.isActive;
    return data;
  }
}
