class Nationalities {
  int nationality;
  String nationalityString;

  Nationalities({this.nationality, this.nationalityString});

  Nationalities.fromJson(Map<String, dynamic> json) {
    nationality = json['nationality'];
    nationalityString = json['nationalityString'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nationality'] = this.nationality;
    data['nationalityString'] = this.nationalityString;
    return data;
  }

  @override
  String toString() {
    return nationalityString;
  }
}
