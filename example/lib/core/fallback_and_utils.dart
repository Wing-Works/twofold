import 'package:twofold/twofold.dart';

/// Demonstrates fallback and utility APIs provided by [Twofold].
///
/// These APIs are commonly used when:
/// - a default value is acceptable
/// - an error needs to be converted into a success
/// - control flow needs to be inverted
///
/// All examples assume the result MAY succeed or fail at runtime.

void main() {
  getOrElseExamples();
  getOrElseGetExamples();
  swapExamples();
}

/// ------------------------------------------------------------
/// getOrElse
/// ------------------------------------------------------------

void getOrElseExamples() {
  final Twofold<int, String> success = Twofold.success(10);
  final Twofold<int, String> error = Twofold.error('failed');

  // Success → original value
  final value1 = success.getOrElse(0);
  print(value1); // 10

  // Error → fallback value
  final value2 = error.getOrElse(0);
  print(value2); // 0
}

/// ------------------------------------------------------------
/// getOrElseGet
/// ------------------------------------------------------------

int expensiveFallback() {
  print('Computing fallback...');
  return 99;
}

void getOrElseGetExamples() {
  final Twofold<int, String> success = Twofold.success(5);
  final Twofold<int, String> error = Twofold.error('network');

  // Success → fallback NOT executed
  final value1 = success.getOrElseGet(expensiveFallback);
  print(value1); // 5

  // Error → fallback executed lazily
  final value2 = error.getOrElseGet(expensiveFallback);
  print(value2); // 99
}

/// ------------------------------------------------------------
/// swap
/// ------------------------------------------------------------

void swapExamples() {
  final Twofold<int, String> success = Twofold.success(42);
  final Twofold<int, String> error = Twofold.error('invalid');

  // Success → becomes Error
  final swappedSuccess = success.swap();
  print(swappedSuccess); // Error(42)

  // Error → becomes Success
  final swappedError = error.swap();
  print(swappedError); // Success(invalid)
}
