import 'package:test/test.dart';

import '../core/twofold.dart';

/// Asserts that the [result] is a [Success] and provides
/// the success value for further expectations.
///
/// Example:
/// ```dart
/// expectSuccess(result, (value) {
///   expect(value, 42);
/// });
/// ```
void expectSuccess<S, E>(
  Twofold<S, E> result,
  void Function(S value) verify,
) {
  switch (result) {
    case Success(:final value):
      verify(value);
    case Error(:final error):
      throw TestFailure(
        'Expected Success but got Error($error)',
      );
  }
}

/// Asserts that the [result] is an [Error] and provides
/// the error value for further expectations.
///
/// Example:
/// ```dart
/// expectError(result, (error) {
///   expect(error, 'Invalid input');
/// });
/// ```
void expectError<S, E>(
  Twofold<S, E> result,
  void Function(E error) verify,
) {
  switch (result) {
    case Error(:final error):
      verify(error);
    case Success(:final value):
      throw TestFailure(
        'Expected Error but got Success($value)',
      );
  }
}
