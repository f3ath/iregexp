import 'package:iregexp/iregexp.dart';

// An example of using the IRegexp class.
void main() {
  final iRegexp = IRegexp('[0-9]+.[0-9]+.[0-9]+');
  final regex = iRegexp.toRegExp();
  print(regex.hasMatch('1.2.3')); // true
  print(regex.hasMatch('foo')); // false
}
