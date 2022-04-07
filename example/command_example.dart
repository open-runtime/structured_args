import 'dart:io';

import 'package:smart_arg_fork/smart_arg_fork.dart';

import 'command_example.reflectable.dart';

@SmartArg.reflectable
@Parser(description: 'get file from remote server')
class GetCommand extends SmartArgCommand {
  @BooleanArgument(help: 'Should the file be removed after downloaded?')
  bool? removeAfterGet;

  @override
  Future<void> execute(SmartArg parentArguments) async {
    if ((parentArguments as Args).verbose == true) {
      print('Verbose is on');
    } else {
      print('Verbose is off');
    }
    print('Getting file...');
    if (removeAfterGet == true) {
      print('Removing file on remote server (not really)');
    }
  }
}

@SmartArg.reflectable
@Parser(description: 'put file onto remote server')
class PutCommand extends SmartArgCommand {
  @BooleanArgument(help: 'Should the file be removed locally after downloaded?')
  bool? removeAfterPut;

  @override
  Future<void> execute(SmartArg parentArguments) async {
    if ((parentArguments as Args).verbose == true) {
      print('Verbose is on');
    } else {
      print('Verbose is off');
    }

    print('Putting file...');

    if (removeAfterPut == true) {
      print('Removing file on local disk (not really)');
    }
  }
}

@SmartArg.reflectable
@Parser(
  description: 'Example using commands',
  extendedHelp: [
    ExtendedHelp(
      'This is some text below the command listing',
      header: 'EXTENDED HELP',
    )
  ],
)
class Args extends SmartArg {
  @BooleanArgument(short: 'v', help: 'Verbose mode')
  bool? verbose;

  @Command(help: 'Get a file from the remote server')
  GetCommand? get;

  @Command(help: 'Put a file on the remote server')
  PutCommand? put;
}

void main(List<String> arguments) async {
  initializeReflectable();

  var args = Args();
  await args.parse(arguments);

  if (args.help == true) {
    print(args.usage());
    exit(0);
  }
}
