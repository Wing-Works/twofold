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

  /// Creates a successful [Twofold] containing [value].
  ///
  /// Use this when you want to explicitly return a success result.
  ///
  /// Example:
  /// ```dart
  /// final result = Twofold.success(42);
  /// ```
  factory Twofold.success(S value) = Success<S, E>;

  /// Creates an error [Twofold] containing [error].
  ///
  /// Use this when an operation fails and you want to return
  /// a meaningful error value.
  ///
  /// Example:
  /// ```dart
  /// final result = Twofold.error('Invalid input');
  /// ```
  factory Twofold.error(E error) = Error<S, E>;

  /// Creates a [Twofold] based on a boolean [condition].
  ///
  /// Only the matching branch is evaluated:
  /// - If [condition] is `true`, [success] is executed.
  /// - If [condition] is `false`, [error] is executed.
  ///
  /// This makes the method safe for expensive computations
  /// and validation logic.
  ///
  /// Example:
  /// ```dart
  /// final result = Twofold.fromCondition(
  ///   age >= 18,
  ///   success: () => age,
  ///   error: () => 'User must be 18+',
  /// );
  /// ```
  static Twofold<S, E> fromCondition<S, E>(
    bool condition, {
    required S Function() success,
    required E Function() error,
  }) {
    return condition ? Success<S, E>(success()) : Error<S, E>(error());
  }

  /// Executes [action] and captures any thrown exception as an [Error].
  ///
  /// This prevents exceptions from escaping and converts them
  /// into a typed error value.
  ///
  /// Example:
  /// ```dart
  /// final result = Twofold.tryCatch(
  ///   () => int.parse(input),
  ///   onError: (e, _) => 'Invalid number',
  /// );
  /// ```
  static Twofold<S, E> tryCatch<S, E>(
    S Function() action, {
    required E Function(Object error, StackTrace stackTrace) onError,
  }) {
    try {
      return Success<S, E>(action());
    } catch (e, st) {
      return Error<S, E>(onError(e, st));
    }
  }

  /// Returns the success value if present, otherwise [defaultValue].
  ///
  /// Example:
  /// ```dart
  /// final result = Twofold.error('Failed');
  ///
  /// final value = result.getOrElse(0); // 0
  /// ```
  S getOrElse(S defaultValue) {
    return switch (this) {
      Success(:final value) => value,
      Error() => defaultValue,
    };
  }

  /// Returns the success value if present, otherwise computes a fallback.
  ///
  /// Use this when the fallback is expensive to compute.
  ///
  /// Example:
  /// ```dart
  /// final result = Twofold.error('No cache');
  ///
  /// final value = result.getOrElseGet(() => fetchFromServer());
  /// ```
  S getOrElseGet(S Function() fallback) {
    return switch (this) {
      Success(:final value) => value,
      Error() => fallback(),
    };
  }

  /// Returns `true` if this is a [Success].
  ///
  /// This is useful for simple branching when you do not
  /// need to extract the value.
  ///
  /// Example:
  /// ```dart
  /// final result = Twofold.success(10);
  ///
  /// if (result.isSuccess) {
  ///   print('Operation succeeded');
  /// }
  /// ```
  bool get isSuccess => this is Success<S, E>;

  /// Returns `true` if this is an [Error].
  ///
  /// Example:
  /// ```dart
  /// final result = Twofold.error('Invalid input');
  ///
  /// if (result.isError) {
  ///   print('Operation failed');
  /// }
  /// ```
  bool get isError => this is Error<S, E>;

  /// Returns the success value if present, otherwise `null`.
  ///
  /// This is a safe alternative to [successUnsafe].
  ///
  /// Example:
  /// ```dart
  /// final result = Twofold.success(42);
  ///
  /// final value = result.successOrNull;
  /// if (value != null) {
  ///   print('Value: $value');
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
  /// This is a safe alternative to [errorUnsafe].
  ///
  /// Example:
  /// ```dart
  /// final result = Twofold.error('Network error');
  ///
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
  /// ⚠️ Throws a [StateError] if this is an [Error].
  ///
  /// Use this only when you are **logically certain**
  /// the value is a success.
  ///
  /// Example:
  /// ```dart
  /// final result = Twofold.success(10);
  /// final value = result.successUnsafe; // 10
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
  /// ⚠️ Throws a [StateError] if this is a [Success].
  ///
  /// Example:
  /// ```dart
  /// final result = Twofold.error('Invalid token');
  /// final error = result.errorUnsafe; // 'Invalid token'
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

  /// Transforms the success value of this [Twofold] if present.
  ///
  /// - If this is a [Success], the [transform] function is applied
  ///   and the result is wrapped in a new [Success].
  /// - If this is an [Error], the error is preserved unchanged.
  ///
  /// This method never throws and never changes the success/error state.
  ///
  /// Example:
  /// ```dart
  /// final result = Success<int, String>(10)
  ///     .mapSuccess((v) => v * 2);
  ///
  /// // Result: Success(20)
  /// ```
  Twofold<T, E> mapSuccess<T>(T Function(S value) transform) {
    return switch (this) {
      Success(:final value) => Success<T, E>(transform(value)),
      Error(:final error) => Error<T, E>(error),
    };
  }

  /// Transforms the error value of this [Twofold] if present.
  ///
  /// - If this is an [Error], the [transform] function is applied
  ///   and the result is wrapped in a new [Error].
  /// - If this is a [Success], the success value is preserved unchanged.
  ///
  /// This method never throws and never changes the success/error state.
  ///
  /// Example:
  /// ```dart
  /// final result = Error<int, String>('404')
  ///     .mapError((e) => int.parse(e));
  ///
  /// // Result: Error(404)
  /// ```
  Twofold<S, T> mapError<T>(T Function(E error) transform) {
    return switch (this) {
      Error(:final error) => Error<S, T>(transform(error)),
      Success(:final value) => Success<S, T>(value),
    };
  }

  /// Chains another operation that returns a [Twofold] when this is a [Success].
  ///
  /// - If this is a [Success], [transform] is applied and its result is returned.
  /// - If this is an [Error], the error is preserved unchanged.
  ///
  /// This is useful for composing multiple dependent operations
  /// that can each succeed or fail.
  ///
  /// Example:
  /// ```dart
  /// Twofold<int, String> parse(String input) {
  ///   final value = int.tryParse(input);
  ///   return value != null
  ///       ? Success(value)
  ///       : Error('Invalid number');
  /// }
  ///
  /// final result = Success<String, String>('10')
  ///     .flatMapSuccess(parse);
  ///
  /// // Result: Success(10)
  /// ```
  Twofold<T, E> flatMapSuccess<T>(
    Twofold<T, E> Function(S value) transform,
  ) {
    return switch (this) {
      Success(:final value) => transform(value),
      Error(:final error) => Error<T, E>(error),
    };
  }

  /// Swaps the success and error sides of this [Twofold].
  ///
  /// - A [Success] becomes an [Error] with the same value.
  /// - An [Error] becomes a [Success] with the same value.
  ///
  /// This is useful when you want to reverse the meaning
  /// of a result for alternate flows or validations.
  ///
  /// Example:
  /// ```dart
  /// final result = Twofold.success(10);
  /// final swapped = result.swap();
  ///
  /// // swapped is Error(10)
  /// ```
  Twofold<E, S> swap() {
    return switch (this) {
      Success(:final value) => Error<E, S>(value),
      Error(:final error) => Success<E, S>(error),
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

  /// Returns a readable string representation.
  ///
  /// Example:
  /// ```dart
  /// print(Success(10)); // Success(10)
  /// ```
  @override
  String toString() => 'Success($value)';

  /// Compares two [Success] instances by their values.
  ///
  /// Example:
  /// ```dart
  /// expect(Success(1) == Success(1), true);
  /// ```
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Success<S, E> && other.value == value;

  /// Returns a hash code based on the success value.
  ///
  /// This ensures that two [Success] instances containing equal
  /// values produce the same hash code.
  ///
  /// This is required to maintain consistency with [operator ==]
  /// when using [Twofold] in hashed collections such as
  /// [Set] or [Map].
  ///
  /// Example:
  /// ```dart
  /// final a = Success<int, String>(10);
  /// final b = Success<int, String>(10);
  ///
  /// print(a == b); // true
  /// print(a.hashCode == b.hashCode); // true
  /// ```
  @override
  int get hashCode => Object.hash(runtimeType, value);
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

  /// Returns a readable string representation.
  ///
  /// Example:
  /// ```dart
  /// print(Error('oops')); // Error(oops)
  /// ```
  @override
  String toString() => 'Error($error)';

  /// Compares two [Error] instances by their error values.
  ///
  /// Example:
  /// ```dart
  /// expect(Error('x') == Error('x'), true);
  /// ```
  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Error<S, E> && other.error == error;

  /// Returns a hash code based on the error value.
  ///
  /// This ensures that two [Error] instances containing equal
  /// error values produce the same hash code.
  ///
  /// This is required to maintain consistency with [operator ==]
  /// when using [Twofold] in hashed collections such as
  /// [Set] or [Map].
  ///
  /// Example:
  /// ```dart
  /// final a = Error<int, String>('oops');
  /// final b = Error<int, String>('oops');
  ///
  /// print(a == b); // true
  /// print(a.hashCode == b.hashCode); // true
  /// ```
  @override
  int get hashCode => Object.hash(runtimeType, error);
}
