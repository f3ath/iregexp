import 'package:iregexp/iregexp.dart';
import 'package:test/test.dart';

void main() {
  group('match successful', () {
    final testData = [
      [r'[0-9\.]+', '123', 'match digits and dots'],
      [r'[0-9\.]+', '123.456', 'match digits and dots'],
      [r'a+\.b+', 'aa.bbb', 'the test'],
      [r'foo|bar', 'foo', 'alternation'],
      [r'[ab]{3}', 'aba', 'exact quantity'],
      [r'[ab]{3,5}', 'abab', 'min and max quantity'],
      [r'[^ab]', 'c', 'character class negation'],
      [r'\p{L}', 'a', 'unicode character category letter'],
      [r'\p{Lu}', 'A', 'unicode character category letter uppercase'],
      [r'\p{Ll}', 'a', 'unicode character category letter lowercase'],
      [r'\p{Lt}', 'ǅ', 'unicode character category letter titlecase'],
      [r'\p{Lm}', 'ʰ', 'unicode character category letter modifier'],
      [r'\p{Lo}', 'ƻ', 'unicode character category letter other'],
      [r'\p{Mn}', '̃', 'unicode character category mark nonspacing'],
      [r'\p{Mc}', 'ः', 'unicode character category mark spacing combining'],
      [r'\p{Me}', '⃣', 'unicode character category mark enclosing'],
      [r'\p{Nd}', '0', 'unicode character category number decimal digit'],
      [r'\p{Nl}', 'Ⅻ', 'unicode character category number letter'],
      [r'\p{No}', '¼', 'unicode character category number other'],
      [r'\p{Pc}', '‿', 'unicode character category punctuation connector'],
      [r'\p{Pd}', '‐', 'unicode character category punctuation dash'],
      [r'\p{Ps}', '(', 'unicode character category punctuation open'],
      [r'\p{Pe}', ')', 'unicode character category punctuation close'],
      [r'\p{Pi}', '‘', 'unicode character category punctuation initial quote'],
      [r'\p{Pf}', '’', 'unicode character category punctuation final quote'],
      [r'\p{Po}', '‽', 'unicode character category punctuation other'],
      [r'\p{Sm}', '∀', 'unicode character category symbol math'],
      [r'\p{Sc}', '¤', 'unicode character category symbol currency'],
      [r'\p{Sk}', '˚', 'unicode character category symbol modifier'],
      [r'\p{So}', '©', 'unicode character category symbol other'],
      [r'\p{Zs}', ' ', 'unicode character category separator space'],
      [r'\p{Zl}', ' ', 'unicode character category separator line'],
      [r'\p{Zp}', ' ', 'unicode character category separator paragraph'],
      [r'\p{Cc}', '\u0000', 'unicode character category other control'],
      [r'\p{Cf}', '\u00AD', 'unicode character category other format'],
      [r'\p{Co}', '\uE000', 'unicode character category other private use'],
      [r'\p{Cn}', '\u0378', 'unicode character category other not assigned'],
      // inverted categories
      [r'\P{L}', '1', 'unicode character category letter'],
      [r'\P{Lu}', 'a', 'unicode character category letter uppercase'],
      [r'\P{Ll}', 'A', 'unicode character category letter lowercase'],
      [r'\P{Lt}', 'a', 'unicode character category letter titlecase'],
      [r'\P{Lm}', 'a', 'unicode character category letter modifier'],
      [r'\P{Lo}', 'a', 'unicode character category letter other'],
      [r'\P{Mn}', 'a', 'unicode character category mark nonspacing'],
      [r'\P{Mc}', 'a', 'unicode character category mark spacing combining'],
      [r'\P{Me}', 'a', 'unicode character category mark enclosing'],
      [r'\P{Nd}', 'a', 'unicode character category number decimal digit'],
      [r'\P{Nl}', 'a', 'unicode character category number letter'],
      [r'\P{No}', 'a', 'unicode character category number other'],
      [r'\P{Pc}', 'a', 'unicode character category punctuation connector'],
      [r'\P{Pd}', 'a', 'unicode character category punctuation dash'],
      [r'\P{Ps}', 'a', 'unicode character category punctuation open'],
      [r'\P{Pe}', 'a', 'unicode character category punctuation close'],
      [r'\P{Pi}', 'a', 'unicode character category punctuation initial quote'],
      [r'\P{Pf}', 'a', 'unicode character category punctuation final quote'],
      [r'\P{Po}', 'a', 'unicode character category punctuation other'],
      [r'\P{Sm}', 'a', 'unicode character category symbol math'],
      [r'\P{Sc}', 'a', 'unicode character category symbol currency'],
      [r'\P{Sk}', 'a', 'unicode character category symbol modifier'],
      [r'\P{So}', 'a', 'unicode character category symbol other'],
      [r'\P{Zs}', 'a', 'unicode character category separator space'],
      [r'\P{Zl}', 'a', 'unicode character category separator line'],
      [r'\P{Zp}', 'a', 'unicode character category separator paragraph'],
      [r'\P{Cc}', 'a', 'unicode character category other control'],
      [r'\P{Cf}', 'a', 'unicode character category other format'],
      [r'\P{Co}', 'a', 'unicode character category other private use'],
      [r'\P{Cn}', 'a', 'unicode character category other not assigned'],
    ];
    for (final data in testData) {
      test(data[2], () {
        expect(IRegexp(data[0]).toRegExp().hasMatch(data[1]), isTrue);
      });
    }
  });

  group('match failed', () {
    final testData = [
      [r'[0-9\.]+', 'abc', 'match digits and dots'],
      [r'foo|bar', 'baz', 'alternation'],
      [r'[ab]{3}', 'a', 'exact quantity'],
      [r'[ab]{3,5}', 'a', 'min and max quantity'],
      [r'[^ab]', 'a', 'character class negation'],
      [r'\p{L}', '1', 'unicode character category letter'],
      [r'\p{Lu}', 'a', 'unicode character category letter uppercase'],
      [r'\p{Ll}', 'A', 'unicode character category letter lowercase'],
      [r'\p{Lt}', 'a', 'unicode character category letter titlecase'],
      [r'\p{Lm}', 'a', 'unicode character category letter modifier'],
      [r'\p{Lo}', 'a', 'unicode character category letter other'],
      [r'\p{Mn}', 'a', 'unicode character category mark nonspacing'],
      [r'\p{Mc}', 'a', 'unicode character category mark spacing combining'],
      [r'\p{Me}', 'a', 'unicode character category mark enclosing'],
      [r'\p{Nd}', 'a', 'unicode character category number decimal digit'],
      [r'\p{Nl}', 'a', 'unicode character category number letter'],
      [r'\p{No}', 'a', 'unicode character category number other'],
      [r'\p{Pc}', 'a', 'unicode character category punctuation connector'],
      [r'\p{Pd}', 'a', 'unicode character category punctuation dash'],
      [r'\p{Ps}', 'a', 'unicode character category punctuation open'],
      [r'\p{Pe}', 'a', 'unicode character category punctuation close'],
      [r'\p{Pi}', 'a', 'unicode character category punctuation initial quote'],
      [r'\p{Pf}', 'a', 'unicode character category punctuation final quote'],
      [r'\p{Po}', 'a', 'unicode character category punctuation other'],
      [r'\p{Sm}', 'a', 'unicode character category symbol math'],
      [r'\p{Sc}', 'a', 'unicode character category symbol currency'],
      [r'\p{Sk}', 'a', 'unicode character category symbol modifier'],
      [r'\p{So}', 'a', 'unicode character category symbol other'],
      [r'\p{Zs}', 'a', 'unicode character category separator space'],
      [r'\p{Zl}', 'a', 'unicode character category separator line'],
      [r'\p{Zp}', 'a', 'unicode character category separator paragraph'],
      [r'\p{Cc}', 'a', 'unicode character category other control'],
      [r'\p{Cf}', 'a', 'unicode character category other format'],
      [r'\p{Co}', 'a', 'unicode character category other private use'],
      [r'\p{Cn}', 'a', 'unicode character category other not assigned'],
      // inverted categories
      [r'\P{L}', 'a', 'unicode character category letter'],
      [r'\P{Lu}', 'A', 'unicode character category letter uppercase'],
      [r'\P{Ll}', 'a', 'unicode character category letter lowercase'],
      [r'\P{Lt}', 'ǅ', 'unicode character category letter titlecase'],
      [r'\P{Lm}', 'ʰ', 'unicode character category letter modifier'],
      [r'\P{Lo}', 'ƻ', 'unicode character category letter other'],
      [r'\P{Mn}', '̃', 'unicode character category mark nonspacing'],
      [r'\P{Mc}', 'ः', 'unicode character category mark spacing combining'],
      [r'\P{Me}', '⃣', 'unicode character category mark enclosing'],
      [r'\P{Nd}', '0', 'unicode character category number decimal digit'],
      [r'\P{Nl}', 'Ⅻ', 'unicode character category number letter'],
      [r'\P{No}', '¼', 'unicode character category number other'],
      [r'\P{Pc}', '‿', 'unicode character category punctuation connector'],
      [r'\P{Pd}', '‐', 'unicode character category punctuation dash'],
      [r'\P{Ps}', '(', 'unicode character category punctuation open'],
      [r'\P{Pe}', ')', 'unicode character category punctuation close'],
      [r'\P{Pi}', '‘', 'unicode character category punctuation initial quote'],
      [r'\P{Pf}', '’', 'unicode character category punctuation final quote'],
      [r'\P{Po}', '‽', 'unicode character category punctuation other'],
      [r'\P{Sm}', '∀', 'unicode character category symbol math'],
      [r'\P{Sc}', '¤', 'unicode character category symbol currency'],
      [r'\P{Sk}', '˚', 'unicode character category symbol modifier'],
      [r'\P{So}', '©', 'unicode character category symbol other'],
      [r'\P{Zs}', ' ', 'unicode character category separator space'],
      [r'\P{Zl}', ' ', 'unicode character category separator line'],
      [r'\P{Zp}', ' ', 'unicode character category separator paragraph'],
      [r'\P{Cc}', '\u0000', 'unicode character category other control'],
      [r'\P{Cf}', '\u00AD', 'unicode character category other format'],
      [r'\P{Co}', '\uE000', 'unicode character category other private use'],
      [r'\P{Cn}', '\u0378', 'unicode character category other not assigned'],
    ];
    for (final data in testData) {
      test(data[2], () {
        expect(IRegexp(data[0]).toRegExp().hasMatch(data[1]), isFalse);
      });
    }
  });

  group('invalid regex', () {
    final invalid = [
      [r'(?<group>[a-z]+)', 'named groups'],
      [r'[\S ]+', 'character classes'],
      [r'\S+', 'character classes'],
      [r'\d*(\.\d*){1,127}', 'character classes'],
      [r'(\w)\1', 'backreferences'],
      [r'(?=.*[a-z])(?=.*[A-Z])(?=.*)[a-zA-Z]{8,}', 'lookaheads'],
      [r'(?<=[a-z]{4})\[a-z]{2}', 'lookbehinds'],
      [r'(?:[a-z]+)', 'non-capturing groups'],
      [r'(?>[a-z]+)', 'atomic groups'],
      [r'(?(1)a|b)', 'conditional groups'],
      [r'(?#comment)', 'comments'],
      [r'(?i)[a-z]+', 'flags'],
      [r'(?m)^.*$', 'line breaks'],
      [r'(?u)\w+', 'unicode'],
      [r'(?s).+', 'dotall'],
      [r'(?x)\w+', 'extended'],
      [r'\p{IsBasicLatin}', 'unicode properties'],
    ];

    for (final data in invalid) {
      test(data[1], () {
        expect(() => IRegexp(data[0]), throwsFormatException);
      });
    }
  });

  test('Full and partial match', () {
    final regex = IRegexp(r'ab+');
    expect(regex.toRegExp().hasMatch('ab'), isTrue);
    expect(regex.toRegExp().hasMatch('abbott'), isFalse);
    expect(regex.toRegExp().hasMatch('cabbb'), isFalse);
    expect(regex.toSubstringRegExp().hasMatch('abbott'), isTrue);
    expect(regex.toSubstringRegExp().hasMatch('cabbb'), isTrue);
  });
}
