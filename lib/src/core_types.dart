/// Represents which side of a [Twofold] value is active.
///
/// This enum is mainly useful for readability, UI logic,
/// logging, or branching decisions.
///
/// Example:
/// ```dart
/// final side = result.isLeft ? Side.left : Side.right;
/// ```
enum Side {
  /// Represents the left (usually failure) side.
  left,

  /// Represents the right (usually success) side.
  right,
}

/// A union-like type containing either a left value [L]
/// or a right value [R].
///
/// Commonly used to model operations that can result in
/// either a failure ([L]) or a success ([R]).
///
/// ⚠️ IMPORTANT:
/// Exactly **one** of `left` or `right` should be non-null.
/// A value where both are null is considered **invalid**
/// and will throw at runtime when accessed.
///
/// Example:
/// ```dart
/// final success = right<String, int>(42);
/// final failure = left<String, int>('Something went wrong');
/// ```
typedef Twofold<L, R> = ({L? left, R? right});

/// Creates a left value of type [L] for a [Twofold].
///
/// Typically represents a failure or error.
///
/// Example:
/// ```dart
/// final result = left<String, int>('Invalid input');
/// ```
Twofold<L, R> left<L, R>(L value) => (left: value, right: null);

/// Creates a right value of type [R] for a [Twofold].
///
/// Typically represents a success value.
///
/// Example:
/// ```dart
/// final result = right<String, int>(200);
/// ```
Twofold<L, R> right<L, R>(R value) => (left: null, right: value);
