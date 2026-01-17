import 'package:twofold/twofold.dart';

/// This file demonstrates how to CREATE `Twofold` values
/// when your logic involves async operations.
///
/// Use async factories when:
/// - you do NOT yet have a `Twofold`
/// - you need to await something
/// - you want to convert async failures into typed errors
///
/// This file covers:
/// 1. fromCondition  → conditional async creation
/// 2. tryCatch       → exception-safe async execution
///
/// ============================================================

Future<void> main() async {
  print('--- Async fromCondition examples ---');
  await exampleLoginCheck();
  await exampleValidation();

  print('\n--- Async tryCatch examples ---');
  await exampleSafeParsing();
  await exampleAsyncFailure();
}

/// ------------------------------------------------------------
/// Example 1: fromCondition — async login check
/// ------------------------------------------------------------
///
/// Real-world meaning:
/// - We need to check login state asynchronously
/// - Based on that, we either fetch user data or return an error
/// - ONLY the matching branch is executed
///
Future<void> exampleLoginCheck() async {
  // Simulate async condition (e.g. auth service)
  final bool isLoggedIn = await Future.value(false);

  final Twofold<String, String> result = await TwofoldFuture.fromCondition(
    isLoggedIn,

    // Executed ONLY if isLoggedIn == true
    success: () async {
      return 'user_123';
    },

    // Executed ONLY if isLoggedIn == false
    error: () async {
      return 'User is not logged in';
    },
  );

  result.when(
    onSuccess: (user) => print('Logged in as $user'),
    onError: (err) => print('Login failed: $err'),
  );
}

/// ------------------------------------------------------------
/// Example 2: fromCondition — validation before async work
/// ------------------------------------------------------------
///
/// Real-world meaning:
/// - Validate input first
/// - If valid → do async work
/// - If invalid → fail early without doing work
///
Future<void> exampleValidation() async {
  final String input = '';

  final Twofold<int, String> result = await TwofoldFuture.fromCondition(
    input.isNotEmpty,

    success: () async {
      // Async work only happens if input is valid
      return int.parse(input);
    },

    error: () async {
      return 'Input cannot be empty';
    },
  );

  print(result);
}

/// ------------------------------------------------------------
/// Example 3: tryCatch — safe async execution
/// ------------------------------------------------------------
///
/// Real-world meaning:
/// - Async code may throw exceptions
/// - We NEVER want exceptions to escape
/// - We convert them into typed Error values
///
Future<void> exampleSafeParsing() async {
  final Twofold<int, String> result = await TwofoldFuture.tryCatch(
    () async {
      return int.parse('42');
    },
    onError: (error, _) {
      return 'Invalid number';
    },
  );

  print(result); // Success(42)
}

/// ------------------------------------------------------------
/// Example 4: tryCatch — async failure handling
/// ------------------------------------------------------------
///
/// Important:
/// - Both sync and async exceptions are captured
/// - No crashes
/// - Result is ALWAYS a Twofold
///
Future<void> exampleAsyncFailure() async {
  final Twofold<String, String> result = await TwofoldFuture.tryCatch(() async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    throw Exception('Network error');
  }, onError: (error, _) => error.toString());

  print(result); // Error(Exception: Network error)
}
