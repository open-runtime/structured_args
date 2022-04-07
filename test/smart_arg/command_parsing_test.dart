// ignore_for_file: deprecated_member_use_from_same_package

import 'package:smart_arg_fork/smart_arg_fork.dart';
import 'package:test/test.dart';

import '../smart_arg_test.reflectable.dart';

String? whatExecuted;

@SmartArg.reflectable
@Parser(exitOnFailure: false, description: 'put command')
class PutCommand extends SmartArgCommand {
  @StringArgument()
  String? filename;

  @override
  Future<void> execute(SmartArg parentArguments) async {
    whatExecuted = 'put-command: $filename';
  }
}

@SmartArg.reflectable
@Parser(exitOnFailure: false, description: 'Get a file from a remote host')
class GetCommand extends SmartArgCommand {
  @StringArgument()
  String? filename;

  @override
  Future<void> execute(SmartArg parentArguments) async {
    whatExecuted = 'get-command: $filename';
  }
}

@SmartArg.reflectable
@Parser(exitOnFailure: false)
class TestSimpleCommand extends SmartArg {
  @BooleanArgument(short: 'v')
  bool? verbose;

  @Command(help: 'Put a file on a remote host')
  PutCommand? put;

  @Command()
  GetCommand? get;

  List<String> hookOrder = [];

  @override
  Future<void> preCommandParse(SmartArg command, List<String> arguments) {
    var val = super.preCommandParse(command, arguments);
    hookOrder.add('preCommandParse');
    return val;
  }

  @override
  Future<void> postCommandParse(SmartArg command, List<String> arguments) {
    var val = super.postCommandParse(command, arguments);
    hookOrder.add('postCommandParse');
    return val;
  }

  @override
  Future<void> preCommandExecute(SmartArgCommand command) {
    var val = super.preCommandExecute(command);
    hookOrder.add('preCommandExecute');
    return val;
  }

  @override
  Future<void> postCommandExecute(SmartArgCommand command) {
    var val = super.postCommandExecute(command);
    hookOrder.add('postCommandExecute');
    return val;
  }
}

List<String> subcommandHookOrder = [];

@SmartArg.reflectable
@Parser(exitOnFailure: false, description: 'The Child Command')
class ChildCommand extends SmartArgCommand {
  @StringArgument()
  String? aValue;

  @Command()
  late ChildCommand child;

  @override
  Future<void> execute(SmartArg parentArguments) async {
    whatExecuted = 'ChildCommand: $aValue';
    subcommandHookOrder.add('ChildExecute');
  }

  @override
  Future<void> preCommandParse(SmartArg command, List<String> arguments) {
    var val = super.preCommandParse(command, arguments);
    subcommandHookOrder.add('preChildCommandParse');
    return val;
  }

  @override
  Future<void> postCommandParse(SmartArg command, List<String> arguments) {
    var val = super.postCommandParse(command, arguments);
    subcommandHookOrder.add('postChildCommandParse');
    return val;
  }

  @override
  Future<void> preCommandExecute(SmartArgCommand command) {
    var val = super.preCommandExecute(command);
    subcommandHookOrder.add('preChildCommandExecute');
    return val;
  }

  @override
  Future<void> postCommandExecute(SmartArgCommand command) {
    var val = super.postCommandExecute(command);
    subcommandHookOrder.add('postChildCommandExecute');
    return val;
  }
}

@SmartArg.reflectable
@Parser(exitOnFailure: false, description: 'The Father Command')
class FatherCommand extends SmartArgCommand {
  @StringArgument()
  String? aValue;

  @Command()
  late ChildCommand child;

  @override
  Future<void> execute(SmartArg parentArguments) async {
    whatExecuted = 'FatherCommand: $aValue';
    subcommandHookOrder.add('FatherExecute');
  }

  @override
  Future<void> preCommandParse(SmartArg command, List<String> arguments) {
    var val = super.preCommandParse(command, arguments);
    subcommandHookOrder.add('preFatherCommandParse');
    return val;
  }

  @override
  Future<void> postCommandParse(SmartArg command, List<String> arguments) {
    var val = super.postCommandParse(command, arguments);
    subcommandHookOrder.add('postFatherCommandParse');
    return val;
  }

  @override
  Future<void> preCommandExecute(SmartArgCommand command) {
    var val = super.preCommandExecute(command);
    subcommandHookOrder.add('preFatherCommandExecute');
    return val;
  }

  @override
  Future<void> postCommandExecute(SmartArgCommand command) {
    var val = super.postCommandExecute(command);
    subcommandHookOrder.add('postFatherCommandExecute');
    return val;
  }
}

@SmartArg.reflectable
@Parser(exitOnFailure: false, description: 'The Parent Command')
class GrandFatherCommand extends SmartArg {
  @Command()
  late ChildCommand child;

  @Command()
  late FatherCommand father;

  @StringArgument()
  String? aValue;

  @Command()
  late GrandFatherCommand grandFather;

  @override
  Future<void> preCommandParse(SmartArg command, List<String> arguments) {
    var val = super.preCommandParse(command, arguments);
    subcommandHookOrder.add('preGrandFatherCommandParse');
    return val;
  }

  @override
  Future<void> postCommandParse(SmartArg command, List<String> arguments) {
    var val = super.postCommandParse(command, arguments);
    subcommandHookOrder.add('postGrandFatherCommandParse');
    return val;
  }

