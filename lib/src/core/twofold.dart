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
