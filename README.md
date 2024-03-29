# iregexp
A Dart implementation of [RFC 9485] I-Regexp: An Interoperable Regexp Format

This implementation is validating, that is `IRegexp(pattern)` throws a `formatException` if `pattern` does not conform to I-Regexp.
Internally it uses the built-in `RegExp` class.

```dart
import 'package:iregexp/iregexp.dart';

// An example of using the IRegexp class.
void main() {
  final iRegexp = IRegexp('[0-9]+.[0-9]+.[0-9]+');
  print(iRegexp.matches('1.2.3')); // true
  print(iRegexp.matches('foo')); // false
}
```

[RFC 9485]: https://datatracker.ietf.org/doc/rfc9485/
