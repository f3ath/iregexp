import 'package:petitparser/petitparser.dart';

class IRegexpGrammarDefinition extends GrammarDefinition {
  static final parser = IRegexpGrammarDefinition().build();

  @override
  Parser<String> start() => iregexp().end();

  final surrogatePairs = seq2(
    // Surrogate pairs
    pattern('\uD800-\uDBFF'),
    pattern('\uDC00-\uDFFF'),
  ).flatten();

  // i-regexp = branch *( "|" branch )
  Parser<String> iregexp() =>
      (branch() & (char('|') & branch()).join().star().join()).join();

  // branch = *piece
  Parser branch() => piece().star().join();

  // piece = atom [ quantifier ]
  Parser<String> piece() =>
      (atom() & quantifier().optional().flatten()).join();

  // quantifier = ( %x2A-2B ; '*'-'+'
  //  / "?" ) / ( "{" quantity "}" )
  Parser quantifier() => anyOf('*+?') | (char('{') & quantity() & char('}'));

  // quantity = QuantExact [ "," [ QuantExact ] ]
  Parser quantity() =>
      quantExact & (char(',') & quantExact.optional()).optional();

  // QuantExact = 1*%x30-39 ; '0'-'9'
  final quantExact = digit().plus().flatten();

  // atom = NormalChar / charClass / ( "(" i-regexp ")" )
  Parser<String> atom() => [
        ref0(normalChar),
        charClass(),
        (char('(') & ref0(iregexp) & char(')')).flatten()
      ].toChoiceParser();

  // NormalChar = ( %x00-27 / %x2C-2D ; ','-'-'
  //  / %x2F-3E ; '/'-'>'
  //  / %x40-5A ; '@'-'Z'
  //  / %x5E-7A ; '^'-'z'
  //  / %x7E-10FFFF )
  Parser<String> normalChar() => [
        range('\x00', '\x27'),
        range('\x2C', '\x2D'),
        range('\x2F', '\x3E'),
        range('\x40', '\x5A'),
        range('\x5E', '\x7A'),
        range('\x7E', '\xFF'),
        range('\u{100}', '\u{FFFF}'),
        surrogatePairs
      ].toChoiceParser();

  // charClass = "." / SingleCharEsc / charClassEsc / charClassExpr
  Parser<String> charClass() => [
        char('.').map((_) => r'[^\r\n]'), // dot is different in iregexp
        singleCharEsc.flatten(),
        charClassEsc().flatten(),
        charClassExpr().flatten()
      ].toChoiceParser();

  // SingleCharEsc = "\" ( %x28-2B ; '('-'+'
  //  / %x2D-2E ; '-'-'.'
  //  / "?" / %x5B-5E ; '['-'^'
  //  / %s"n" / %s"r" / %s"t" / %x7B-7D ; '{'-'}'
  //  )
  final singleCharEsc = char(r'\') &
      (range('\x28', '\x2B') |
          range('\x2D', '\x2E') |
          char('?') |
          range('\x5B', '\x5E') |
          char('n') |
          char('r') |
          char('t') |
          range('\x7B', '\x7D'));

  // charClassEsc = catEsc / complEsc
  Parser charClassEsc() => catEsc() | complEsc();

  // charClassExpr = "[" [ "^" ] ( "-" / CCE1 ) *CCE1 [ "-" ] "]"
  Parser charClassExpr() =>
      char('[') &
      char('^').optional() &
      (char('-') | cce1()).star() &
      char('-').optional() &
      char(']');

  // CCE1 = ( CCchar [ "-" CCchar ] ) / charClassEsc
  Parser cce1() =>
      (ccchar() & (char('-') & ccchar()).optional()) | charClassEsc();

  // CCchar = ( %x00-2C / %x2E-5A ; '.'-'Z'
  //  / %x5E-10FFFF ) / SingleCharEsc
  Parser ccchar() =>
      range('\x00', '\x2C') |
      range('\x2E', '\x5A') |
      range('\x5E', '\xFF') |
      range('\u{100}', '\u{FFFF}') |
      seq2(
        // Surrogate pairs
        pattern('\uD800-\uDBFF'),
        pattern('\uDC00-\uDFFF'),
      ).flatten() |
      singleCharEsc;

  // catEsc = %s"\p{" charProp "}"
  Parser catEsc() => string(r'\p{') & charProp() & char('}');

  // complEsc = %s"\P{" charProp "}"
  Parser complEsc() => string(r'\P{') & charProp() & char('}');

  // charProp = IsCategory
  Parser charProp() => isCategory().flatten();

  // IsCategory = Letters / Marks / Numbers / Punctuation / Separators /
  //     Symbols / Others
  Parser isCategory() =>
      letters | marks | numbers | punctuation | separators | symbols | others;

  // Letters = %s"L" [ ( %x6C-6D ; 'l'-'m'
  //  / %s"o" / %x74-75 ; 't'-'u'
  //  ) ]
  final letters = char('L') & anyOf('lmotu').optional();

  // Marks = %s"M" [ ( %s"c" / %s"e" / %s"n" ) ]
  final marks = char('M') & anyOf('cen').optional();

  // Numbers = %s"N" [ ( %s"d" / %s"l" / %s"o" ) ]
  final numbers = char('N') & anyOf('dlo').optional();

  // Punctuation = %s"P" [ ( %x63-66 ; 'c'-'f'
  //  / %s"i" / %s"o" / %s"s" ) ]
  final punctuation = char('P') & anyOf('cdefios').optional();

  // Separators = %s"Z" [ ( %s"l" / %s"p" / %s"s" ) ]
  final separators = char('Z') & anyOf('lps').optional();

  // Symbols = %s"S" [ ( %s"c" / %s"k" / %s"m" / %s"o" ) ]
  final symbols = char('S') & anyOf('ckmo').optional();

  // Others = %s"C" [ ( %s"c" / %s"f" / %x6E-6F ; 'n'-'o'
  //  ) ]
  final others = char('C') & anyOf('cfno').optional();
}

extension _ParserExtensions on Parser<List> {
  Parser<String> join() => map((list) => list.join());
}
