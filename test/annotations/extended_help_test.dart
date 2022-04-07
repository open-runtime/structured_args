import 'package:smart_arg_fork/smart_arg_fork.dart';
import 'package:test/test.dart';

void main() {
  group('ExtendedHelp', () {
    test('construction', () {
      var arg = ExtendedHelp('help text', header: 'header text');
      expect(arg.help, 'help text');
      expect(arg.header, 'header text');
    });
  });
}
