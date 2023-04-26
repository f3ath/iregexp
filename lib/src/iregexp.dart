import 'package:iregexp/src/iregexp_grammar_definition.dart';

/// A parsed IRegexp expression which can be applied to a string.
/// This class implements the draft-ietf-jsonpath-iregexp-04 specification.
/// See https://tools.ietf.org/html/draft-ietf-jsonpath-iregexp-04
class IRegexp {
  /// Creates an instance from a string. The [pattern] is parsed once, and
  /// the instance may be used many times after that.
  IRegexp(this.pattern)
      : _regexp = IRegexpGrammarDefinition.parser.parse(pattern).value;

  /// The pattern used to create this instance.
  final String pattern;

  /// The pattern converted to a RegExp-compatible expression.
  final String _regexp;

  RegExp? _regExpCached, _substringRegExpCached;

  /// Returns a [RegExp] which matches the same strings as this [pattern].
  RegExp toRegExp() =>
      _regExpCached ?? (_regExpCached = _regExp('^$_regexp\$'));

  /// Returns a [RegExp] which matches any substrings matched by [pattern].
  RegExp toSubstringRegExp() =>
      _substringRegExpCached ?? (_substringRegExpCached = _regExp(_regexp));

  /// Checks whether this [pattern] matches the [input].
  bool matches(String input) => toRegExp().hasMatch(input);

  /// Checks whether this [pattern] matches a substring in the [input].
  bool matchesSubstring(String input) => toSubstringRegExp().hasMatch(input);

  RegExp _regExp(String pattern) => RegExp(pattern, unicode: true);
}
