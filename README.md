# Twofold

**Twofold** is a small utility for representing values that can have
**one of two outcomes** — commonly *failure* or *success*.

It is designed to be:
- Simple
- Explicit
- Easy to read
- Friendly for real-world Dart and Flutter apps

No special programming style or background is required.

---

## Why Twofold?

In many applications, operations can:
- succeed with a value
- fail with a reason

`Twofold<L, R>` lets you model this clearly without relying on
exceptions or nullable values.

---

## Design Principles

Twofold is intentionally small, strict, and predictable.

The project follows clear design and API stability rules to ensure:
- long-term maintainability
- strong typing
- readable application code
- safe evolution toward v1.0

If you plan to contribute or propose new features, please read  
[CONTRIBUTING.md](./CONTRIBUTING.md) before opening an issue or PR.

---

## Installation

```yaml
dependencies:
  twofold: ^0.1.0
```

```dart
import 'package:twofold/twofold.dart';
```

---

## Basic usage

### Creating values

```dart
final success = right<String, int>(42);
final failure = left<String, int>('Something went wrong');
```

---

### Checking state

```dart
if (result.isRight) {
print('Operation succeeded');
}
```

```dart
if (result.isLeft) {
  print('Operation failed');
}
```

---

### Handling both cases (recommended)

```dart
final message = result.fold(
  (error) => 'Failed: $error',
  (value) => 'Success: $value',
);
```

---

### Side effects

```dart
result.when(
  (error) => log(error),
  (value) => save(value),
);
```

---

## Transforming values

### map

```dart
final doubled = right<String, int>(2)
    .map((v) => v * 2);
```

---

### mapLeft

```dart
final formattedError = left<int, String>(404)
    .mapLeft((code) => 'Error $code');
```

---

### flatMap (chaining)

```dart
Twofold<String, int> parse(String value) {
  final parsed = int.tryParse(value);
  return parsed != null
      ? right(parsed)
      : left('Invalid number');
}

final result = right<String, String>('10')
    .flatMap(parse);
```

---

## Fallback values

```dart
final value = result.getOrElse(0);
```

```dart
final value = result.getOrElseGet(() => expensiveFallback());
```

---

## Utility helpers

```dart
print(result.toStringValue());
```

```dart
final isSame = a.isEqualTo(b);
```

```dart
final hash = result.hashValue;
```

---

## Important note

A `Twofold` should contain **exactly one** value:
- either a left value
- or a right value

Creating a value where both are `null` is considered invalid
and will throw at runtime when accessed.

This will be enforced more strictly in future versions.
