/// Domain-level failure hierarchy used across repositories, pipelines, and UI.
///
/// Exceptions are caught at data boundaries and mapped to a [Failure] so no
/// raw exceptions cross architectural layers.
sealed class Failure {
  /// Creates a [Failure] with a human-readable [message] and optional [cause].
  const new(this.message, {this.code, this.cause});

  /// User-safe error description suitable for display or logging.
  final String message;

  /// Optional machine-readable error code.
  final String? code;

  /// Optional underlying error object (never containing PII).
  final Object? cause;

  @override
  String toString() => 'Failure(code: $code, message: $message)';
}

/// Failure caused by connectivity, timeout, or HTTP transport issues.
final class NetworkFailure extends Failure {
  /// Creates a [NetworkFailure].
  const new(super.message, {super.code, super.cause, this.statusCode});

  /// Optional HTTP status code if a response was received.
  final int? statusCode;
}

/// Failure reading or writing encrypted local storage or preferences.
final class StorageFailure extends Failure {
  /// Creates a [StorageFailure].
  const new(super.message, {super.code, super.cause});
}

/// Failure caused by invalid input, schema mismatch, or missing required fields.
final class ValidationFailure extends Failure {
  /// Creates a [ValidationFailure].
  const new(super.message, {super.code, super.cause});
}

/// Failure due to missing/expired token, biometric lock, or permission denial.
final class AuthFailure extends Failure {
  /// Creates a [AuthFailure].
  const new(super.message, {super.code, super.cause});
}

/// Failure during on-device or cloud AI inference or citation verification.
final class AiFailure extends Failure {
  /// Creates an [AiFailure].
  const new(super.message, {super.code, super.cause});
}

/// Failure when a requested statute section, case file, or item does not exist.
final class NotFoundFailure extends Failure {
  /// Creates a [NotFoundFailure].
  const new(super.message, {super.code, super.cause});
}

/// Fallback failure for unexpected runtime conditions.
final class UnexpectedFailure extends Failure {
  /// Creates an [UnexpectedFailure].
  const new(super.message, {super.code, super.cause});
}
