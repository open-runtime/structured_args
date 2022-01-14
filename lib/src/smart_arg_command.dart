import 'smart_arg.dart';

abstract class SmartArgCommand extends SmartArg {
  Future<void> execute(SmartArg parentArguments);
}
