class CustomException implements Exception {
  final message;
  final prefix;

  CustomException([this.message, this.prefix = 'Error During Communication']);

  @override
  String toString() {
    //return "$prefix \n $message";
    return "$message";
  }
}

class GeneralException extends CustomException {
  GeneralException([String message]) : super(message, "Error !! ");
}

class FetchDataException extends CustomException {
  FetchDataException([String message]) : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends CustomException {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String message]) : super(message, "Invalid Input: ");
}
