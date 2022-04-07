import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:smart_arg_fork/smart_arg_fork.dart';
import 'package:test/test.dart';

import '../smart_arg_test.reflectable.dart';

@SmartArg.reflectable
@Parser(
  exitOnFailure: false,
  description: 'app-description',
  extendedHelp: [
    ExtendedHelp('This is some help', header: 'extended-help'),
    ExtendedHelp('Non-indented help'),
  ],
)
class TestSimple extends SmartArg {
  @BooleanArgument(isNegateable: true, help: 'bvalue-help')
  bool? bvalue;

  @IntegerArgument(short: 'i')
  int? ivalue;

  @DoubleArgument(isRequired: true)
  double? dvalue;

  @StringArgument()
  String? svalue;

  @FileArgument()
  File? fvalue;

  @DirectoryArgument()
  Directory? dirvalue;

  @StringArgument()
  String? checkingCamelToDash;
}

@SmartArg.reflectable
@Parser(exitOnFailure: false)
class TestMultipleShortArgsSameKey extends SmartArg {
  @IntegerArgument(short: 'a')
  int? abc;

  @IntegerArgument(short: 'a')
  int? xyz;
}

@SmartArg.reflectable
@Parser(exitOnFailure: false)
class TestMultipleLongArgsSameKey extends SmartArg {
  @IntegerArgument(long: 'abc')
  int? abc;

  @IntegerArgument(long: 'abc')
  int? xyz;
}

@SmartArg.reflectable
@Parser(exitOnFailure: false, minimumExtras: 1, maximumExtras: 3)
class TestMinimumMaximumExtras extends SmartArg {
  @IntegerArgument()
  int? a;
}

@SmartArg.reflectable
@Parser(exitOnFailure: false)
class TestFileDirectoryMustExist extends SmartArg {
  @FileArgument(mustExist: true)
  late File file;

  @DirectoryArgument(mustExist: true)
  late Directory directory;
}

@SmartArg.reflectable
@Parser(exitOnFailure: false)
class TestShortAndLongSameKey extends SmartArg {
  @IntegerArgument(short: 'a')
  int? abc;

  @IntegerArgument()
  int? a; // This is the same as the short for 'abc'
}

@SmartArg.reflectable
@Parser(exitOnFailure: false)
class TestMultipleLineArgumentHelp extends SmartArg {
  @BooleanArgument(short: 'a', help: 'Silly help message', isRequired: true)
  bool? thisIsAReallyLongParameterNameThatWillCauseWordWrapping;

  @BooleanArgument(short: 'b', help: 'Another help message here')
  bool? moreReasonableName;
}

@SmartArg.reflectable
@Parser(exitOnFailure: false)
class TestLongKeyHandling extends SmartArg {
  @StringArgument(long: 'over-ride-long-item-name')
  String? longItem;

  @StringArgument(long: false, short: 'n')
  String? itemWithNoLong;
}

@SmartArg.reflectable
@Parser(exitOnFailure: false)
class TestMustBeOneOf extends SmartArg {
  @StringArgument(mustBeOneOf: ['hello', 'howdy', 'goodbye', 'cya'])
  String? greeting;
}

@SmartArg.reflectable
@Parser(exitOnFailure: false, strict: true)
class TestParserStrict extends SmartArg {
  @IntegerArgument(short: 'n')
  int? nono;

  @BooleanArgument(long: 'say-hello')
  bool? shouldSayHello;
}

@SmartArg.reflectable
@Parser(exitOnFailure: false)
class TestIntegerDoubleMinMax extends SmartArg {
  @IntegerArgument(minimum: 1, maximum: 5)
  int? intValue;

  @DoubleArgument(minimum: 1.5, maximum: 4.5)
  double? doubleValue;
}

@SmartArg.reflectable
@Parser(exitOnFailure: false)
class TestMultiple extends SmartArg {
  @StringArgument()
  late List<String> names;

  @StringArgument()
  String? name;
}

@SmartArg.reflectable
@Parser(exitOnFailure: false)
class TestHelpArgument extends SmartArg {}

@SmartArg.reflectable
@Parser(exitOnFailure: false)
class TestInvalidShortKeyName extends SmartArg {
  @StringArgument(short: '-n')
  String? name;
}

@SmartArg.reflectable
@Parser(exitOnFailure: false)
class TestInvalidLongKeyName extends SmartArg {
  @StringArgument(long: '-n')
  String? name;
}

