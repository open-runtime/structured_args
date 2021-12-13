import 'package:smart_arg_fork/smart_arg_fork.dart';
import 'package:test/test.dart';

void main() {
  group('HelpArgument', () {
    test('specialKeys', () {
      var arg = HelpArgument();
      expect(arg.specialKeys('h', 'help'), ['-?']);
    });
  });
}
