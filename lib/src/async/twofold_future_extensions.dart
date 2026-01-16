import '../core/twofold.dart';

/// Async extensions for working with `Future<Twofold>`.
///
/// These extensions mirror the synchronous [Twofold] APIs
/// and allow fluent async chaining without repetitive `await`.
extension TwofoldFutureX<S, E> on Future<Twofold<S, E>> {
  /// Transforms the success value asynchronously.
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
  /// Example:
  /// ```dart
  /// fetchData()
  ///   .mapError((e) => e.message)
  ///   .when(onError: print);
  /// ```
  Future<Twofold<S, T>> mapError<T>(
    T Function(E error) transform,
  ) async {
    final result = await this;
    return result.mapError(transform);
  }

  /// Chains another async operation when the result is a success.
  ///
  /// Example:
  /// ```dart
  /// fetchToken()
  ///   .flatMapSuccess(fetchUser)
  ///   .when(onSuccess: print);
  /// ```
  Future<Twofold<T, E>> flatMapSuccess<T>(
    Future<Twofold<T, E>> Function(S value) transform,
  ) async {
    final result = await this;
    return switch (result) {
      Success(:final value) => transform(value),
      Error(:final error) => Future.value(Error<T, E>(error)),
    };
  }

  /// Handles the result asynchronously.
  ///
  /// Example:
  /// ```dart
  /// await fetchUser().when(
  ///   onSuccess: (u) => print(u.name),
  ///   onError: showError,
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

  /// Creates a [Twofold] asynchronously based on a boolean [condition].
  ///
  /// Example:
  /// ```dart
  /// final result = await TwofoldFutureHelpersX.fromCondition(
  ///   isLoggedIn,
  ///   success: () async => await fetchUser(),
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

  /// Executes an async [action] and captures any exception as an [Error].
  ///
  /// Example:
  /// ```dart
  /// final result = await TwofoldFutureHelpersX.tryCatch(
  ///   () async => await fetchData(),
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
}
