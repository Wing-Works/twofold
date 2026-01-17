import 'package:twofold/twofold.dart';

/// This file demonstrates how to WORK WITH an EXISTING
/// `Future<Twofold<S, E>>`.
///
/// IMPORTANT DISTINCTION:
/// - Async factories → CREATE a Twofold
/// - Async transforms → OPERATE on a `Future<Twofold>`
///
/// Use async transforms when:
/// - you ALREADY have `Future<Twofold>`
/// - you want to map, chain, handle, or recover
/// - you want clean async flows without nested `await`
///
/// This file covers:
/// 1. mapSuccess
/// 2. mapError
/// 3. flatMapSuccess
/// 4. when (async handling)
/// 5. getOrElse / getOrElseGet
/// 6. swap
///
/// ============================================================

Future<void> main() async {
  print('--- mapSuccess examples ---');
  await exampleMapSuccess();

  print('\n--- mapError examples ---');
  await exampleMapError();

  print('\n--- flatMapSuccess examples ---');
  await exampleFlatMapSuccess();

  print('\n--- when examples ---');
  await exampleWhen();

  print('\n--- fallback examples ---');
  await exampleFallback();

  print('\n--- swap examples ---');
  await exampleSwap();
}

/// ------------------------------------------------------------
/// Helper async functions (simulate real APIs)
/// ------------------------------------------------------------

Future<Twofold<int, String>> fetchNumber(bool succeed) async {
  await Future<void>.delayed(const Duration(milliseconds: 30));
  return succeed ? Twofold.success(10) : Twofold.error('Network error');
}

Future<Twofold<String, String>> fetchLabel(int value) async {
  await Future<void>.delayed(const Duration(milliseconds: 30));
  return Twofold.success('Value: $value');
}

/// ------------------------------------------------------------
/// Example 1: mapSuccess
/// ------------------------------------------------------------
///
/// Real-world meaning:
/// - API returns data
/// - We want to transform ONLY the success value
/// - Errors pass through untouched
///
Future<void> exampleMapSuccess() async {
  final result = await fetchNumber(true).mapSuccess((value) => value * 2);

  print(result); // Success(20)

  final errorResult = await fetchNumber(false).mapSuccess((value) => value * 2);

  print(errorResult); // Error(Network error)
}

/// ------------------------------------------------------------
/// Example 2: mapError
/// ------------------------------------------------------------
///
/// Real-world meaning:
/// - Convert low-level errors into user-friendly messages
///
Future<void> exampleMapError() async {
  final result = await fetchNumber(
    false,
  ).mapError((err) => 'Something went wrong: $err');

  print(result); // Error(Something went wrong: Network error)
}

/// ------------------------------------------------------------
/// Example 3: flatMapSuccess (async chaining)
/// ------------------------------------------------------------
///
/// Real-world meaning:
/// - Multiple dependent async calls
/// - Each step may fail
/// - Stop at first error automatically
///
Future<void> exampleFlatMapSuccess() async {
  final result = await fetchNumber(true).flatMapSuccess(fetchLabel);

  print(result); // Success(Value: 10)

  final errorResult = await fetchNumber(false).flatMapSuccess(fetchLabel);

  print(errorResult); // Error(Network error)
}

/// ------------------------------------------------------------
/// Example 4: when (async handling)
/// ------------------------------------------------------------
///
/// Real-world meaning:
/// - React to success or error
/// - Perform side effects
/// - Optionally return a value
///
Future<void> exampleWhen() async {
  final message = await fetchNumber(
    true,
  ).when(onSuccess: (value) => 'Got $value', onError: (err) => 'Failed: $err');

  print(message); // Got 10

  // Partial handling (only error)
  await fetchNumber(false).when(onError: (err) => print('Logged error: $err'));
}

/// ------------------------------------------------------------
/// Example 5: fallback values
/// ------------------------------------------------------------
///
/// Real-world meaning:
/// - Failure is acceptable
/// - We want a safe default
///
Future<void> exampleFallback() async {
  final value = await fetchNumber(false).getOrElse(0);
  print(value); // 0

  final lazyValue = await fetchNumber(false).getOrElseGet(() => 999);
  print(lazyValue); // 999
}

/// ------------------------------------------------------------
/// Example 6: swap
/// ------------------------------------------------------------
///
/// Real-world meaning:
/// - Invert logic
/// - Turn validation failures into successes
///
Future<void> exampleSwap() async {
  final swapped = await fetchNumber(false).swap();
  print(swapped); // Success(Network error)
}
