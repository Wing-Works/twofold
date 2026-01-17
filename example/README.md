# Twofold – Examples

This folder contains **runnable, real-world examples** demonstrating how to use
the `twofold` package effectively in Dart and Flutter applications.

Each example focuses on **one concept only**, with matching test files to show
how the same logic can be verified in your own projects.

---

## Folder Structure

```
example/
├─ lib/
│  ├─ core/
│  │  ├─ construction.dart
│  │  ├─ inspection.dart
│  │  ├─ when_handling.dart
│  │  ├─ transform.dart
│  │  └─ fallback_and_utils.dart
│  │
│  ├─ async/
│  │  ├─ async_factories.dart
│  │  └─ async_transform.dart
│  │
│  └─ testing/
│     └─ testing_helpers.dart
│
├─ test/
│  ├─ core/
│  │  ├─ construction_test.dart
│  │  ├─ inspection_test.dart
│  │  ├─ when_handling_test.dart
│  │  ├─ transform_test.dart
│  │  └─ fallback_and_utils_test.dart
│  │
│  ├─ async/
│  │  ├─ async_factories_test.dart
│  │  └─ async_transform_test.dart
│  │
│  └─ testing/
│     └─ testing_helpers_test.dart
│
└─ README.md
```

---

## How to Use These Examples

### Core Examples (`lib/core`)

These files demonstrate **synchronous** usage of `Twofold`.

- Creating `Twofold.success` and `Twofold.error`
- Inspecting state safely
- Handling success & error with `when`
- Mapping and chaining results
- Providing fallbacks and utilities

---

### Async Examples (`lib/async`)

Async examples are split by responsibility:

**async_factories.dart**
- Creating `Twofold` values from async operations
- Handling exceptions safely
- Conditional async creation

**async_transform.dart**
- Transforming `Future<Twofold>`
- Async chaining and handling
- Async fallbacks

---

### Testing Helpers (`lib/testing`)

Demonstrates how to test `Twofold` cleanly using:
- `expectSuccess`
- `expectError`

Works with `package:test`, `flutter_test`, and other frameworks.

---

## Running Tests

```bash
flutter test example/test
```

or

```bash
dart test example/test
```

---

## Learning Path

1. core/construction.dart
2. core/inspection.dart
3. core/when_handling.dart
4. core/transform.dart
5. core/fallback_and_utils.dart
6. async/async_factories.dart
7. async/async_transform.dart
8. testing/testing_helpers.dart

---

These examples are designed for **real-world usage**, not toy demos.
