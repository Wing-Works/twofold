import 'package:meta/meta.dart';
import 'package:twofold/src/core/twofold.dart';

/// Async factory helpers for creating [Twofold] values.
@internal
abstract final class TwofoldFuture {
  /// Creates a [Twofold] asynchronously based on a condition.
  ///
  /// Example:
  /// ```dart
  /// final result = await TwofoldFuture.fromCondition(
  ///   isLoggedIn,
  ///   success: () async => fetchUser(),
  ///   error: () async => 'Not logged in',
  /// );
  /// ```
  static Future<Twofold<S, E>> fromCondition<S, E>(
    bool condition, {
    required Future<S> Function() success,
    required Future<E> Function() error,
  }) async {
    return condition
        ? Success<S, E>(await success())
        : Error<S, E>(await error());
  }

  /// Executes an async action and captures any exception as an [Error].
  ///
  /// Example:
  /// ```dart
  /// final result = await TwofoldFuture.tryCatch(
  ///   () async => fetchData(),
  ///   onError: (e, _) => e.toString(),
  /// );
  /// ```
  static Future<Twofold<S, E>> tryCatch<S, E>(
    Future<S> Function() action, {
    required E Function(Object error, StackTrace stackTrace) onError,
  }) async {
    try {
      return Success<S, E>(await action());
    } catch (e, st) {
      return Error<S, E>(onError(e, st));
    }
  }
}
