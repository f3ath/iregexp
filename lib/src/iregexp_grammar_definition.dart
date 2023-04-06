import 'package:petitparser/petitparser.dart';

class IRegexpGrammarDefinition extends GrammarDefinition {
  static final parser = IRegexpGrammarDefinition().build();

  @override
  Parser start() => iregexp().end();

  // i-regexp = branch *( "|" branch )
  Parser iregexp() => branch() & (char('|') & branch()).star();

  // branch = *piece
  Parser branch() => piece().star();

  // piece = atom [ quantifier ]
  Parser piece() => atom() & quantifier().optional();

  // quantifier = ( %x2A-2B ; '*'-'+'
  //  / "?" ) / ( "{" quantity "}" )
  Parser quantifier() => anyOf('*+?') | (char('{') & quantity() & char('}'));

  // quantity = QuantExact [ "," [ QuantExact ] ]
  Parser quantity() =>
      quantExact & (char(',') & quantExact.optional()).optional();

  // QuantExact = 1*%x30-39 ; '0'-'9'
  final quantExact = digit().plus();

  // atom = NormalChar / charClass / ( "(" i-regexp ")" )
  Parser atom() =>
      normalChar | charClass() | (char('(') & ref0(iregexp) & char(')'));

  // NormalChar = ( %x00-27 / %x2C-2D ; ','-'-'
  //  / %x2F-3E ; '/'-'>'
  //  / %x40-5A ; '@'-'Z'
  //  / %x5E-7A ; '^'-'z'
  //  / %x7E-10FFFF )
  final normalChar = range('\x00', '\x27') |
      range('\x2C', '\x2D') |
      range('\x2F', '\x3E') |
      range('\x40', '\x5A') |
      range('\x5E', '\x7A') |
      range('\x7E', '\xFF') |
      range('\u{100}', '\u{FFFF}') |
      seq2(
        // Surrogate pairs
        pattern('\uD800-\uDBFF'),
        pattern('\uDC00-\uDFFF'),
      ).flatten();

  // charClass = "." / SingleCharEsc / charClassEsc / charClassExpr
  Parser charClass() =>
      char('.') | singleCharEsc | charClassEsc() | charClassExpr();

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
  Parser catEsc() =>
      char(r'\') & char('p') & char('{') & charProp() & char('}');

  // complEsc = %s"\P{" charProp "}"
  Parser complEsc() =>
      char(r'\') & char('P') & char('{') & charProp() & char('}');

  // charProp = IsCategory
  Parser charProp() => isCategory();

  // IsCategory = Letters / Marks / Numbers / Punctuation / Separators /
  //     Symbols / Others
  Parser isCategory() =>
      letters | marks | numbers | punctuation | separators | symbols | others;

  // Letters = %s"L" [ ( %x6C-6D ; 'l'-'m'
  //  / %s"o" / %x74-75 ; 't'-'u'
  //  ) ]
  final letters = char('L') &
      (range('\x6C', '\x6D') | char('o') | range('\x74', '\x75')).optional();

  // Marks = %s"M" [ ( %s"c" / %s"e" / %s"n" ) ]
  final marks = char('M') & (char('c') | char('e') | char('n')).optional();

  // Numbers = %s"N" [ ( %s"d" / %s"l" / %s"o" ) ]
  final numbers = char('N') & (char('d') | char('l') | char('o')).optional();

  // Punctuation = %s"P" [ ( %x63-66 ; 'c'-'f'
  //  / %s"i" / %s"o" / %s"s" ) ]
  final punctuation = char('P') &
      (range('\x63', '\x66') | char('i') | char('o') | char('s')).optional();

  // Separators = %s"Z" [ ( %s"l" / %s"p" / %s"s" ) ]
  final separators = char('Z') & (char('l') | char('p') | char('s')).optional();

  // Symbols = %s"S" [ ( %s"c" / %s"k" / %s"m" / %s"o" ) ]
  final symbols =
      char('S') & (char('c') | char('k') | char('m') | char('o')).optional();

  // Others = %s"C" [ ( %s"c" / %s"f" / %x6E-6F ; 'n'-'o'
  //  ) ]
  final others = char('C') & anyOf('cfno').optional();
}
