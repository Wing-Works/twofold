# Twofold

**Twofold** is a small, explicit utility for representing values that can have  
**one of two outcomes** — a *success* or an *error*.

It is designed to be:
- Simple
- Explicit
- Easy to read
- Friendly for real-world Dart and Flutter apps

No functional-programming background is required.

---

## Why Twofold?

In many applications, operations can:
- succeed with a value
- fail with a reason

`Twofold<S, E>` lets you model this clearly without relying on
exceptions, nullable values, or implicit control flow.

Twofold focuses on:
- clear intent
- predictable APIs
- readable application code

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
  twofold: ^0.2.0
```

```dart
import 'package:twofold/twofold.dart';
```

---

## Basic Usage

### Creating values

```dart
final success = Twofold.success(42);
final error = Twofold.error('Something went wrong');
```

---

### Checking state

```dart
if (result.isSuccess) {
  print('Operation succeeded');
}

if (result.isError) {
  print('Operation failed');
}
```

---

### Handling both cases (recommended)

```dart
final message = result.when(
  onSuccess: (value) => 'Success: $value',
  onError: (error) => 'Failed: $error',
);
```

---

### Side effects

```dart
result.when(
  onSuccess: (value) => save(value),
  onError: (error) => log(error),
);
```

---

## Transforming values

### mapSuccess

```dart
final doubled = Twofold.success(2)
    .mapSuccess((v) => v * 2);
```

---

### mapError

```dart
final formattedError = Twofold.error(404)
    .mapError((code) => 'Error $code');
```

---

### flatMapSuccess (chaining)

```dart
Twofold<int, String> parse(String value) {
  final parsed = int.tryParse(value);
  return parsed != null
      ? Twofold.success(parsed)
      : Twofold.error('Invalid number');
}

final result = Twofold.success('10')
    .flatMapSuccess(parse);
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

## Async Usage

Twofold provides extensions for `Future<Twofold>` to enable fluent async flows.

```dart
fetchUser()
  .mapSuccess((u) => u.name)
  .flatMapSuccess(fetchProfile)
  .when(
    onSuccess: print,
    onError: showError,
  );
```

Creating async results safely:

```dart
final result = await TwofoldFuture.tryCatch(
  () async => fetchData(),
  onError: (e, _) => e.toString(),
);
```

---

## Testing Helpers

Twofold includes simple, framework-agnostic helpers for testing.

```dart
expectSuccess(result, (value) {
  expect(value, 42);
});

expectError(result, (error) {
  expect(error, 'Invalid input');
});
```

These helpers work with `package:test`, `flutter_test`,
or any assertion-based testing framework.

---

## Important Note

A `Twofold` always represents **exactly one state**:
- a `Success` containing a value
- or an `Error` containing an error

Invalid or ambiguous states are not possible by design.

---

## Feedback & Contributions

- GitHub: https://github.com/wing-works/twofold
- Issues and feature discussions are welcome
- Please read [CONTRIBUTING.md](./CONTRIBUTING.md) before contributing
