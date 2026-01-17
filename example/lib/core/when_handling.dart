import 'package:twofold/twofold.dart';

/// Demonstrates all supported usages of the `when` API.
///
/// This file shows:
/// - handling both states
/// - using `when` for side effects
/// - using `when` to return values
/// - partial handling
/// - null behavior when no callback matches

void main() {
  handleBothStates();
  sideEffectsOnly();
  returningValues();
  partialHandling();
  noCallbacksProvided();
}

/// ------------------------------------------------------------
/// 1. Handling both Success and Error
/// ------------------------------------------------------------

void handleBothStates() {
  final Twofold<int, String> success = Twofold.success(10);
  final Twofold<int, String> error = Twofold.error('failed');

  success.when(
    onSuccess: (value) => print('Success: $value'),
    onError: (err) => print('Error: $err'),
  );

  error.when(
    onSuccess: (value) => print('Success: $value'),
    onError: (err) => print('Error: $err'),
  );
}

/// ------------------------------------------------------------
/// 2. Using `when` for side effects only
/// ------------------------------------------------------------

void sideEffectsOnly() {
  final Twofold<int, String> result = Twofold.success(5);

  result.when(
    onSuccess: (value) {
      // perform side effect
      print('Saving value $value');
    },
    onError: (err) {
      // perform side effect
      print('Logging error $err');
    },
  );
}

/// ------------------------------------------------------------
/// 3. Using `when` to return a value (fold-like behavior)
/// ------------------------------------------------------------

void returningValues() {
  final Twofold<int, String> result = Twofold.error('network error');

  final String message =
      result.when<String>(
        onSuccess: (value) => 'Got value $value',
        onError: (err) => 'Failed with $err',
      ) ??
      'No handler matched';

  print(message);
}

/// ------------------------------------------------------------
/// 4. Partial handling
/// ------------------------------------------------------------

void partialHandling() {
  final Twofold<int, String> success = Twofold.success(1);
  final Twofold<int, String> error = Twofold.error('bad');

  // Only handle success
  success.when(onSuccess: (value) => print('Handled success: $value'));

  // Only handle error
  error.when(onError: (err) => print('Handled error: $err'));
}

/// ------------------------------------------------------------
/// 5. No callbacks provided
/// ------------------------------------------------------------

void noCallbacksProvided() {
  final Twofold<int, String> result = Twofold.success(99);

  final value = result.when();

  // value is null because no callbacks were provided
  print(value); // null
}
