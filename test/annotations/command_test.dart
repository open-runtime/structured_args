import 'package:runtime_structured_cli_args/runtime_structured_cli_args.dart';
import 'package:test/test.dart';

void main() {
  group('argument', () {
    group('command', () {
      test('handleValue', () {
        var c = const Command(help: 'Blah Command');

        // Make sure no exceptions
        c.handleValue('key', null);

        expect(1, 1);
      });
    });
  });
}
