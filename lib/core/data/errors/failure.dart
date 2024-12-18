abstract interface class Failure {
  final String message;

  Failure(this.message);
}

class ImportFailure extends Failure {
  final List<String> errors;

  ImportFailure({
    required String message,
    required this.errors,
  }) : super(message);
}

class ExportFailure extends Failure {
  ExportFailure({required String message}) : super(message);
}

class AuthFailure extends Failure {
  AuthFailure(super.message);
}

class DatabaseNotInitializedFailure extends Failure {
  DatabaseNotInitializedFailure(super.message);
}

class CreateFailure extends Failure {
  CreateFailure({required String message}) : super(message);
}

class UnknownFailure extends Failure {
  UnknownFailure({required String message}) : super(message);
}
