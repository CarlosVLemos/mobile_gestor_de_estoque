sealed class Result<S, F> {
  const Result();

  bool get isSuccess => this is Success<S, F>;
  bool get isFailure => this is Failure<S, F>;

  S? get successOrNull => fold(
        (value) => value,
        (_) => null,
      );

  F? get failureOrNull => fold(
        (_) => null,
        (error) => error,
      );

  T fold<T>(
    T Function(S value) onSuccess,
    T Function(F error) onFailure,
  ) {
    return switch (this) {
      Success<S, F>(:final value) => onSuccess(value),
      Failure<S, F>(:final error) => onFailure(error),
    };
  }
}

class Success<S, F> extends Result<S, F> {
  final S value;
  const Success(this.value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<S, F> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';
}

class Failure<S, F> extends Result<S, F> {
  final F error;
  const Failure(this.error);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<S, F> &&
          runtimeType == other.runtimeType &&
          error == other.error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Failure($error)';
}
