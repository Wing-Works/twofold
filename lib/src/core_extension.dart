import 'core_types.dart';

/// Extension providing utility and helper methods for [Twofold] values.
///
/// These methods make it easier to:
/// - inspect state
/// - extract values safely
/// - transform values
/// - chain operations
/// - handle success and failure explicitly
extension TwofoldX<L, R> on Twofold<L, R> {
  /// Returns `true` if this contains a left value.
  ///
  /// Example:
  /// ```dart
  /// if (result.isLeft) {
  ///   print('Operation failed');
  /// }
  /// ```
  bool get isLeft => this.left != null;

  /// Returns `true` if this contains a right value.
  ///
  /// Example:
  /// ```dart
  /// if (result.isRight) {
  ///   print('Operation succeeded');
  /// }
  /// ```
  bool get isRight => this.right != null;

  /// Returns the left value if present, otherwise `null`.
  ///
  /// Example:
  /// ```dart
  /// final error = result.leftOrNull;
  /// ```
  L? get leftOrNull => this.left;

  /// Returns the right value if present, otherwise `null`.
  ///
  /// Example:
  /// ```dart
  /// final value = result.rightOrNull;
  /// ```
  R? get rightOrNull => this.right;

  /// Returns the left value if present.
  ///
  /// Throws a [StateError] if this contains a right value.
  ///
  /// Example:
  /// ```dart
  /// final error = result.leftValue;
  /// ```
  L get leftValue {
    final value = this.left;
    if (value != null) return value;
    throw StateError('Twofold contains a right value, not a left value');
  }

  /// Returns the right value if present.
  ///
  /// Throws a [StateError] if this contains a left value.
  ///
  /// Example:
  /// ```dart
  /// final value = result.rightValue;
  /// ```
  R get rightValue {
    final value = this.right;
    if (value != null) return value;
    throw StateError('Twofold contains a left value, not a right value');
  }

  /// Applies [onLeft] if this contains a left value,
  /// or [onRight] if this contains a right value.
  ///
  /// This is the **recommended** way to handle a [Twofold].
  ///
  /// Example:
  /// ```dart
  /// final message = result.fold(
  ///   (error) => 'Failed: $error',
  ///   (value) => 'Success: $value',
  /// );
  /// ```
  T fold<T>(T Function(L) onLeft, T Function(R) onRight) {
    final l = this.left;
    if (l != null) return onLeft(l);

    final r = this.right;
    if (r != null) return onRight(r);

    throw StateError('Twofold is in an invalid state');
  }

  /// Executes side effects based on the contained value.
  ///
  /// Similar to [fold], but does not return a value.
  ///
  /// Example:
  /// ```dart
  /// result.when(
  ///   (error) => log(error),
  ///   (value) => save(value),
  /// );
  /// ```
  void when(void Function(L) onLeft, void Function(R) onRight) {
    final l = this.left;
    if (l != null) {
      onLeft(l);
      return;
    }

    final r = this.right;
    if (r != null) {
      onRight(r);
      return;
    }

    throw StateError('Twofold is in an invalid state');
  }

  /// Transforms the right value if present.
  ///
  /// The left value is preserved unchanged.
  ///
  /// Example:
  /// ```dart
  /// final result = right<String, int>(2)
  ///     .map((v) => v * 2); // Right(4)
  /// ```
  Twofold<L, T> map<T>(T Function(R) transform) {
    final r = this.right;
    if (r != null) return right<L, T>(transform(r));

    final l = this.left;
    if (l != null) return left<L, T>(l);

    throw StateError('Twofold is in an invalid state');
  }

  /// Transforms the left value if present.
  ///
  /// The right value is preserved unchanged.
  ///
  /// Example:
  /// ```dart
  /// final result = left<int, String>(404)
  ///     .mapLeft((code) => 'Error $code');
  /// ```
  Twofold<T, R> mapLeft<T>(T Function(L) transform) {
    final l = this.left;
    if (l != null) return left<T, R>(transform(l));

    final r = this.right;
    if (r != null) return right<T, R>(r);

    throw StateError('Twofold is in an invalid state');
  }

  /// Chains another operation that returns a [Twofold].
  ///
  /// Useful for composing multiple dependent steps.
  ///
  /// Example:
  /// ```dart
  /// Twofold<String, int> parse(String value) =>
  ///   int.tryParse(value) != null
  ///     ? right(int.parse(value))
  ///     : left('Invalid number');
  ///
  /// final result = right<String, String>('10')
  ///     .flatMap(parse);
  /// ```
  Twofold<L, T> flatMap<T>(Twofold<L, T> Function(R) transform) {
    final r = this.right;
    if (r != null) return transform(r);

    final l = this.left;
    if (l != null) return left<L, T>(l);

    throw StateError('Twofold is in an invalid state');
  }

  /// Returns the right value if present, otherwise returns [defaultValue].
  ///
  /// Example:
  /// ```dart
  /// final value = result.getOrElse(0);
  /// ```
  R getOrElse(R defaultValue) => this.right ?? defaultValue;

  /// Returns the right value if present, otherwise computes a fallback value.
  ///
  /// Example:
  /// ```dart
  /// final value = result.getOrElseGet(() => expensiveFallback());
  /// ```
  R getOrElseGet(R Function() defaultValue) => this.right ?? defaultValue();

  /// Swaps the left and right values.
  ///
  /// Example:
  /// ```dart
  /// final swapped = left<String, int>('error').swap();
  /// ```
  Twofold<R, L> swap() {
    final l = this.left;
    if (l != null) return right<R, L>(l);

    final r = this.right;
    if (r != null) return left<R, L>(r);

    throw StateError('Twofold is in an invalid state');
  }

  /// Converts this value into a single-element list.
  ///
  /// Example:
  /// ```dart
  /// final list = right<String, int>(1).toList(); // [1]
  /// ```
  List<Object?> toList() {
    final l = this.left;
    if (l != null) return [l];

    final r = this.right;
    if (r != null) return [r];

    return const [];
  }

  /// Returns a readable string representation of this [Twofold].
  ///
  /// This is a helper method (not an override of `Object.toString`)
  /// because extensions cannot override `Object` members.
  ///
  /// Example:
  /// ```dart
  /// final success = right<String, int>(10);
  /// print(success.toStringValue()); // Right(10)
  ///
  /// final failure = left<String, int>('error');
  /// print(failure.toStringValue()); // Left(error)
  /// ```
  String toStringValue() {
    final l = this.left;
    if (l != null) return 'Left($l)';

    final r = this.right;
    if (r != null) return 'Right($r)';

    return 'Twofold(invalid)';
  }

  /// Compares this [Twofold] with another object by value.
  ///
  /// Two [Twofold] instances are considered equal if:
  /// - both contain left values that are equal, or
  /// - both contain right values that are equal.
  ///
  /// This is a helper method and does **not** override `operator ==`.
  ///
  /// Example:
  /// ```dart
  /// final a = right<String, int>(10);
  /// final b = right<String, int>(10);
  ///
  /// print(a.isEqualTo(b)); // true
  /// ```
  bool isEqualTo(Object other) {
    if (identical(this, other)) return true;
    if (other is! Twofold<L, R>) return false;

    return this.left == other.left && this.right == other.right;
  }

  /// Returns a hash value based on the contained left or right value.
  ///
  /// This helper can be used when you need a stable hash for
  /// collections or comparisons.
  ///
  /// This does **not** override `Object.hashCode`.
  ///
  /// Example:
  /// ```dart
  /// final value = right<String, int>(42);
  /// print(value.hashValue);
  /// ```
  int get hashValue => Object.hash(left, right);
}
