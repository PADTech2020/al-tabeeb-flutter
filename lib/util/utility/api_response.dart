class ApiResponse {
  String requestId;
  String timeStamp;
  dynamic data;
  bool success;
  List<String> errors;

  ApiResponse({this.requestId = "", this.timeStamp = "", this.data = "", this.success = false, this.errors = const ['']});

  String getErrorsString({String divider = '\n'}) {
    String errorStr = "";
    errors.forEach((err) {
      errorStr += err + " $divider";
    });
    return errorStr;
  }

  void fromJson(Map<String, dynamic> json) {
    try {
      if (json.containsKey('success')) {
        success = json['success'];
        if (success) {
          data = json['data'];
        }
        errors = json['errors'].cast<String>();
        json.containsKey('requestId') ? requestId = json['requestId'] : requestId = "";
        json.containsKey('timeStamp') ? timeStamp = json['timeStamp'] : timeStamp = "";
      } else {
        ////////////////{ login parsing } ////////////////
        if (json.containsKey('error') || json.containsKey('errorDescription') || json.containsKey('error_description')) {
          if (json.containsKey('errorDescription'))
            errors = [json['errorDescription']];
          else if (json.containsKey('error_description'))
            errors = [json['error_description']];
          else if (json.containsKey('error')) errors = [json['error']];
          success = false;
        } else {
          success = true;
        }
        data = json;
      }
    } catch (err) {
      print(err.toString());
      success = false;
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['data'] = this.data;
    data['success'] = this.success;
    data['errors'] = this.errors;
    data['requestId'] = this.requestId;
    data['timeStamp'] = this.timeStamp;
    return data;
  }
}
