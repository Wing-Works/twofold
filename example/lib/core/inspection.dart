import 'package:twofold/twofold.dart';

/// Demonstrates all state inspection and value access APIs
/// provided by [Twofold].
///
/// This file shows:
/// - how to check the current state
/// - how safe accessors behave
/// - how unsafe accessors behave
/// - correct and incorrect usage patterns
///
/// The examples intentionally include both success and error
/// cases to show how the same API behaves differently
/// depending on the internal state.

void main() {
  stateChecks();
  safeAccessors();
  unsafeAccessors();
}

/// ------------------------------------------------------------
/// State inspection
/// ------------------------------------------------------------

void stateChecks() {
  final Twofold<int, String> success = Twofold.success(10);
  final Twofold<int, String> error = Twofold.error('failed');

  // isSuccess / isError reflect the current state
  print(success.isSuccess); // true
  print(success.isError); // false

  print(error.isSuccess); // false
  print(error.isError); // true
}

/// ------------------------------------------------------------
/// Safe accessors
/// ------------------------------------------------------------

void safeAccessors() {
  final Twofold<int, String> success = Twofold.success(5);
  final Twofold<int, String> error = Twofold.error('oops');

  // successOrNull
  print(success.successOrNull); // 5
  print(error.successOrNull); // null

  // errorOrNull
  print(success.errorOrNull); // null
  print(error.errorOrNull); // oops
}

/// ------------------------------------------------------------
/// Unsafe accessors
/// ------------------------------------------------------------

void unsafeAccessors() {
  final Twofold<int, String> success = Twofold.success(1);
  final Twofold<int, String> error = Twofold.error('boom');

  // Correct usage: access only when state is known
  if (success.isSuccess) {
    print(success.successUnsafe); // safe
  }

  if (error.isError) {
    print(error.errorUnsafe); // safe
  }

  // Incorrect usage (do NOT do this):
  // success.errorUnsafe; // throws StateError
  // error.successUnsafe; // throws StateError
}
