import 'package:runtime_structured_cli_args/runtime_structured_cli_args.dart';
import 'package:test/test.dart';

void main() {
  group('reflector', () {
    test('constructs', () {
      var _ = Reflector.reflector;
      expect(1, 1);
    });
  });
}
