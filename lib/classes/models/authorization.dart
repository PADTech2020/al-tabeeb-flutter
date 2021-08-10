class Authorization {
  String tokenType;
  String accessToken;
  String expiresIn;
  String refreshToken;

  Authorization({this.tokenType, this.accessToken, this.expiresIn, this.refreshToken});

  Authorization.fromJson(Map<String, dynamic> json) {
    tokenType = json['token_type'];
    accessToken = json['access_token'];
    if (json['expires_in'] is num) {
      int ex = json['expires_in'];
      //toIso8601String => 2020-04-28T00:00:00
      expiresIn = DateTime.now().add(Duration(seconds: ex)).toIso8601String();
    } else {
      expiresIn = json['expires_in'];
    }
    if (json.containsKey('refresh_token')) refreshToken = json['refresh_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token_type'] = this.tokenType;
    data['access_token'] = this.accessToken;
    data['expires_in'] = this.expiresIn;
    data['refresh_token'] = this.refreshToken;
    return data;
  }
}
