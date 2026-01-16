# Contributing to Twofold

Thank you for your interest in contributing to **Twofold** 🎉  
This document defines the **non-negotiable design rules and standards** for the project.

Twofold is intentionally small, strict, and predictable.  
All contributions must follow the rules below to keep the API clean and stable.

---

## 1. Public vs Internal APIs

### Public API
Anything exported from `lib/twofold.dart` is considered **public and stable**.

This includes (but is not limited to):
- `Twofold`
- `Success`
- `Error`
- `TwofoldFuture`
- `TwofoldFutureX`
- `expectSuccess`
- `expectError`

**Rule:**
> Once an API is public, it can only be removed or renamed in a **major version**.

---

### Internal API
Anything not exported from `lib/twofold.dart` is considered **internal**.

**Rule:**
> Internal APIs may change freely and should not be relied upon by users.

---

## 2. Naming Rules (Strict)

The following names are **locked** and must not be changed or duplicated:

| Concept | Name |
|------|----|
| Positive outcome | `Success` |
| Negative outcome | `Error` |
| Handling both | `when` |
| Mapping success | `mapSuccess` |
| Mapping error | `mapError` |
| Chaining | `flatMapSuccess` |
| Safe access | `successOrNull`, `errorOrNull` |
| Unsafe access | `successUnsafe`, `errorUnsafe` |

❌ No aliases  
❌ No synonyms  
❌ No alternative spellings  

Consistency is more important than creativity.

---

## 3. Extension Usage Rules

### Allowed
Extensions may be used **only** for:
- `Future<Twofold>` ergonomics
- Testing helpers

### Forbidden
- Core logic inside extensions
- Duplicating core APIs using extensions

**Reason:**  
Core behavior must live in the sealed class for clarity, traceability, and evolution.

---

## 4. Async API Rules

- Async APIs must mirror sync APIs
- Naming must be identical
- Behavior must be consistent

Example:
```dart
Twofold.mapSuccess
Future<Twofold>.mapSuccess
```

No async-only abstractions unless absolutely required.

---

## 5. Nullability Rules

### Allowed
- Nullable return from `when<T?>`
- Explicit nullable accessors like `successOrNull`

### Forbidden
- APIs that sometimes throw and sometimes don’t
- Implicit nullability without documentation

**Rule:**
> Unsafe behavior must be explicitly named `Unsafe`.

---

## 6. Equality & Hashing

If a type overrides `operator ==`, it **must** override `hashCode`.

Rules:
- Equality is value-based
- `runtimeType` must be included in `hashCode`
- Behavior must be documented

---

## 7. Documentation Rules (Hard Requirement)

Every public API must include:
1. Clear description
2. Behavioral guarantees
3. At least one example
4. Failure or edge-case behavior

If any of the above are missing, the API should not be merged.

---

## 8. Testing Strategy

- Testing helpers must be framework-agnostic
- No custom matchers or DSLs
- Use simple assertion-based helpers only

The goal is clarity, not magic.

---

## 9. Backward Compatibility Policy

| Version | Policy |
|------|------|
| `0.x` | Minor breaking changes allowed (with notes) |
| `1.x` | No breaking changes |
| `2.x` | Breaking changes allowed |

---

## 10. Contribution Checklist

Before opening a PR, ask:
1. Is this discoverable without reading docs?
2. Does this duplicate an existing API?
3. Does this reduce cognitive load?

If the answer to **any** is “no”, the change should be reconsidered.

---

Thank you for helping keep Twofold clean, predictable, and developer-friendly.
