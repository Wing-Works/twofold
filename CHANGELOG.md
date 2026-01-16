# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/).

## [0.1.0] - Initial release

### Added
- `Twofold<L, R>` core type for representing two-outcome values
- Constructors for creating left and right values
- Extension methods for:
    - inspecting state (`isLeft`, `isRight`)
    - safe and unsafe value access
    - handling outcomes (`fold`, `when`)
    - transforming values (`map`, `mapLeft`, `flatMap`)
    - fallback handling (`getOrElse`, `getOrElseGet`)
    - utility helpers (`swap`, `toList`, `toStringValue`, `isEqualTo`, `hashValue`)

### Notes
- Invalid states (both values null) are possible in this version and will throw at runtime
- API is intentionally minimal and synchronous
