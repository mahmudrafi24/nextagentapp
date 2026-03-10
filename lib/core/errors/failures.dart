sealed class Failure {
  final String message;
  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection']);
}

class ApiFailure extends Failure {
  final int? statusCode;
  const ApiFailure(super.message, {this.statusCode});
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local storage error']);
}

class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}
