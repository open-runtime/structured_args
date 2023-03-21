import 'package:runtime_structured_cli_args/runtime_structured_cli_args.dart';
import 'package:test/test.dart';

void main() {
  group('annotations', () {
    group('group', () {
      test('constructs', () {
        var group = const Group(
          name: 'Name',
          beforeHelp: 'before',
          afterHelp: 'after',
        );
        expect(group.name, 'Name');
        expect(group.beforeHelp, 'before');
        expect(group.afterHelp, 'after');
      });
    });
  });
}
