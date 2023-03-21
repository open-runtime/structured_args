import 'package:runtime_structured_cli_args/runtime_structured_cli_args.dart';

import 'default_command_example.reflectable.dart';

@SmartArg.reflectable
@Parser(
  description: 'Runs the projects unit tests',
  exitOnHelp: false,
)
class UnitTestCommand extends SmartArg {
  @StringArgument(help: 'Test Suite to run')
  String? suite;

  @override
  Future<void> execute() async => print('Running ${suite ?? 'Unit'} Tests');
}

@SmartArg.reflectable
@Parser(
  description: 'Runs the projects integration tests',
  exitOnHelp: false,
)
class IntegrationTestCommand extends SmartArg {
  @BooleanArgument(help: 'Disable database connection')
  bool disableDatabase = false;

  @override
  Future<void> execute() async => print(
        'Running Integration Tests ${disableDatabase ? 'without database' : 'with database'}',
      );
}

@SmartArg.reflectable
@Parser(
  description: 'Runs the projects benchmark tests',
  exitOnHelp: false,
)
class BenchmarkTestCommand extends SmartArg {
  @IntegerArgument(help: 'Times to run')
  int times = 1;

  @override
  Future<void> execute() async => print('Running Benchmark Tests $times times');
}

@SmartArg.reflectable
@Parser(
  description: 'A Default Command example',
  exitOnHelp: false,
)
class RootCommand extends SmartArg {
  @DefaultCommand()
  late UnitTestCommand unit;

  @Command()
  late IntegrationTestCommand integration;

  @Command()
  late BenchmarkTestCommand benchmark;

  @Command()
  late BenchmarkTestCommand lateDefinedBenchmark = BenchmarkTestCommand()..times = 5;

  @Command()
  BenchmarkTestCommand definedBenchmark = BenchmarkTestCommand()..times = 10;
}

Future<void> main(List<String> arguments) async {
  initializeReflectable();
  var args = RootCommand();
  await args.parse(arguments);
}
