import 'package:iregexp/src/iregexp_grammar_definition.dart';

/// A parsed IRegexp expression which can be applied to a string.
/// This class implements the draft-ietf-jsonpath-iregexp-04 specification.
/// See https://tools.ietf.org/html/draft-ietf-jsonpath-iregexp-04
class IRegexp {
  /// Creates an instance from a string. The [pattern] is parsed once, and
  /// the instance may be used many times after that.
  IRegexp(this.pattern)
      : regexp = IRegexpGrammarDefinition.parser.parse(pattern).value;

  /// Returns true if the [pattern] is valid.
  static isValid(String pattern) =>
      IRegexpGrammarDefinition.parser.accept(pattern);

  /// The pattern used to create this instance.
  final String pattern;

  /// The pattern converted to a RegExp-compatible expression.
  final String regexp;

  /// Returns a [RegExp] which matches the same strings as this [pattern].
  RegExp toRegExp() => _regExp('^$regexp\$');

  /// Returns a [RegExp] which matches any substrings matched by [pattern].
  RegExp toSubstringRegExp() => _regExp(regexp);

  RegExp _regExp(String pattern) =>
      RegExp(pattern, unicode: true, multiLine: true);
}
