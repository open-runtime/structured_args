import 'package:runtime_structured_cli_args/runtime_structured_cli_args.dart';
import 'package:test/test.dart';

void main() {
  group('ExtendedHelp', () {
    test('construction', () {
      var arg = const ExtendedHelp('help text', header: 'header text');
      expect(arg.help, 'help text');
      expect(arg.header, 'header text');
    });
  });
}
