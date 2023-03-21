import 'package:runtime_structured_cli_args/runtime_structured_cli_args.dart';
import 'package:test/test.dart';

enum Echo { hello, world, helloWorld }

void main() {
  group('EnumArgument', () {
    group('handleValue', () {
      test('simple value', () {
        var arg = const EnumArgument<Echo>(values: Echo.values);

        expect(arg.handleValue('key', 'hello'), Echo.hello);
      });

      test('cased value', () {
        var arg = const EnumArgument<Echo>(values: Echo.values);

        expect(arg.handleValue('key', 'hello-world'), Echo.helloWorld);
        expect(arg.handleValue('key', 'helloWorld'), Echo.helloWorld);
        expect(arg.handleValue('key', 'HelloWorld'), Echo.helloWorld);
      });

      test('must be one of (invalid)', () {
        try {
          var arg = const EnumArgument<Echo>(values: Echo.values);
          arg.handleValue('key', 'earth');
          fail('invalid must of should have thrown an error');
        } on ArgumentError {
          expect(1, 1);
        }
      });

      test('additional help lines', () {
        var arg = const EnumArgument<Echo>(values: Echo.values);
        var help = arg.additionalHelpLines;

        expect(help, ['must be one of hello, world, hello-world']);
      });
    });
  });
}
