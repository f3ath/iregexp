import 'package:petitparser/petitparser.dart';

extension ParserExt1 on Parser<List<String>> {
  Parser<String> joined() => map((list) => list.join());
}

extension ParserExt2 on Parser<List<String?>> {
  Parser<String> joined() => map((list) => list.whereType<String>().join());
}

extension ListExt1 on List<Parser<String>> {
  Parser<String> joined() => toSequenceParser().joined();
}

extension ListExt2 on List<Parser<String?>> {
  Parser<String> joined() => toSequenceParser().joined();
}
