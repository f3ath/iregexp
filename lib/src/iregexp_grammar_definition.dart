import 'package:iregexp/src/ext.dart';
import 'package:petitparser/petitparser.dart';

class IRegexpGrammarDefinition extends GrammarDefinition<String> {
  static final Parser<String> parser = IRegexpGrammarDefinition().build();

  @override
  Parser<String> start() => iregexp().end();

  // i-regexp = branch *( "|" branch )
  Parser<String> iregexp() => [
        branch(),
        [char('|'), branch()].joined().star().joined()
      ].joined();

  // branch = *piece
  Parser<String> branch() => piece().star().joined();

  // piece = atom [ quantifier ]
  Parser<String> piece() => [atom(), quantifier().optional()].joined();

  // quantifier = ( %x2A-2B ; '*'-'+'
  //  / "?" ) / ( "{" quantity "}" )
  Parser<String> quantifier() => [
        anyOf('*+?'),
        [char('{'), quantity(), char('}')].joined()
      ].toChoiceParser();

  // quantity = QuantExact [ "," [ QuantExact ] ]
  Parser<String> quantity() => [
        quantExact,
        [char(','), quantExact.optional()].joined().optional()
      ].joined();

  // QuantExact = 1*%x30-39 ; '0'-'9'
  final quantExact = digit().plus().joined();

  final surrogatePairs = seq2(
    // Surrogate pairs
    pattern('\uD800-\uDBFF'),
    pattern('\uDC00-\uDFFF'),
  ).flatten();

  Parser<String> parens() =>
      [char('('), ref0(iregexp), char(')')].toSequenceParser().joined();

  // atom = NormalChar / charClass / ( "(" i-regexp ")" )
  Parser<String> atom() => [
        normalChar(),
        charClass(),
        parens(),
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

  // See https://datatracker.ietf.org/doc/html/draft-ietf-jsonpath-iregexp-04#section-5.3
  final dot = char('.').map((_) => r'[^\r\n]');

  // charClass = "." / SingleCharEsc / charClassEsc / charClassExpr
  Parser<String> charClass() => [
        dot,
        singleCharEsc,
        charClassEsc(),
        charClassExpr()
      ].toChoiceParser();

  // SingleCharEsc = "\" ( %x28-2B ; '('-'+'
  //  / %x2D-2E ; '-'-'.'
  //  / "?" / %x5B-5E ; '['-'^'
  //  / %s"n" / %s"r" / %s"t" / %x7B-7D ; '{'-'}'
  //  )
  final singleCharEsc = (char(r'\') &
          (range('(', '+') |
              range('-', '.') |
              char('?') |
              range('[', '^') |
              char('n') |
              char('r') |
              char('t') |
              range('{', '}')))
      .flatten();

  // charClassEsc = catEsc / complEsc
  Parser<String> charClassEsc() => [catEsc(), complEsc()].toChoiceParser();

  // charClassExpr = "[" [ "^" ] ( "-" / CCE1 ) *CCE1 [ "-" ] "]"
  Parser<String> charClassExpr() => [
        char('['),
        char('^').optional().flatten(),
        (char('-') | cce1()).star().flatten(),
        char('-').optional().flatten(),
        char(']')
      ].toSequenceParser().flatten();

  // CCE1 = ( CCchar [ "-" CCchar ] ) / charClassEsc
  Parser<String> cce1() => [
        seq2(ccchar(), seq2(char('-'), ccchar()).flatten().optional())
            .flatten(),
        charClassEsc()
      ].toChoiceParser();

  // CCchar = ( %x00-2C / %x2E-5A ; '.'-'Z'
  //  / %x5E-10FFFF ) / SingleCharEsc
  Parser<String> ccchar() => [
        range('\x00', '\x2C'),
        range('\x2E', '\x5A'),
        range('\x5E', '\xFF'),
        range('\u{100}', '\u{FFFF}'),
        surrogatePairs,
        singleCharEsc
      ].toChoiceParser();

  // catEsc = %s"\p{" charProp "}"
  Parser<String> catEsc() =>
      (string(r'\p{') & charProp() & char('}')).flatten();

  // complEsc = %s"\P{" charProp "}"
  Parser<String> complEsc() =>
      (string(r'\P{') & charProp() & char('}')).flatten();

  // charProp = IsCategory
  Parser<String> charProp() => isCategory();

  // IsCategory = Letters / Marks / Numbers / Punctuation / Separators /
  //     Symbols / Others
  Parser<String> isCategory() => [
        letters,
        marks,
        numbers,
        punctuation,
        separators,
        symbols,
        others
      ].toChoiceParser();

  // Letters = %s"L" [ ( %x6C-6D ; 'l'-'m'
  //  / %s"o" / %x74-75 ; 't'-'u'
  //  ) ]
  final letters = (char('L') & anyOf('lmotu').optional()).flatten();

  // Marks = %s"M" [ ( %s"c" / %s"e" / %s"n" ) ]
  final marks = (char('M') & anyOf('cen').optional()).flatten();

  // Numbers = %s"N" [ ( %s"d" / %s"l" / %s"o" ) ]
  final numbers = (char('N') & anyOf('dlo').optional()).flatten();

  // Punctuation = %s"P" [ ( %x63-66 ; 'c'-'f'
  //  / %s"i" / %s"o" / %s"s" ) ]
  final punctuation = (char('P') & pattern('c-fios').optional()).flatten();

  // Separators = %s"Z" [ ( %s"l" / %s"p" / %s"s" ) ]
  final separators = (char('Z') & anyOf('lps').optional()).flatten();

  // Symbols = %s"S" [ ( %s"c" / %s"k" / %s"m" / %s"o" ) ]
  final symbols = (char('S') & anyOf('ckmo').optional()).flatten();

  // Others = %s"C" [ ( %s"c" / %s"f" / %x6E-6F ; 'n'-'o' ) ]
  final others = (char('C') & anyOf('cfno').optional()).flatten();
}

extension _ParserExtensions on Parser<List> {
  Parser<String> join() => map((list) => list.join());
}
