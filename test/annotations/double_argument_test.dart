import 'package:runtime_structured_cli_args/runtime_structured_cli_args.dart';
import 'package:test/test.dart';

void main() {
  group('DoubleArgument', () {
    group('handleValue', () {
      test('simple value', () {
        var arg = const DoubleArgument();

        expect(arg.handleValue('key', '300'), 300);
      });

      group('minimum/maximum', () {
        test('in range', () {
          var arg = const DoubleArgument(minimum: 99.9, maximum: 499.9);
          expect(arg.handleValue('key', '300.0'), 300.0);
        });

        test('too low', () {
          try {
            var arg = const DoubleArgument(minimum: 99.9, maximum: 499.9);
            var _ = arg.handleValue('key', '99.8');

            fail('value lower than minimum should have thrown an exception');
          } on ArgumentError {
            expect(1, 1);
          }
        });

        test('too high', () {
          try {
            var arg = const DoubleArgument(minimum: 99.9, maximum: 499.9);
            var _ = arg.handleValue('key', '499.91');

            fail('value higher than maximum should have thrown an exception');
          } on ArgumentError {
            expect(1, 1);
          }
        });
      });
    });
  });
}
