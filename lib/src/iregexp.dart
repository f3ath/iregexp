import 'package:iregexp/src/iregexp_grammar_definition.dart';
import 'package:petitparser/petitparser.dart';

/// A parsed IRegexp expression which can be applied to a string.
/// This class implements the draft-ietf-jsonpath-iregexp-04 specification.
/// See https://tools.ietf.org/html/draft-ietf-jsonpath-iregexp-04
class IRegexp {
  /// Creates an instance from a string. The [pattern] is parsed once, and
  /// the instance may be used many times after that.
  IRegexp(this.pattern) {
    if (!isValid(pattern)) {
      throw FormatException('Invalid IRegexp "$pattern"');
    }
  }

  /// Returns true if the [pattern] is valid.
  static isValid(String pattern) =>
      IRegexpGrammarDefinition.parser.accept(pattern);

  /// The pattern used to create this instance.
  final String pattern;

  /// Returns a [RegExp] which matches the same strings as this [pattern].
  RegExp toRegExp() => RegExp('^$pattern\$', unicode: true);

  /// Returns a [RegExp] which matches any substrings matched by [pattern].
  RegExp toSubstringRegExp() => RegExp(pattern, unicode: true);
}
