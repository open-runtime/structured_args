import 'package:smart_arg_fork/smart_arg_fork.dart';
import 'package:test/test.dart';

void main() {
  group('BooleanArgument', () {
    test('emptyList', () {
      var arg = const BooleanArgument();
      // ignore: unnecessary_type_check
      expect(arg.emptyList is List, true);

      // Make sure we can add a bool type directly
      arg.emptyList.add(true);
    });

    test('handleValue verbose', () {
      var arg = const BooleanArgument(long: 'verbose');
      expect(arg.handleValue('verbose', null), true);
    });

    test('handleValue no-verbose', () {
      var arg = const BooleanArgument(long: 'verbose');
      expect(arg.handleValue('no-verbose', null), false);
    });

    test('special keys with non-negate', () {
      var args = const BooleanArgument(short: 'v', long: 'verbose');
      expect(args.specialKeys('v', 'verbose'), <String>[]);
    });

    test('special keys with negate', () {
      var args = const BooleanArgument(
        short: 'v',
        long: 'verbose',
        isNegateable: true,
      );
      expect(args.specialKeys('v', 'verbose'), ['no-verbose']);
    });
  });
}
