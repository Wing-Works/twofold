# Twofold

![version](https://img.shields.io/badge/version-0.2.1-blue)
![pub.dev](https://img.shields.io/pub/v/twofold)
![license](https://img.shields.io/badge/license-MIT-green)

**Twofold** is a lightweight Dart and Flutter package for representing operations  
that either **succeed with a value** or **fail with an error** — no exceptions, no nulls.
```dart
final result = await TwofoldFuture.tryCatch(
  () async => fetchUser(id),
  onError: (e, _) => 'Failed to load user: $e',
);

result.when(
  onSuccess: (user) => showProfile(user),
  onError: (msg)  => showError(msg),
);
```

---

## Why Twofold?

Operations in real apps fail. Twofold makes that explicit in your type system:

- No more silent nulls or uncaught exceptions
- The compiler reminds you to handle both outcomes
- Your code reads like plain English

---

## Coming from dartz or fpdart?

If you've used packages like **dartz** or **fpdart** and found them heavy or  
hard to explain to your team, Twofold is designed for you.

Twofold covers the most common use case — **success/error branching** — with  
a plain-Dart API that requires zero functional-programming background.

| Feature | Twofold | dartz / fpdart |
|---|---|---|
| Learning curve | Low — plain Dart | Medium–High — FP concepts |
| API surface | Small, focused | Large, general-purpose |
| Async support | Built-in | Varies |
| Testing helpers | ✅ Included | ❌ Not included |
| Target audience | App developers | FP-oriented developers |

> **Twofold is not a replacement for full FP libraries.** If you need `Option`,  
> `IO`, `Task`, or HKTs, dartz or fpdart are the right tools. Twofold solves  
> one thing well: success-or-error branching.

---

## Who is this for?

- Flutter and Dart developers who want **explicit error handling** without exceptions
- Teams that find `Either` from FP libraries too abstract
- Anyone who wants a `Result` type that is easy to read and review

---

## Installation
```yaml
dependencies:
  twofold: ^0.2.1
```
```dart
import 'package:twofold/twofold.dart';
```

---

## Core Concepts

A `Twofold<S, E>` always holds **exactly one** of:

- `Success(value)` — the operation worked, here's the result
- `Error(error)` — the operation failed, here's why

---

## Usage

### Create values
```dart
final Twofold<int, String> success = Twofold.success(42);
final Twofold<int, String> error   = Twofold.error('Something went wrong');
```

### Handle both cases
```dart
final message = result.when(
  onSuccess: (value) => 'Got: $value',
  onError:   (error) => 'Failed: $error',
);
```

### Check state
```dart
if (result.isSuccess) { ... }
if (result.isError)   { ... }
```

### Fallback values
```dart
final value = result.getOrElse(0);
final value = result.getOrElseGet(() => expensiveFallback());
```

---

## Transforming Values

### mapSuccess
```dart
final doubled = Twofold.success(2).mapSuccess((v) => v * 2);
```

### mapError
```dart
final labeled = Twofold.error(404).mapError((code) => 'Error $code');
```

### flatMapSuccess — chain dependent operations
```dart
Twofold<int, String> parse(String input) {
  final n = int.tryParse(input);
  return n != null ? Twofold.success(n) : Twofold.error('Not a number');
}

final result = Twofold.success('10').flatMapSuccess(parse);
```

---

## Async Usage
```dart
// Wrap any async call safely
final result = await TwofoldFuture.tryCatch(
  () async => fetchData(),
  onError: (e, _) => e.toString(),
);

// Chain async operations fluently
fetchUser()
  .mapSuccess((u) => u.name)
  .flatMapSuccess(fetchProfile)
  .when(
    onSuccess: print,
    onError:   showError,
  );
```

---

## Testing Helpers

Twofold ships with framework-agnostic helpers that work with `package:test`  
and `flutter_test`:
```dart
expectSuccess(result, (value) {
  expect(value, 42);
});

expectError(result, (error) {
  expect(error, 'Invalid input');
});
```

---

## Examples

The `example/` directory contains runnable, documented code covering every API:

- Construction and inspection
- `when` handling patterns
- Transformations and chaining
- Async factories and transforms
- Fallback utilities
- Testing helpers with real tests

📂 [`example/`](./example) — Start with [`example/README.md`](./example/README.md)

---

## Design Goals

Twofold is intentionally small and strict:

- **Simple** — one concept, one job
- **Explicit** — no hidden control flow
- **Readable** — application code stays clear
- **Stable** — predictable API evolution toward v1.0

See [CONTRIBUTING.md](./CONTRIBUTING.md) before opening issues or PRs.

---

## Feedback & Contributions

- GitHub: https://github.com/wing-works/twofold
- Issues and feature discussions are welcome
- Please read [CONTRIBUTING.md](./CONTRIBUTING.md) first