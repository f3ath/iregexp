# iregexp
A Dart implementation of [I-Regexp]: An Interoperable Regexp Format

```dart
import 'package:iregexp/iregexp.dart';

// An example of using the IRegexp class.
void main() {
  final iRegexp = IRegexp('[0-9]+.[0-9]+.[0-9]+');
  print(iRegexp.matches('1.2.3')); // true
  print(iRegexp.matches('foo')); // false
}
```

[I-Regexp]: https://datatracker.ietf.org/doc/html/draft-ietf-jsonpath-iregexp-04
