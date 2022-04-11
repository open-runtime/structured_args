import 'package:smart_arg_fork/smart_arg_fork.dart';
import 'package:test/test.dart';

void main() {
  group('StringArgument', () {
    group('handleValue', () {
      test('simple value', () {
        var arg = const StringArgument();

        expect(arg.handleValue('key', 'hello'), 'hello');
      });

      test('must be one of (valid)', () {
        var arg = const StringArgument(mustBeOneOf: ['hello', 'howdy']);
        expect(arg.handleValue('key', 'hello'), 'hello');
      });

      test('must be one of (invalid)', () {
        try {
          var arg = const StringArgument(mustBeOneOf: ['hello', 'howdy']);
          arg.handleValue('key', 'cya');
          fail('invalid must of should have thrown an error');
        } on ArgumentError {
          expect(1, 1);
        }
      });
    });
  });
}
