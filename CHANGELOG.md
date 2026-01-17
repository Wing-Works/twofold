# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/).

---

## [0.2.0] - 2026-01-18

### Added
- New sealed `Twofold<S, E>` core type with explicit `Success` and `Error` states
- Factory constructors:
    - `Twofold.success`
    - `Twofold.error`
- Unified `when` API for both side effects and value transformation
- Safe accessors:
    - `successOrNull`
    - `errorOrNull`
- Explicit unsafe accessors:
    - `successUnsafe`
    - `errorUnsafe`
- Transformation helpers:
    - `mapSuccess`
    - `mapError`
- Chaining helper:
    - `flatMapSuccess`
- Fallback helpers:
    - `getOrElse`
    - `getOrElseGet`
- Utility helper:
    - `swap`

### Async
- Added async extensions for `Future<Twofold>`:
    - `mapSuccess`
    - `mapError`
    - `flatMapSuccess`
    - `when`
    - `getOrElse`
    - `getOrElseGet`
    - `swap`
- Added async factory helpers via `TwofoldFuture`:
    - `fromCondition`
    - `tryCatch`

### Testing
- Added framework-agnostic testing helpers:
    - `expectSuccess`
    - `expectError`

### Documentation
- Rewritten README to match sealed-class API
- Added comprehensive Dartdoc examples for all public APIs
- Added `CONTRIBUTING.md` defining design rules, naming conventions, and stability guarantees

### Changed
- Replaced record-based `left/right` representation with sealed classes
- Replaced `fold` API with unified `when`
- Standardized terminology to `Success` / `Error`
- Improved equality and hashing guarantees using value-based semantics

### Removed
- Removed record-based `Twofold<L, R>` implementation
- Removed `left`, `right`, `isLeft`, `isRight`, `mapLeft`, and legacy helpers
- Removed possibility of invalid states (now enforced by design)

### Notes
- This release contains intentional breaking changes from `0.1.0`
- The API surface is now stable and designed for evolution toward `1.0.0`
- Users upgrading from `0.1.0` should refer to the README for migration guidance

---

## [0.1.0] - Initial release

### Added
- Record-based `Twofold<L, R>` core type for representing two-outcome values
- Constructors for creating left and right values
- Extension methods for:
    - inspecting state (`isLeft`, `isRight`)
    - safe and unsafe value access
    - handling outcomes (`fold`, `when`)
    - transforming values (`map`, `mapLeft`, `flatMap`)
    - fallback handling (`getOrElse`, `getOrElseGet`)
    - utility helpers (`swap`, `toList`, `toStringValue`, `isEqualTo`, `hashValue`)

### Notes
- Invalid states (both values null) were possible and would throw at runtime
- API was synchronous and minimal by design
