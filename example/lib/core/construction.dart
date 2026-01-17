import 'package:twofold/twofold.dart';

/// This file demonstrates how to CREATE Twofold values.
///
/// It focuses only on construction:
/// - success
/// - error
/// - fromCondition
/// - tryCatch
///
/// No transformations or async flows here.

void main() {
  basicConstruction();
  conditionalConstruction();
  exceptionSafeConstruction();
}

/// ------------------------------------------------------------
/// Basic construction
/// ------------------------------------------------------------

void basicConstruction() {
  // Creating a successful result
  final Twofold<int, String> success = Twofold.success(42);

  // Creating an error result
  final Twofold<int, String> error = Twofold.error('Something went wrong');

  print(success); // Success(42)
  print(error); // Error(Something went wrong)
}

/// ------------------------------------------------------------
/// Conditional construction
/// ------------------------------------------------------------

void conditionalConstruction() {
  final age = 16;

  final result = Twofold.fromCondition<int, String>(
    age >= 18,
    success: () => age,
    error: () => 'User must be at least 18',
  );

  result.when(
    onSuccess: (value) => print('Allowed: $value'),
    onError: (err) => print('Denied: $err'),
  );
}

/// ------------------------------------------------------------
/// Exception-safe construction
/// ------------------------------------------------------------

void exceptionSafeConstruction() {
  final input = 'abc';

  final result = Twofold.tryCatch<int, String>(
    () => int.parse(input),
    onError: (error, _) => 'Invalid number format',
  );

  result.when(
    onSuccess: (value) => print('Parsed: $value'),
    onError: (err) => print('Error: $err'),
  );
}
