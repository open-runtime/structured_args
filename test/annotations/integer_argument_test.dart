import 'package:smart_arg_fork/smart_arg_fork.dart';
import 'package:test/test.dart';

void main() {
  group('IntegerArgument', () {
    group('handleValue', () {
      test('simple value', () {
        var arg = IntegerArgument();

        expect(arg.handleValue('key', '300'), 300);
      });

      group('minimum/maximum', () {
        test('in range', () {
          var arg = IntegerArgument(minimum: 100, maximum: 500);
          expect(arg.handleValue('key', '300'), 300);
        });

        test('too low', () {
          try {
            var arg = IntegerArgument(minimum: 100, maximum: 500);
            var _ = arg.handleValue('key', '95');

            fail('value lower than minimum should have thrown an exception');
          } on ArgumentError {
            expect(1, 1);
          }
        });

        test('too high', () {
          try {
            var arg = IntegerArgument(minimum: 100, maximum: 500);
            var _ = arg.handleValue('key', '505');

            fail('value higher than maximum should have thrown an exception');
          } on ArgumentError {
            expect(1, 1);
          }
        });
      });
    });
  });
}
