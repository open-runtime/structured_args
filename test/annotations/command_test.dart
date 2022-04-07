import 'package:smart_arg_fork/smart_arg_fork.dart';
import 'package:test/test.dart';

void main() {
  group('argument', () {
    group('command', () {
      test('handleValue', () {
        var c = Command(help: 'Blah Command');

        // Make sure no exceptions
        c.handleValue('key', null);

        expect(1, 1);
      });
    });
  });
}
