import 'package:runtime_structured_cli_args/runtime_structured_cli_args.dart';
import 'package:test/test.dart';

void main() {
  group('Parser', () {
    test('Parser', () {
      var app = const Parser();
      expect(app, isNotNull);
    });
  });
}
