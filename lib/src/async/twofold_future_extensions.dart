import 'package:meta/meta.dart';
import 'package:twofold/src/core/twofold.dart';

/// Async extensions for working with `Future<Twofold>`.
///
/// These extensions mirror the synchronous [Twofold] APIs
/// and allow fluent async chaining without repetitive `await`.
@internal
extension TwofoldFutureX<S, E> on Future<Twofold<S, E>> {
  /// Transforms the success value asynchronously.
  ///
  /// The error is preserved unchanged.
  ///
  /// Example:
  /// ```dart
  /// fetchCount()
  ///   .mapSuccess((v) => v * 2)
  ///   .when(onSuccess: print);
  /// ```
  Future<Twofold<T, E>> mapSuccess<T>(
    T Function(S value) transform,
  ) async {
    final result = await this;
    return result.mapSuccess(transform);
  }

  /// Transforms the error value asynchronously.
  ///
  /// The success value is preserved unchanged.
  ///
  /// Example:
  /// ```dart
  /// fetchData()
  ///   .mapError((e) => e.toString())
  ///   .when(onError: print);
  /// ```
  Future<Twofold<S, T>> mapError<T>(
    T Function(E error) transform,
  ) async {
    final result = await this;
    return result.mapError(transform);
  }

  /// Chains another asynchronous operation when this result is a success.
  ///
  /// This is the async equivalent of [Twofold.flatMapSuccess].
  ///
  /// - If this resolves to a [Success], [transform] is executed.
  /// - If this resolves to an [Error], the error is propagated unchanged.
  /// - No exceptions are thrown.
  ///
  /// This allows multiple async steps to be composed without
  /// nested `await` or manual error checks.
  ///
  /// ---
  ///
  /// ### Example: Async chaining
  /// ```dart
  /// Future<Twofold<String, String>> fetchToken();
  /// Future<Twofold<User, String>> fetchUser(String token);
  ///
  /// final result = await fetchToken()
  ///     .flatMapSuccess(fetchUser);
  /// ```
  ///
  /// ### Example: Error short-circuiting
  /// ```dart
  /// final result = await fetchToken()
  ///     .flatMapSuccess(fetchUser);
  ///
  /// // If fetchToken() returns Error,
  /// // fetchUser() is never executed.
  /// ```
  Future<Twofold<T, E>> flatMapSuccess<T>(
    Future<Twofold<T, E>> Function(S value) transform,
  ) async {
    final result = await this;
    return switch (result) {
      Success(:final value) => await transform(value),
      Error(:final error) => Error<T, E>(error),
    };
  }

  /// Handles the resolved value of this `Future<Twofold>`.
  ///
  /// This is the async counterpart of [Twofold.when].
  ///
  /// It can be used for:
  /// - **side effects** (logging, navigation, UI updates)
  /// - **value transformation** (returning a computed value)
  ///
  /// Both callbacks are optional:
  /// - If a callback is not provided, it is skipped.
  /// - If neither callback matches, `null` is returned.
  ///
  /// ---
  ///
  /// ### Example: Side effects
  /// ```dart
  /// await fetchUser().when(
  ///   onSuccess: (user) => print(user.name),
  ///   onError: showError,
  /// );
  /// ```
  ///
  /// ### Example: Returning a value
  /// ```dart
  /// final message = await fetchUser().when(
  ///   onSuccess: (u) => 'Welcome ${u.name}',
  ///   onError: (_) => 'Guest mode',
  /// );
  /// ```
  ///
  /// ### Example: Partial handling
  /// ```dart
  /// await fetchUser().when(
  ///   onError: logError,
  /// );
  /// ```
  Future<T?> when<T>({
    T Function(S success)? onSuccess,
    T Function(E error)? onError,
  }) async {
    final result = await this;
    return result.when(
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  /// Returns the success value asynchronously or [defaultValue].
  ///
  /// Example:
  /// ```dart
  /// final count = await fetchCount().getOrElse(0);
  /// ```
  Future<S> getOrElse(S defaultValue) async {
    final result = await this;
    return result.getOrElse(defaultValue);
  }

  /// Returns the success value asynchronously or computes a fallback.
  ///
  /// Example:
  /// ```dart
  /// final user = await fetchUser()
  ///     .getOrElseGet(() => createGuestUser());
  /// ```
  Future<S> getOrElseGet(S Function() fallback) async {
    final result = await this;
    return result.getOrElseGet(fallback);
  }

  /// Swaps the success and error sides asynchronously.
  ///
  /// Example:
  /// ```dart
  /// final swapped = await fetchResult().swap();
  /// ```
  Future<Twofold<E, S>> swap() async {
    final result = await this;
    return result.swap();
  }
}