@SmartArg.reflectable
@Parser(exitOnFailure: false)
class TestArgumentTerminatorDefault extends SmartArg {
  @StringArgument()
  String? name;

  @StringArgument()
  String? other;
}

@SmartArg.reflectable
@Parser(exitOnFailure: false, argumentTerminator: null)
class TestArgumentTerminatorNull extends SmartArg {
  @StringArgument()
  String? name;

  @StringArgument()
  String? other;
}

@SmartArg.reflectable
@Parser(exitOnFailure: false, argumentTerminator: '--args')
class TestArgumentTerminatorSet extends SmartArg {
  @StringArgument()
  String? name;

  @StringArgument()
  String? other;
}

@SmartArg.reflectable
@Parser(exitOnFailure: false, allowTrailingArguments: false)
class TestDisallowTrailingArguments extends SmartArg {
  @StringArgument()
  String? name;

  @StringArgument()
  String? other;
}

@SmartArg.reflectable
@Parser(exitOnFailure: false)
class TestAllowTrailingArguments extends SmartArg {
  @StringArgument()
  String? name;

  @StringArgument()
  String? other;
}

@SmartArg.reflectable
@Parser(exitOnFailure: false)
class TestStackedBooleanArguments extends SmartArg {
  @BooleanArgument(short: 'a')
  bool? avalue;

  @BooleanArgument(short: 'b')
  bool? bvalue;

  @BooleanArgument(short: 'c')
  bool? cvalue;

  @BooleanArgument(short: 'd')
  bool? dvalue;
}

@SmartArg.reflectable
@Parser(exitOnFailure: false)
class TestNoKey extends SmartArg {
  @StringArgument(long: false)
  String? long;
}

@SmartArg.reflectable
@Parser(exitOnFailure: false)
class TestWithDefaultValue extends SmartArg {
  @StringArgument()
  String long = 'hello';
}

@SmartArg.reflectable
@Parser(exitOnFailure: false)
class TestWithEnvironmentValue extends SmartArg {
  @StringArgument(environmentVariable: 'TEST_HELLO')
  String long = 'hello';
}

@SmartArg.reflectable
@Parser(exitOnFailure: false)
class TestWithNonAnnotationValue extends SmartArg {
  @StringArgument()
  String long = 'hello';

  final String noAnnotation = 'Not Reflected';
  String eagerProperty = 'Eager';
  late String lateProperty = '$eagerProperty should be late';
}

@SmartArg.reflectable
@Parser(exitOnFailure: false, extendedHelp: [ExtendedHelp(null)])
class TestBadExtendedHelp extends SmartArg {}

@SmartArg.reflectable
@Parser(exitOnFailure: false, description: 'A unit test example')
class TestArgumentGroups extends SmartArg {
  @Group(
    name: 'PERSONALIZATION',
    beforeHelp: 'Before personalization arguments',
    afterHelp: 'After personalization arguments',
  )
  @StringArgument(help: 'Name of person to say hello to')
  String? name;

  @StringArgument(help: 'Greeting to use when greeting the person')
  String? greeting;

  @Group(name: 'CONFIGURATION')
  @IntegerArgument(help: 'How many times do you wish to greet the person?')
  int count = 1;
}

@SmartArg.reflectable
class BaseArg extends SmartArg {
  @IntegerArgument(help: 'A integer value, added via the BaseArg class')
  int? baseValue;
}

@SmartArg.reflectable
//Explicit `class` declaration keyword for tests. `mixin` keyword should be preferred
class StringMixin {
  @StringArgument(help: 'A string value, added via the StringMixin class')
  String? stringValue;
}

@SmartArg.reflectable
mixin DoubleMixin {
  @DoubleArgument(help: 'A double value, added via the DoubleMixin class')
  double? doubleValue;
}

@SmartArg.reflectable
@Parser(exitOnFailure: false)
class ChildExtension extends BaseArg with DoubleMixin, StringMixin {
  @BooleanArgument(help: 'A boolean value, added via the ChildExtension class')
  bool? childValue;
}

String? whatExecuted;

