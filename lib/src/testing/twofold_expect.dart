import 'package:meta/meta.dart';
import 'package:twofold/src/core/twofold.dart';

/// Asserts that the [result] is a [Success] and provides
/// the success value for further verification.
///
/// This helper is framework-agnostic and works with
/// `package:test`, `flutter_test`, and other test tools.
///
/// Example:
/// ```dart
/// expectSuccess(result, (value) {
///   expect(value, 42);
/// });
/// ```
@isTest
void expectSuccess<S, E>(
  Twofold<S, E> result,
  void Function(S value) verify,
) {
  switch (result) {
    case Success(:final value):
      verify(value);
    case Error(:final error):
      throw AssertionError(
        'Expected Success but got Error($error)',
      );
  }
}

/// Asserts that the [result] is an [Error] and provides
/// the error value for further verification.
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
      throw AssertionError(
        'Expected Error but got Success($value)',
      );
  }
}
