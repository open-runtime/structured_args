import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:runtime_structured_cli_args/runtime_structured_cli_args.dart';
import 'package:test/test.dart';

void main() {
  group('DirectoryArgument', () {
    test('emptyList', () {
      var arg = const DirectoryArgument();
      // ignore: unnecessary_type_check
      expect(arg.emptyList is List, true);

      // Make sure we can add a Directory type directly
      arg.emptyList.add(Directory('.'));
    });

    group('handleValue', () {
      test('returns directory', () {
        var arg = const DirectoryArgument();
        var value = arg.handleValue('dir', path.join('.', 'lib'));

        expect(value.path, contains('${path.separator}lib'));
      });

      group('must exist', () {
        test('exists', () {
          var arg = const DirectoryArgument(mustExist: true);
          var value = arg.handleValue('dir', path.join('.', 'lib'));

          expect(value.path, contains('${path.separator}lib'));
        });

        test('does not exists', () {
          var arg = const DirectoryArgument(mustExist: true);

          try {
            var _ = arg.handleValue('dir', path.join('.', 'bad-directory-name'));
            fail(
              'directory does not exist, an exception should have been thrown',
            );
          } on ArgumentError {
            expect(1, 1);
          }
        });
      });
    });
  });
}
