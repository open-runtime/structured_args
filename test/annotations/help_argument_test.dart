import 'package:runtime_structured_cli_args/runtime_structured_cli_args.dart';
import 'package:test/test.dart';

void main() {
  group('HelpArgument', () {
    test('specialKeys', () {
      var arg = const HelpArgument();
      expect(arg.specialKeys('h', 'help'), ['-?']);
    });
  });
}
