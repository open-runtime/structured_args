import 'package:smart_arg_fork/smart_arg_fork.dart';
import 'package:test/test.dart';

void main() {
  group('annotations', () {
    group('group', () {
      test('constructs', () {
        var group = Group(
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
