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
  void beforeCommandParse(SmartArg command, List<String> arguments) {
    super.beforeCommandParse(command, arguments);
    hookOrder.add('beforeCommandParse');
  }

  @override
  void afterCommandParse(SmartArg command, List<String> arguments) {
    super.afterCommandParse(command, arguments);
    hookOrder.add('afterCommandParse');
  }

  @override
  void beforeCommandExecute(SmartArgCommand command) {
    super.beforeCommandExecute(command);
    hookOrder.add('beforeCommandExecute');
  }

  @override
  void afterCommandExecute(SmartArgCommand command) {
    super.afterCommandExecute(command);
    hookOrder.add('afterCommandExecute');
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
  void beforeCommandParse(SmartArg command, List<String> arguments) {
    super.beforeCommandParse(command, arguments);
    subcommandHookOrder.add('beforeChildParse');
  }

  @override
  void afterCommandParse(SmartArg command, List<String> arguments) {
    super.afterCommandParse(command, arguments);
    subcommandHookOrder.add('afterChildParse');
  }

  @override
  void beforeCommandExecute(SmartArgCommand command) {
    super.beforeCommandExecute(command);
    subcommandHookOrder.add('beforeChildExecute');
  }

  @override
  void afterCommandExecute(SmartArgCommand command) {
    super.afterCommandExecute(command);
    subcommandHookOrder.add('afterChildExecute');
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
  void beforeCommandParse(SmartArg command, List<String> arguments) {
    super.beforeCommandParse(command, arguments);
    subcommandHookOrder.add('beforeFatherParse');
  }

  @override
  void afterCommandParse(SmartArg command, List<String> arguments) {
    super.afterCommandParse(command, arguments);
    subcommandHookOrder.add('afterFatherParse');
  }

  @override
  void beforeCommandExecute(SmartArgCommand command) {
    super.beforeCommandExecute(command);
    subcommandHookOrder.add('beforeFatherExecute');
  }

  @override
  void afterCommandExecute(SmartArgCommand command) {
    super.afterCommandExecute(command);
    subcommandHookOrder.add('afterFatherExecute');
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
  void beforeCommandParse(SmartArg command, List<String> arguments) {
    super.beforeCommandParse(command, arguments);
    subcommandHookOrder.add('beforeGrandFatherParse');
  }

  @override
  void afterCommandParse(SmartArg command, List<String> arguments) {
    super.afterCommandParse(command, arguments);
    subcommandHookOrder.add('afterGrandFatherParse');
  }

  @override
  void beforeCommandExecute(SmartArgCommand command) {
    super.beforeCommandExecute(command);
    subcommandHookOrder.add('beforeGrandFatherExecute');
  }

  @override
  void afterCommandExecute(SmartArgCommand command) {
    super.afterCommandExecute(command);
    subcommandHookOrder.add('afterGrandFatherExecute');
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
          'beforeCommandParse',
          'afterCommandParse',
          'beforeCommandExecute',
          'afterCommandExecute'
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
          'beforeGrandFatherParse',
          'beforeFatherParse',
          'afterFatherParse',
          'afterGrandFatherParse',
          'beforeGrandFatherExecute',
          'beforeFatherExecute',
          'FatherExecute',
          'afterFatherExecute',
          'afterGrandFatherExecute'
        ]);
      });

      test('Second subcommand', () async {
        await GrandFatherCommand()
            .parse(['father', 'child', '--a-value=charlie']);
        expect(whatExecuted, 'ChildCommand: charlie');
        expect(subcommandHookOrder, [
          'beforeGrandFatherParse',
          'beforeFatherParse',
          'beforeChildParse',
          'afterChildParse',
          'afterFatherParse',
          'afterGrandFatherParse',
          'beforeGrandFatherExecute',
          'beforeFatherExecute',
          'beforeChildExecute',
          'ChildExecute',
          'afterChildExecute',
          'afterFatherExecute',
          'afterGrandFatherExecute'
        ]);
      });

      test('Triply Nested subcommand', () async {
        await GrandFatherCommand()
            .parse(['father', 'child', 'child', '--a-value=delta']);
        expect(whatExecuted, 'ChildCommand: delta');
        expect(subcommandHookOrder, [
          'beforeGrandFatherParse',
          'beforeFatherParse',
          'beforeChildParse',
          'beforeChildParse',
          'afterChildParse',
          'afterChildParse',
          'afterFatherParse',
          'afterGrandFatherParse',
          'beforeGrandFatherExecute',
          'beforeFatherExecute',
          'beforeChildExecute',
          'beforeChildExecute',
          'ChildExecute',
          'afterChildExecute',
          'afterChildExecute',
          'afterFatherExecute',
          'afterGrandFatherExecute'
        ]);
      });

      test('Arguments beyond commands are executed as the last known command',
          () async {
        await GrandFatherCommand().parse(['father', 'child']);
        expect(whatExecuted, 'ChildCommand: null');
        expect(subcommandHookOrder, [
          'beforeGrandFatherParse',
          'beforeFatherParse',
          'beforeChildParse',
          'afterChildParse',
          'afterFatherParse',
          'afterGrandFatherParse',
          'beforeGrandFatherExecute',
          'beforeFatherExecute',
          'beforeChildExecute',
          'ChildExecute',
          'afterChildExecute',
          'afterFatherExecute',
          'afterGrandFatherExecute'
        ]);
      });

      test('Nested SmartArg as Command', () async {
        await GrandFatherCommand()
            .parse(['grand-father', 'father', '--a-value=beta']);
        expect(whatExecuted, 'FatherCommand: beta');
        expect(subcommandHookOrder, [
          'beforeGrandFatherParse',
          'beforeGrandFatherParse',
          'beforeFatherParse',
          'afterFatherParse',
          'afterGrandFatherParse',
          'afterGrandFatherParse',
          'beforeGrandFatherExecute',
          'beforeGrandFatherExecute',
          'beforeFatherExecute',
          'FatherExecute',
          'afterFatherExecute',
          'afterGrandFatherExecute',
        ]);
      });
    });
  });
}
