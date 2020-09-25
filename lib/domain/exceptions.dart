class AppException implements Exception {
  final _message;
  
AppException([this._message]);
  
String toString() {
    return "$_message";
  }
}

class FetchDataException extends AppException {
  // communication error
  FetchDataException([String message])
      : super(message);
}

class UnauthorisedException extends AppException {
  // Unauthorised 
  UnauthorisedException([message]) : super(message);

}

class InternalServerError extends AppException{
  InternalServerError([message]) : super("Internal Server Error");
}

