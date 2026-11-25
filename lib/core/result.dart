import 'package:flutter/foundation.dart';
import 'package:lex_copilot/core/errors/failure.dart';

/// Functional outcome type representing either a [Success] value or an [Err] [Failure].
///
/// Used across all domain, data, and AI pipeline boundaries instead of throwing
/// exceptions across layers.
@immutable
sealed class Result<T> {
  const new();

  /// Returns `true` if this result is a [Success].
  bool get isSuccess => this is Success<T>;

  /// Returns `true` if this result is an [Err].
  bool get isErr => this is Err<T>;

  /// Returns the wrapped value if [Success], or `null` otherwise.
  T? get valueOrNull => switch (this) {
    Success(:final value) => value,
    Err() => null,
  };

  /// Returns the wrapped [Failure] if [Err], or `null` otherwise.
  Failure? get failureOrNull => switch (this) {
    Success() => null,
    Err(:final failure) => failure,
  };

  /// Exhaustively transforms both outcomes into a single value [R].
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) => switch (this) {
    Success(:final value) => onSuccess(value),
    Err(:final failure) => onFailure(failure),
  };

  /// Transforms the success value while preserving any [Err].
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
    Success(:final value) => Success(transform(value)),
    Err(:final failure) => Err(failure),
  };

  /// Chains another [Result]-returning computation on [Success].
  Result<R> flatMap<R>(Result<R> Function(T value) transform) => switch (this) {
    Success(:final value) => transform(value),
    Err(:final failure) => Err(failure),
  };

  /// Executes [action] and maps any thrown [Object] to an [Err] via [onError].
  static Future<Result<T>> guard<T>(
    Future<T> Function() action, {
    Failure Function(Object error, StackTrace stackTrace)? onError,
  }) async {
    try {
      return Success(await action());
    } on Object catch (error, stackTrace) {
      return Err(
        onError?.call(error, stackTrace) ??
            UnexpectedFailure(error.toString(), cause: error),
      );
    }
  }
}

/// Successful [Result] holding a [value] of type [T].
final class Success<T> extends Result<T> {
  /// Creates a [Success] wrapping [value].
  const new(this.value);

  /// The successful result value.
  final T value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Success<T> && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';
}

/// Failed [Result] holding a [Failure].
final class Err<T> extends Result<T> {
  /// Creates an [Err] wrapping [failure].
  const new(this.failure);

  /// The domain failure describing why the operation did not succeed.
  final Failure failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Err<T> && other.failure == failure;

  @override
  int get hashCode => failure.hashCode;

  @override
  String toString() => 'Err($failure)';
}
