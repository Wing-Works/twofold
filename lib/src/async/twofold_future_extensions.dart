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
  Future<Twofold<S, T>> mapError<T>(
    T Function(E error) transform,
  ) async {
    final result = await this;
    return result.mapError(transform);
  }

  /// Chains another async operation when the result is a success.
  Future<Twofold<T, E>> flatMapSuccess<T>(
    Future<Twofold<T, E>> Function(S value) transform,
  ) async {
    final result = await this;
    return switch (result) {
      Success(:final value) => await transform(value),
      Error(:final error) => Error<T, E>(error),
    };
  }

  /// Handles the result asynchronously.
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
  Future<S> getOrElse(S defaultValue) async {
    final result = await this;
    return result.getOrElse(defaultValue);
  }

  /// Returns the success value asynchronously or computes a fallback.
  Future<S> getOrElseGet(S Function() fallback) async {
    final result = await this;
    return result.getOrElseGet(fallback);
  }

  /// Swaps the success and error sides asynchronously.
  Future<Twofold<E, S>> swap() async {
    final result = await this;
    return result.swap();
  }
}
