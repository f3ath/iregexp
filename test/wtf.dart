import 'package:petitparser/petitparser.dart';

void main() {
  final parser = Definition().build();
  print(parser.parse('a.b').value);
}

class Definition extends GrammarDefinition<String> {
  @override
  Parser<String> start() => xx().end();

  Parser<String> xx() => (range('a', 'z') &
          (char('.') | char(',')).map((_) => '|') &
          range('a', 'z'))
      .map((value) => value.join());
}
