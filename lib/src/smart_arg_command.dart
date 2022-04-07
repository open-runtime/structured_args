import '../smart_arg_fork.dart';

@SmartArg.reflectable
abstract class SmartArgCommand extends SmartArg {
  Future<void> execute(SmartArg parentArguments);
}
