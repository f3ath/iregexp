import 'package:iregexp/src/iregexp_grammar_definition.dart';
import 'package:petitparser/reflection.dart';
import 'package:test/test.dart';

void main() {
  test('Linter is happy', () {
    final parser = IRegexpGrammarDefinition().build();
    expect(linter(parser), isEmpty);
  });
}
