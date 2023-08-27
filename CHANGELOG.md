## [0.1.2] - 2023-08-26
### Changed
- Bump SDK to 3.0.0
- Bump petitparser to 6.0.0

## [0.1.1] - 2023-04-28
### Fixed
- Surrogate pairs were not matched with `.` due to a [bug](https://github.com/dart-lang/sdk/issues/52182) in Dart VM. Added a workaround

## [0.1.0] - 2023-04-25
### Added
- `matches()` and `matchesSubstring()` shortcuts

### Changed
- More precise interpretation of `.`

## [0.0.2] - 2023-04-07
### Changed
- API change

### Fixed
- The dot matcher was processed incorrectly

## [0.0.1] - 2023-04-05
### Added
- Initial release

[0.1.2]: https://github.com/f3ath/iregexp/compare/0.1.1...0.1.2
[0.1.1]: https://github.com/f3ath/iregexp/compare/0.1.0...0.1.1
[0.1.0]: https://github.com/f3ath/iregexp/compare/0.0.2...0.1.0
[0.0.2]: https://github.com/f3ath/iregexp/compare/0.0.1...0.0.2
[0.0.1]: https://github.com/f3ath/iregexp/releases/tag/0.0.1
