import 'package:twofold/twofold.dart';

/// Demonstrates transformation and chaining APIs provided by [Twofold].
///
/// This file shows:
/// - transforming success values
/// - transforming error values
/// - chaining dependent operations
/// - how the same API behaves for both states

void main() {
  mapSuccessExamples();
  mapErrorExamples();
  flatMapSuccessExamples();
}

/// ------------------------------------------------------------
/// mapSuccess
/// ------------------------------------------------------------

void mapSuccessExamples() {
  final Twofold<int, String> success = Twofold.success(10);
  final Twofold<int, String> error = Twofold.error('failed');

  // Success → transformed
  final transformedSuccess = success.mapSuccess((v) => v * 2);
  print(transformedSuccess); // Success(20)

  // Error → unchanged
  final transformedError = error.mapSuccess((v) => v * 2);
  print(transformedError); // Error(failed)
}

/// ------------------------------------------------------------
/// mapError
/// ------------------------------------------------------------

void mapErrorExamples() {
  final Twofold<int, String> success = Twofold.success(5);
  final Twofold<int, String> error = Twofold.error('404');

  // Error → transformed
  final transformedError = error.mapError((e) => 'Error code: $e');
  print(transformedError); // Error(Error code: 404)

  // Success → unchanged
  final transformedSuccess = success.mapError((e) => 'Error code: $e');
  print(transformedSuccess); // Success(5)
}

/// ------------------------------------------------------------
/// flatMapSuccess
/// ------------------------------------------------------------

Twofold<int, String> parseNumber(String input) {
  final parsed = int.tryParse(input);
  return parsed != null
      ? Twofold.success(parsed)
      : Twofold.error('Invalid number');
}

void flatMapSuccessExamples() {
  final Twofold<String, String> success = Twofold.success('10');

  final Twofold<String, String> error = Twofold.error('network failure');

  // Success → chained operation
  final result1 = success.flatMapSuccess(parseNumber);
  print(result1); // Success(10)

  // Error → chain is skipped
  final result2 = error.flatMapSuccess(parseNumber);
  print(result2); // Error(network failure)
}