void main() {
  initializeReflectable();

  group('argument parsing/assignment', () {
    test('basic arguments', () async {
      var args = TestSimple();
      await args.parse([
        '--bvalue',
        '--ivalue',
        '500',
        '--dvalue',
        '12.625',
        '--svalue',
        'hello',
        '--fvalue',
        'hello.txt',
        '--dirvalue',
        '.',
        '--checking-camel-to-dash',
        'yes-it-works',
        'extra1',
        'extra2',
      ]);

      expect(args.bvalue, true);
      expect(args.ivalue, 500);
      expect(args.dvalue, 12.625);
      expect(args.svalue, 'hello');
      expect(args.fvalue is File, true);
      expect(args.dirvalue is Directory, true);
      expect(args.checkingCamelToDash, 'yes-it-works');
      expect(args.extras!.length, 2);
    });

    test('--no-bvalue', () async {
      var args = TestSimple();
      await args.parse(['--no-bvalue', '--dvalue=10.0']);

      expect(args.bvalue, false);
    });

    test('short key', () async {
      var args = TestSimple();
      await args.parse(['-i', '300', '--dvalue=10.0']);

      expect(args.ivalue, 300);
    });

    test('stacked boolean flags', () async {
      var args = TestStackedBooleanArguments();
      await args.parse(['-ab', '-c']);
      expect(args.avalue, true);
      expect(args.bvalue, true);
      expect(args.cvalue, true);
      expect(args.dvalue, null);
    });

    test('long key with equal', () async {
      var args = TestSimple();
      await args.parse(['--ivalue=450', '--dvalue=55.5', '--svalue=John']);

      expect(args.ivalue, 450);
      expect(args.dvalue, 55.5);
      expect(args.svalue, 'John');
    });

    group('default value', () {
      test('default value exists if no argument given', () async {
        var args = TestWithDefaultValue();
        await args.parse([]);
        expect(args.long, 'hello');
      });

      test('value supplied overrides default value', () async {
        var args = TestWithDefaultValue();
        await args.parse(['--long', 'goodbye']);
        expect(args.long, 'goodbye');
      });
    });

    group('environment value', () {
      var environmentValue = 'Hello from the Environment';
      var environment = <String, String>{'TEST_HELLO': environmentValue};

      test('default value exists if no value found in environment', () async {
        var args = TestWithEnvironmentValue()..withEnvironment({});
        await args.parse([]);
        expect(args.long, 'hello');
      });

      test('environment variable supplied overrides default value', () async {
        var args = TestWithEnvironmentValue()..withEnvironment(environment);
        await args.parse([]);
        expect(args.long, environmentValue);
      });

      test('value supplied overrides environment value', () async {
        var args = TestWithEnvironmentValue()..withEnvironment(environment);
        await args.parse(['--long', 'goodbye']);
        expect(args.long, 'goodbye');
      });
    });

    group('non-annotated values', () {
      test('can exist within a command', () async {
        var args = TestWithNonAnnotationValue();
        await args.parse([]);
        expect(args.long, 'hello');
        expect(args.lateProperty, 'Eager should be late');
        expect(args.noAnnotation, 'Not Reflected');
      });

      test('properties can be late for lazy evaluation', () async {
        var args = TestWithNonAnnotationValue();
        await args.parse([]);
        expect(args.eagerProperty, 'Eager');
        args.eagerProperty = 'Now Late';
        expect(args.lateProperty, 'Now Late should be late');
        args.eagerProperty = 'Back to Eager';
        expect(args.lateProperty, 'Now Late should be late');
      });
    });

    group('list handling', () {
      test('allow', () async {
        var args = TestMultiple();
        await args.parse(['--names=John', '--names', 'Jack']);
        expect(args.names[0], 'John');
        expect(args.names[1], 'Jack');
      });

      test('disallow but supply multiple', () async {
        try {
          var args = TestMultiple();
          await args.parse(['--name=John', '--name=Jack']);
          fail(
            'supplying multiple parameters when allowMultiple = null should have thrown an exception',
          );
        } on ArgumentError {
          expect(1, 1);
        }
      });
    });

    test('invalid argument is caught', () async {
      try {
        var args = TestSimple();
        await args.parse(['--dvalue=55.5', '--invalid']);
        fail('invalid argument did not throw an exception');
      } on ArgumentError {
        expect(1, 1);
      }
    });

    test('not supplying argument', () async {
      try {
        var args = TestSimple();
        await args.parse(['--dvalue']);
        fail('no value did not throw an exception');
      } on ArgumentError {
        expect(1, 1);
      }
    });

    test('missing a required argument throws an error', () async {
      try {
        var args = TestSimple();
        await args.parse([]);
        fail('missing required argument did not throw an exception');
      } on ArgumentError {
        expect(1, 1);
      }
    });

    test('same argument being supplied multiple times', () async {
      try {
        var args = TestSimple();
        await args.parse(['--dvalue=5.5', '--dvalue=5.5']);
        fail(
          'same argument supplied multiple times did not thrown an exception',
        );
      } on ArgumentError catch (e) {
        expect(e.toString(), contains('more than once'));
      }
    });

    group('must be one of', () {
      test('works', () async {
        var args = TestMustBeOneOf();
        await args.parse(['--greeting=hello']);
        expect(args.greeting, 'hello');
      });

      test('catches invalid value', () async {
        try {
          var args = TestMustBeOneOf();
          await args.parse(['--greeting=later']);
          fail('not one of must be one of did not thrown an exception');
        } on ArgumentError catch (e) {
          expect(e.toString(), contains('must be one of'));
        }
      });
    });

    group('integer parameter', () {
      test('works', () async {
        var args = TestIntegerDoubleMinMax();
        await args.parse(['--int-value=2']);
      });

      test('throws an error when below the range', () async {
        try {
          var args = TestIntegerDoubleMinMax();
          await args.parse(['--int-value=0']);
          fail('an integer below the minimum did not throw an exception');
        } on ArgumentError {
          expect(1, 1);
        }
      });

      test('throws an error when above the range', () async {
        try {
          var args = TestIntegerDoubleMinMax();
          await args.parse(['--int-value=100']);
          fail('an integer below the maximum did not throw an exception');
        } on ArgumentError {
          expect(1, 1);
        }
      });
    });

    group('double parameter', () {
      test('works', () async {
        var args = TestIntegerDoubleMinMax();
        await args.parse(['--double-value=2.5']);
      });

      test('throws an error when below the range', () async {
        try {
          var args = TestIntegerDoubleMinMax();
          await args.parse(['--double-value=1.1']);
          fail('a double below the minimum did not throw an exception');
        } on ArgumentError {
          expect(1, 1);
        }
      });

      test('throws an error when above the range', () async {
        try {
          var args = TestIntegerDoubleMinMax();
          await args.parse(['--double-value=4.6']);
          fail('a double below the maximum did not throw an exception');
        } on ArgumentError {
          expect(1, 1);
        }
      });
    });

    test('not enough extras', () async {
      try {
        var args = TestMinimumMaximumExtras();
        await args.parse([]);
        fail('not enough extras did not throw an exception');
      } on ArgumentError {
        expect(1, 1);
      }
    });

    test('enough extras', () async {
      var args = TestMinimumMaximumExtras();
      await args.parse(['extra1']);
      expect(args.extras!.length, 1);
    });

    test('too many extras', () async {
      try {
        var args = TestMinimumMaximumExtras();
        await args.parse(['extra1', 'extra2', 'extra3', 'extra4']);
        fail('too many extras did not throw an exception');
      } on ArgumentError {
        expect(1, 1);
      }
    });

    group('trailing arguments', () {
      test('by default allows', () async {
        var args = TestAllowTrailingArguments();
        await args.parse(['--name=John', 'hello.txt', '--other=Jack']);
        expect(args.name, 'John');
        expect(args.other, 'Jack');
        expect(args.extras!.length, 1);
        expect(args.extras!.contains('hello.txt'), true);
      });

      test('when turned off trailing arguments become extras', () async {
        var args = TestDisallowTrailingArguments();
        await args.parse(['--name=John', 'hello.txt', '--other=Jack']);
        expect(args.name, 'John');
        expect(args.other, null);
        expect(args.extras!.length, 2);
        expect(args.extras!.contains('hello.txt'), true);
        expect(args.extras!.contains('--other=Jack'), true);
      });
    });

    group('file must exist', () {
      test('file that does not exist', () async {
        try {
          var args = TestFileDirectoryMustExist();
          await args
              .parse(['--file=.${path.separator}file-that-does-not-exist.txt']);
          fail('file that does not exist did not throw an exception');
        } on ArgumentError {
          expect(1, 1);
        }
      });

      test('file that exists', () async {
        var args = TestFileDirectoryMustExist();
        await args.parse(['--file=.${path.separator}pubspec.yaml']);
        expect(args.file.path, contains('pubspec.yaml'));
      });
    });

    group('argumentTerminator', () {
      test('default', () async {
        var args = TestArgumentTerminatorDefault();
        await args.parse(['--name=John', '--', '--other=Jack', 'Doe']);
        expect(args.name, 'John');
        expect(args.other, null);
        expect(args.extras!.length, 2);
        expect(args.extras!.contains('--other=Jack'), true);
        expect(args.extras!.contains('Doe'), true);
      });

      test('set to null but try to use', () async {
        try {
          var args = TestArgumentTerminatorNull();
          await args.parse(['--name=John', '--', '--other=Jack', 'Doe']);
          fail(
            'null argument terminator and -- should have thrown an exception',
          );
        } on ArgumentError {
          expect(1, 1);
        }
      });

      test('null terminator without use', () async {
        var args = TestArgumentTerminatorDefault();
        await args.parse(['--name=John', '--other=Jack', 'Doe']);
        expect(args.name, 'John');
        expect(args.other, 'Jack');
        expect(args.extras!.length, 1);
        expect(args.extras!.contains('Doe'), true);
      });

      test('set to --args', () async {
        var args = TestArgumentTerminatorSet();
        await args.parse(['--name=John', '--args', '--other=Jack', 'Doe']);
        expect(args.name, 'John');
        expect(args.other, null);
        expect(args.extras!.length, 2);
        expect(args.extras!.contains('--other=Jack'), true);
        expect(args.extras!.contains('Doe'), true);
      });

      test('set to --args but using mixed case for argument terminator',
          () async {
        var args = TestArgumentTerminatorSet();
        await args.parse(['--name=John', '--ArGS', '--other=Jack', 'Doe']);
        expect(args.name, 'John');
        expect(args.other, null);
        expect(args.extras!.length, 2);
        expect(args.extras!.contains('--other=Jack'), true);
        expect(args.extras!.contains('Doe'), true);
      });

      test('set to --args but not used', () async {
        var args = TestArgumentTerminatorSet();
        await args.parse(['--name=John', '--other=Jack', 'Doe']);
        expect(args.name, 'John');
        expect(args.other, 'Jack');
        expect(args.extras!.length, 1);
        expect(args.extras!.contains('Doe'), true);
      });
    });

    test('invalid short name parameter', () async {
      try {
        var args = TestInvalidShortKeyName();
        await args.parse([]);
        fail('invalid short name did not throw an exception');
      } on StateError {
        expect(1, 1);
      }
    });

    test('invalid long name parameter', () async {
      try {
        var args = TestInvalidLongKeyName();
        await args.parse([]);
        fail('invalid long name did not throw an exception');
      } on StateError {
        expect(1, 1);
      }
    });

    test('short and long parameters with the same name', () async {
      var args = TestShortAndLongSameKey();
      await args.parse(['-a=5', '--a=10']);
      expect(args.abc, 5);
      expect(args.a, 10);
    });

    group('strict setting on', () {
      test('has no long option when one was not specified', () async {
        try {
          var args = TestParserStrict();
          await args.parse(['--nono=12']);
          fail('specifying the parameter name should have thrown an exception');
        } on ArgumentError {
          expect(1, 1);
        }
      });

      test('short option for non-long option works', () async {
        var args = TestParserStrict();
        await args.parse(['-n=12']);
        expect(args.nono, 12);
      });

      test('long option added works', () async {
        var args = TestParserStrict();
        await args.parse(['--say-hello']);
        expect(args.shouldSayHello, true);
      });
    });

    group('long argument override', () {
      test('long item can be overridden', () async {
        var args = TestLongKeyHandling();
        await args.parse([]);
        expect(args.usage().contains('over-ride-long-item-name'), true);
        expect(args.usage().contains('longItem'), false);
      });

      test('long item does not display', () async {
        var args = TestLongKeyHandling();
        await args.parse([]);
        expect(args.usage().contains('-n'), true);
        expect(args.usage().contains('itemWithNoLong'), false);
        expect(args.usage().contains('item-with-no-long'), false);
      });

      test('some argument must exist', () async {
        try {
          var args = TestNoKey();
          await args.parse([]);
          fail('no key at all should have thrown an exception');
        } on StateError {
          expect(1, 1);
        }
      });
    });

    group('directory must exist', () {
      test('directory that does not exist', () async {
        try {
          var args = TestFileDirectoryMustExist();
          await args.parse(
            ['--directory=.${path.separator}directory-that-does-not-exist'],
          );
          fail('directory that does not exist did not throw an exception');
        } on ArgumentError {
          expect(1, 1);
        }
      });

      test('directory that exists', () async {
        var args = TestFileDirectoryMustExist();
        await args.parse(['--directory=.${path.separator}lib']);
        expect(args.directory.path, contains('lib'));
      });
    });
  });

  group('bad configuration', () {
    test('same short argument multiple times', () async {
      try {
        var args = TestMultipleShortArgsSameKey();
        await args.parse([]);
        fail('same short arg multiple times did not throw an exception');
      } on StateError {
        expect(1, 1);
      }
    });

    test('same long argument multiple times', () async {
      try {
        var args = TestMultipleLongArgsSameKey();
        await args.parse([]);
        fail('same long arg multiple times did not throw an exception');
      } on StateError {
        expect(1, 1);
      }
    });
  });

  group('help generation', () {
    test('help contains app description', () async {
      var args = TestSimple();
      await args.parse(['--dvalue=10.0']);
      expect(args.usage(), contains('app-description'));
    });

    test('help contains extended help', () async {
      var args = TestSimple();
      await args.parse(['--dvalue=10.0']);
      var usage = args.usage();

      expect(usage, contains('extended-help'));
      expect(usage, contains('  This is some help'));
      expect(usage, contains('Non-indented help'));
    });

    test('help contains short key for ivalue', () async {
      var args = TestSimple();
      await args.parse(['--dvalue=10.0']);
      expect(args.usage(), contains('-i,'));
    });

    test('help contains long key for ivalue', () async {
      var args = TestSimple();
      await args.parse(['--dvalue=10.0']);
      expect(args.usage(), contains('--ivalue'));
    });

    test('help contains [REQUIRED] for --dvalue', () async {
      var args = TestSimple();
      await args.parse(['--dvalue=10.0']);
      expect(args.usage(), contains('[REQUIRED]'));
    });

    test('help contains must be one of', () {
      var args = TestMustBeOneOf();
      expect(args.usage(), contains('must be one of'));
    });

    test('help contains dashed long key for checkingCamelToDash', () async {
      var args = TestSimple();
      await args.parse(['--dvalue=10.0']);
      expect(args.usage(), contains('--checking-camel-to-dash'));
    });

    test('parameter wrapping', () async {
      var args = TestMultipleLineArgumentHelp();
      await args.parse(['-a=1']);
      expect(args.usage(), matches(RegExp(r'.*\n\s+Silly help message')));
      expect(args.usage(), matches(RegExp(r'.*\n\s+\[REQUIRED\]')));
    });

    test('help works with -?', () async {
      var args = TestHelpArgument();
      await args.parse(['-?']);
      expect(args.help, true);
    });

    test('help works with -h', () async {
      var args = TestHelpArgument();
      await args.parse(['-h']);
      expect(args.help, true);
    });

    test('help works with --help', () async {
      var args = TestHelpArgument();
      await args.parse(['--help']);
      expect(args.help, true);
    });

    test('help ignores parameters after help flag', () async {
      var args = TestHelpArgument();
      await args.parse(['-?', '--bad-argument1', '-b', 'hello']);
      expect(args.help, true);
      expect(args.extras!.contains('--bad-argument1'), true);
      expect(args.extras!.contains('-b'), true);
      expect(args.extras!.contains('hello'), true);
    });

    test('extended help with null throws an error', () {
      try {
        var args = TestBadExtendedHelp();
        args.usage();

        fail('with no extended help it should have thrown an exception');
      } on StateError {
        expect(1, 1);
      }
    });

    test('grouping works', () {
      var args = TestArgumentGroups();
      var help = args.usage();

      expect(help, contains('PERSONALIZATION'));
      expect(help, contains('  Before personalization arguments'));
      expect(help, contains('  After personalization arguments'));
      expect(help, contains('CONFIGURATION'));
    });
  });

  group('inherited and mixin parsing/assignment', () {
    test('basic arguments', () async {
      var args = ChildExtension();
      await args.parse([
        '--child-value', //
        '--string-value', 'hello', //
        '--double-value', '222.22', //
        '--base-value', '321', //
      ]);

      expect(args.childValue, true);
      expect(args.stringValue, 'hello');
      expect(args.doubleValue, 222.22);
      expect(args.baseValue, 321);
      expect(args.help, false);
    });

    test('with deeply nested help', () async {
      var args = ChildExtension();
      await args.parse([
        '--double-value', '222.22', //
        '--base-value', '321', //
        '--help'
      ]);

      expect(args.childValue, null);
      expect(args.doubleValue, 222.22);
      expect(args.baseValue, 321);
      expect(args.help, true);
    });

    test('usage doc', () {
      var args = ChildExtension();
      var help = args.usage();

      expect(
        help,
        contains('A boolean value, added via the ChildExtension class'),
      );
      expect(help, contains('A string value, added via the StringMixin class'));
      expect(help, contains('A double value, added via the DoubleMixin class'));
      expect(help, contains('A integer value, added via the BaseArg class'));
      expect(help, contains('Show help'));
    });
  });
}
