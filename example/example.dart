import 'package:iregexp/iregexp.dart';

// An example of using the IRegexp class.
void main() {
  final iRegexp = IRegexp('[0-9]+.[0-9]+.[0-9]+');
  print(iRegexp.matches('1.2.3')); // true
  print(iRegexp.matches('foo')); // false
}
