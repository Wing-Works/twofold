import 'package:twofold/twofold.dart';

/// This file demonstrates how to TEST `Twofold` values
/// using the provided testing helpers:
///
/// - expectSuccess
/// - expectError
///
/// WHY THESE HELPERS EXIST:
/// - Avoid repetitive `switch` or `if` checks in tests
/// - Fail fast with clear messages
/// - Keep tests focused on business intent
///
/// These helpers are:
/// - framework-agnostic
/// - compatible with `package:test`, `flutter_test`, etc.
///
/// ============================================================

void main() {
  exampleExpectSuccess();
  exampleExpectError();
}

/// ------------------------------------------------------------
/// Example helpers (simulate real code under test)
/// ------------------------------------------------------------

Twofold<int, String> parseInt(String input) {
  final value = int.tryParse(input);
  return value != null
      ? Twofold.success(value)
      : Twofold.error('Invalid number');
}

/// ------------------------------------------------------------
/// Example 1: expectSuccess
/// ------------------------------------------------------------
///
/// Use when:
/// - you EXPECT the result to be a Success
/// - you want to assert on the success value
///
void exampleExpectSuccess() {
  final result = parseInt('42');

  expectSuccess(result, (value) {
    assert(value == 42);
  });

  print('expectSuccess passed');
}

/// ------------------------------------------------------------
/// Example 2: expectError
/// ------------------------------------------------------------
///
/// Use when:
/// - you EXPECT the result to be an Error
/// - you want to assert on the error value
///
void exampleExpectError() {
  final result = parseInt('abc');

  expectError(result, (error) {
    assert(error == 'Invalid number');
  });

  print('expectError passed');
}
