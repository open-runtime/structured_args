import 'package:smart_arg/smart_arg.dart';
import 'package:test/test.dart';

enum Echo { hello, world, helloWorld }

void main() {
  group('EnumArgument', () {
    group('handleValue', () {
      test('simple value', () {
        final arg = EnumArgument<Echo>(values: Echo.values);

        expect(arg.handleValue('key', 'hello'), Echo.hello);
      });

      test('cased value', () {
        final arg = EnumArgument<Echo>(values: Echo.values);

        expect(arg.handleValue('key', 'hello-world'), Echo.helloWorld);
        expect(arg.handleValue('key', 'helloWorld'), Echo.helloWorld);
        expect(arg.handleValue('key', 'HelloWorld'), Echo.helloWorld);
      });

      test('must be one of (invalid)', () {
        try {
          final arg = EnumArgument<Echo>(values: Echo.values);
          arg.handleValue('key', 'earth');
          fail('invalid must of should have thrown an error');
        } on ArgumentError {
          expect(1, 1);
        }
      });

      test('additional help lines', () {
        final arg = EnumArgument<Echo>(values: Echo.values);
        final List<String> help = arg.additionalHelpLines;

        expect(help, ['must be one of hello, world, hello-world']);
      });
    });
  });
}
