/// A type that represents either a successful value [S]
/// or an error value [E].
///
/// `Twofold` is a sealed hierarchy with exactly two possible states:
/// - [Success] containing a success value
/// - [Error] containing an error value
///
/// This design guarantees:
/// - no invalid state
/// - clear intent
/// - strong typing
///
/// Example:
/// ```dart
/// Twofold<int, String> result = Success(10);
///
/// switch (result) {
///   case Success(:final value):
///     print('Success: $value');
///   case Error(:final error):
///     print('Error: $error');
/// }
/// ```
sealed class Twofold<S, E> {
  const Twofold();

  /// Returns `true` if this is a [Success].
  ///
  /// Example:
  /// ```dart
  /// if (result.isSuccess) {
  ///   print('Operation succeeded');
  /// }
  /// ```
  bool get isSuccess => this is Success<S, E>;

  /// Returns `true` if this is an [Error].
  ///
  /// Example:
  /// ```dart
  /// if (result.isError) {
  ///   print('Operation failed');
  /// }
  /// ```
  bool get isError => this is Error<S, E>;

  /// Returns the success value if present, otherwise `null`.
  ///
  /// This is a **safe** accessor and will never throw.
  ///
  /// Example:
  /// ```dart
  /// final value = result.successOrNull;
  /// if (value != null) {
  ///   print('Success: $value');
  /// }
  /// ```
  S? get successOrNull {
    return switch (this) {
      Success(:final value) => value,
      _ => null,
    };
  }

  /// Returns the error value if present, otherwise `null`.
  ///
  /// This is a **safe** accessor and will never throw.
  ///
  /// Example:
  /// ```dart
  /// final error = result.errorOrNull;
  /// if (error != null) {
  ///   print('Error: $error');
  /// }
  /// ```
  E? get errorOrNull {
    return switch (this) {
      Error(:final error) => error,
      _ => null,
    };
  }

  /// Returns the success value if this is a [Success].
  ///
  /// Throws a [StateError] if this is an [Error].
  ///
  /// Use this only when you are **logically certain**
  /// that the value is a success.
  ///
  /// Example:
  /// ```dart
  /// final value = result.successUnsafe;
  /// ```
  S get successUnsafe {
    return switch (this) {
      Success(:final value) => value,
      Error() =>
        throw StateError('Tried to access success value from an Error'),
    };
  }

  /// Returns the error value if this is an [Error].
  ///
  /// Throws a [StateError] if this is a [Success].
  ///
  /// Use this only when you are **logically certain**
  /// that the value is an error.
  ///
  /// Example:
  /// ```dart
  /// final error = result.errorUnsafe;
  /// ```
  E get errorUnsafe {
    return switch (this) {
      Error(:final error) => error,
      Success() =>
        throw StateError('Tried to access error value from a Success'),
    };
  }

  /// Handles the value contained in this [Twofold].
  ///
  /// This method is intentionally flexible and can be used in two ways:
  ///
  /// **1. For side effects**
  /// (handle success or error without returning a value)
  ///
  /// **2. For value transformation**
  /// (convert the result into another value, similar to a traditional `fold`)
  ///
  /// Both callbacks are optional:
  /// - If a callback is not provided, it will be skipped.
  /// - If neither callback is provided, this method returns `null`.
  ///
  /// ---
  ///
  /// ### Example: Side effects
  /// ```dart
  /// result.when(
  ///   onSuccess: (value) => print('Success: $value'),
  ///   onError: (err) => print('Error: $err'),
  /// );
  /// ```
  ///
  /// ### Example: Returning a value
  /// ```dart
  /// final message = result.when(
  ///   onSuccess: (value) => 'Got $value',
  ///   onError: (err) => 'Failed: $err',
  /// );
  /// ```
  ///
  /// ### Example: Partial handling
  /// ```dart
  /// result.when(
  ///   onError: (err) => showError(err),
  /// );
  /// ```
  T? when<T>({
    T Function(S success)? onSuccess,
    T Function(E error)? onError,
  }) {
    return switch (this) {
      Success(:final value) => onSuccess != null ? onSuccess(value) : null,
      Error(:final error) => onError != null ? onError(error) : null,
    };
  }
}

/// Represents a successful outcome containing a value of type [S].
///
/// Example:
/// ```dart
/// final result = Success<int, String>(42);
/// print(result.value); // 42
/// ```
final class Success<S, E> extends Twofold<S, E> {
  /// Creates a successful [Twofold].
  const Success(this.value);

  /// The successful value.
  final S value;

  @override
  String toString() => 'Success($value)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Success<S, E> && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

/// Represents a failed outcome containing an error of type [E].
///
/// Example:
/// ```dart
/// final result = Error<int, String>('Invalid input');
/// print(result.error); // Invalid input
/// ```
final class Error<S, E> extends Twofold<S, E> {
  /// Creates a failed [Twofold].
  const Error(this.error);

  /// The error value.
  final E error;

  @override
  String toString() => 'Error($error)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Error<S, E> && other.error == error;

  @override
  int get hashCode => error.hashCode;
}
