import 'failures.dart';
export 'failures.dart';

sealed class Result<T> {
  const Result();

  R fold<R>(
    R Function(Failure failure) onFailure,
    R Function(T data) onSuccess,
  );

  bool get isSuccess => this is Success<T>;
  bool get isError => this is Error<T>;
}

class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);

  @override
  R fold<R>(
    R Function(Failure failure) onFailure,
    R Function(T data) onSuccess,
  ) =>
      onSuccess(data);
}

class Error<T> extends Result<T> {
  final Failure failure;
  const Error(this.failure);

  @override
  R fold<R>(
    R Function(Failure failure) onFailure,
    R Function(T data) onSuccess,
  ) =>
      onFailure(failure);
}