  @override
  Future<void> preCommandExecute(SmartArgCommand command) {
    var val = super.preCommandExecute(command);
    subcommandHookOrder.add('preGrandFatherCommandExecute');
    return val;
  }

  @override
  Future<void> postCommandExecute(SmartArgCommand command) {
    var val = super.postCommandExecute(command);
    subcommandHookOrder.add('postGrandFatherCommandExecute');
    return val;
  }
}

void main() {
  initializeReflectable();

  group('parsing', () {
    group('commands', () {
      setUp(() {
        whatExecuted = null;
      });

      test('calls hooks', () async {
        var cmd = TestSimpleCommand();
        await cmd.parse(['get', '--filename=download.txt']);
        expect(cmd.verbose, null);
        expect(whatExecuted, 'get-command: download.txt');
        expect(cmd.hookOrder, [
          'preCommandParse',
          'postCommandParse',
          'preCommandExecute',
          'postCommandExecute'
        ]);
      });

      test('executes with no arguments', () async {
        final args = TestSimpleCommand();
        await args.parse([]);
        expect(args.verbose, null);
      });

      test('executes with a command', () async {
        final args = TestSimpleCommand();
        await args.parse(['-v', 'put', '--filename=upload.txt']);
        expect(args.verbose, true);
        expect(whatExecuted, 'put-command: upload.txt');
      });

      test('executes with another command', () async {
        final args = TestSimpleCommand();
        await args.parse(['-v', 'get', '--filename=download.txt']);
        expect(args.verbose, true);
        expect(whatExecuted, 'get-command: download.txt');
      });

      test('help appears', () {
        final args = TestSimpleCommand();
        final help = args.usage();

        expect(help.contains('COMMANDS'), true);
        expect(help.contains('  get'), true);
        expect(help.contains('  put'), true);
        expect(help.contains('Get a file'), true); //From Parser description
        expect(help.contains('Put a file'), true); //From Command.Help
      });
    });

    group('subcommands', () {
      setUp(() {
        whatExecuted = null;
        subcommandHookOrder = [];
      });

      test('First Subcommand', () async {
        await GrandFatherCommand().parse(['father', '--a-value=beta']);
        expect(whatExecuted, 'FatherCommand: beta');
        expect(subcommandHookOrder, [
          'preGrandFatherCommandParse',
          'preFatherCommandParse',
          'postFatherCommandParse',
          'postGrandFatherCommandParse',
          'preGrandFatherCommandExecute',
          'preFatherCommandExecute',
          'FatherExecute',
          'postFatherCommandExecute',
          'postGrandFatherCommandExecute'
        ]);
      });

      test('Second subcommand', () async {
        await GrandFatherCommand()
            .parse(['father', 'child', '--a-value=charlie']);
        expect(whatExecuted, 'ChildCommand: charlie');
        expect(subcommandHookOrder, [
          'preGrandFatherCommandParse',
          'preFatherCommandParse',
          'preChildCommandParse',
          'postChildCommandParse',
          'postFatherCommandParse',
          'postGrandFatherCommandParse',
          'preGrandFatherCommandExecute',
          'preFatherCommandExecute',
          'preChildCommandExecute',
          'ChildExecute',
          'postChildCommandExecute',
          'postFatherCommandExecute',
          'postGrandFatherCommandExecute'
        ]);
      });

      test('Triply Nested subcommand', () async {
        await GrandFatherCommand()
            .parse(['father', 'child', 'child', '--a-value=delta']);
        expect(whatExecuted, 'ChildCommand: delta');
        expect(subcommandHookOrder, [
          'preGrandFatherCommandParse',
          'preFatherCommandParse',
          'preChildCommandParse',
          'preChildCommandParse',
          'postChildCommandParse',
          'postChildCommandParse',
          'postFatherCommandParse',
          'postGrandFatherCommandParse',
          'preGrandFatherCommandExecute',
          'preFatherCommandExecute',
          'preChildCommandExecute',
          'preChildCommandExecute',
          'ChildExecute',
          'postChildCommandExecute',
          'postChildCommandExecute',
          'postFatherCommandExecute',
          'postGrandFatherCommandExecute',
        ]);
      });

      test('Arguments beyond commands are executed as the last known command',
          () async {
        await GrandFatherCommand().parse(['father', 'child']);
        expect(whatExecuted, 'ChildCommand: null');
        expect(subcommandHookOrder, [
          'preGrandFatherCommandParse',
          'preFatherCommandParse',
          'preChildCommandParse',
          'postChildCommandParse',
          'postFatherCommandParse',
          'postGrandFatherCommandParse',
          'preGrandFatherCommandExecute',
          'preFatherCommandExecute',
          'preChildCommandExecute',
          'ChildExecute',
          'postChildCommandExecute',
          'postFatherCommandExecute',
          'postGrandFatherCommandExecute'
        ]);
      });

      test('Nested SmartArg as Command', () async {
        await GrandFatherCommand()
            .parse(['grand-father', 'father', '--a-value=beta']);
        expect(whatExecuted, 'FatherCommand: beta');
        expect(subcommandHookOrder, [
          'preGrandFatherCommandParse',
          'preGrandFatherCommandParse',
          'preFatherCommandParse',
          'postFatherCommandParse',
          'postGrandFatherCommandParse',
          'postGrandFatherCommandParse',
          'preGrandFatherCommandExecute',
          'preGrandFatherCommandExecute',
          'preFatherCommandExecute',
          'FatherExecute',
          'postFatherCommandExecute',
          'postGrandFatherCommandExecute'
        ]);
      });
    });
  });
}
