import 'package:iregexp/src/iregexp_grammar_definition.dart';

/// A parsed IRegexp expression which can be applied to a string.
/// This class implements the draft-ietf-jsonpath-iregexp-04 specification.
/// See https://tools.ietf.org/html/draft-ietf-jsonpath-iregexp-04
class IRegexp {
  /// Creates an instance from a string. The [pattern] is parsed once, and
  /// the instance may be used many times after that.
  IRegexp(this.pattern)
      : _regex = IRegexpGrammarDefinition.parser.parse(pattern).value;

  /// The pattern used to create this instance.
  final String pattern;

  /// The regular expression generated from the pattern.
  final String _regex;

  /// Returns a [RegExp] which matches the same strings as this [pattern].
  RegExp toRegExp() => _regExp('^$_regex\$');

  /// Returns a [RegExp] which matches any substrings matched by [pattern].
  RegExp toSubstringRegExp() => _regExp(_regex);

  RegExp _regExp(String expression) => RegExp(expression, unicode: true);
}
