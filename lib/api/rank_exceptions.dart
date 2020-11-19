const error = "E";

class RankExceptions implements Exception {
  final errorMessage;
  final errorType;

  String toString() {
    return "$errorType: $errorMessage";
  }

  RankExceptions({this.errorMessage, this.errorType});
}

class SchemaValidationError extends RankExceptions {
  SchemaValidationError([String message])
      : super(errorMessage: message, errorType: 'Bad Request');
}

class InvalidPageError extends RankExceptions {
  InvalidPageError([String message])
      : super(errorMessage: message, errorType: 'Accessing invalid page');
}

class UnauthorizedError extends RankExceptions {
  UnauthorizedError([String message])
      : super(errorMessage: message, errorType: 'Unauthorized Request');
}

class AuthenticationError extends RankExceptions {
  AuthenticationError([String message])
      : super(errorMessage: message, errorType: 'Invalid Authentication');
}

class DefaultError extends RankExceptions {
  DefaultError([String message])
      : super(errorMessage: message, errorType: 'Other');
}
