Smart Arg
=========

[![CircleCI](https://circleci.com/gh/axrs/smart_arg/tree/master-forked.svg?style=svg)](https://circleci.com/gh/axrs/smart_arg/?branch=master-forked)
[![Pub](https://img.shields.io/pub/v/smart_arg_fork.svg)](https://pub.dartlang.org/packages/smart_arg_fork)

A source generated, simple to use command line argument parser. The main rationale behind this argument parser is the
use of a class to store the argument values. Therefore, you gain static type checking and code completion.

Types currently supported are: `bool`, `int`, `double`, `String`, `File`, `Directory`, `Enum` and `Command`. Defaults
can be supplied as any other Dart class and one can determine if a parameter was set based on it's value being null or
not. Types can also be defined as a `List<T>` to support multiple arguments of the same name to be specified on the
command line. Anything passed on the command line that is not an option will be considered an extra, of which you can
demand a minimum and/or maximum requirement.

Through the use of annotations, each parameter (and main class) can have various attributes set such as help text, if
the parameter is required, if the file must exist on disk, can the parameter be negated, a short alias, and more.

Beautiful help is of course generated automatically when the user gives an incorrect parameter or misses a required
parameter or extra.

## Argument Types

* [Boolean](https://pub.dev/documentation/smart_arg_fork/latest/smart_arg_fork/BooleanArgument-class.html)
* [Command](https://pub.dev/documentation/smart_arg_fork/latest/smart_arg_fork/Command-class.html)
  * and [DefaultCommand](https://pub.dev/documentation/smart_arg_fork/latest/smart_arg_fork/DefaultCommand-class.html)
* [Directory](https://pub.dev/documentation/smart_arg_fork/latest/smart_arg_fork/DirectoryArgument-class.html)
* [Double](https://pub.dev/documentation/smart_arg_fork/latest/smart_arg_fork/DoubleArgument-class.html)
* [Enum](https://pub.dev/documentation/smart_arg_fork/latest/smart_arg_fork/EnumArgument-class.html)
* [File](https://pub.dev/documentation/smart_arg_fork/latest/smart_arg_fork/FileArgument-class.html)
* [Help](https://pub.dev/documentation/smart_arg_fork/latest/smart_arg_fork/HelpArgument-class.html)
* [Integer](https://pub.dev/documentation/smart_arg_fork/latest/smart_arg_fork/IntegerArgument-class.html)
* [String](https://pub.dev/documentation/smart_arg_fork/latest/smart_arg_fork/StringArgument-class.html)

## Build Process

`smart_arg` relies on the [reflectable] package. Therefore, you must add to
your build process. Your `build.yaml` file should look similar to:

```
targets:
  $default:
    builders:
      reflectable:
        generate_for:
          - bin/main.dart
```

Also, before you can execute your program and any time you change your SmartArg class, you must execute the builder:

```
$ pub run build_runner build
```

## Examples

### Simple CLI

```dart
import 'package:smart_arg_fork/smart_arg_fork.dart';

import 'readme_example.reflectable.dart';

@SmartArg.reflectable
@Parser(description: 'Hello World application')
class Args extends SmartArg {
  @StringArgument(
    help: 'Name of person to say hello to',
    //Environment Variable will be used if defined and not otherwise specified
    environmentVariable: 'GREETING_NAME',
  )
  String name = 'World'; // Default to World

  @StringArgument(
    help: 'Message to say to person',
    mustBeOneOf: ['Hello', 'Goodbye'],
    environmentVariable: 'GREETING_TYPE',
  )
  String greeting = 'Hello'; // Default to Hello

  @IntegerArgument(
    help: 'Number of times to greet the person',
    isRequired: true,
    minimum: 1,
    maximum: 100,
    environmentVariable: 'GREETING_COUNT',
  )
  late int count;
}

Future<void> main(List<String> arguments) async {
  initializeReflectable();
  var args = Args();
  await args.parse(arguments);
  for (var i = 0; i < args.count; i++) {
    print('${args.greeting}, ${args.name}!');
  }
}
```

Please see the API documentation for a better understanding of what `Argument` types exist as well as their individual
options.

#### Help Output

The help output of the above example is:

```
Hello World application

  --name                 Name of person to say hello to
                         [Environment Variable: $GREETING_NAME]
  --greeting             Message to say to person
                         [Environment Variable: $GREETING_TYPE]
                         must be one of Hello, Goodbye
  --count                Number of times to greet the person
                         [REQUIRED]
                         [Environment Variable: $GREETING_COUNT]
  -h, --help, -?         Show help
```


### Detailed Help Example

A more complex example [smart_arg_example.dart][smart_arg_example.dart] produces the following output:

```
Example smart arg application

Group 1
  This is some long text that explains this section in detail. Blah blah blah
  blah blah blah blah blah. This will be wrapped as needed. Thus, it will
  display beautifully in the console.

  --names                no help available
  -r, --header           Report header text
  --filename             Filename to report stats on

  This is just a single sentence but even it will be wrapped if necessary

Group 2 -- OTHER
  Help before

  --count                Count of times to say hello
  --silly                Some other silly parameter to show double parsing.
                         This also has a very long description that should
                         word wrap in the output and produce beautiful
                         display.
  -v, --verbose, --no-verbose
                         Turn verbose mode on.
                         
                         This is an example also of using multi-line help
                         text that is formatted inside of the editor. This
                         should be one paragraph. I'll add some more content
                         here. This will be the last sentence of the first
                         paragraph.
                         
                         This is another paragraph formatted very narrowly in
                         the code editor. Does it look the same as the one
                         above? I sure hope that it does. It would make help
                         display very easy to implement.
  -h, --help, -?         Show help

  Help after

This is a simple application that does nothing and contains silly arguments.
It simply shows how the smart_arg library can be used.

No one should really try to use this program outside of those interested in
using smart_arg in their own applications.

SECTION 2
  This is more extended text that can be put into its own section.
```

### Sub-Command Example

More complex command line applications often times have commands. These commands then also have options of their own.
`SmartArg` accomplishes this very easily:

```dart
import 'package:smart_arg_fork/smart_arg_fork.dart';

import 'command_example.reflectable.dart';

@SmartArg.reflectable
@Parser(description: 'get file from remote server')
class GetCommand extends SmartArg {
  @BooleanArgument(help: 'Should the file be removed after downloaded?')
  late bool removeAfterGet = false;

  @override
  Future<void> execute() async {
    print('Getting file...');
    if (removeAfterGet == true) {
      print('Removing file on remote server (not really)');
    }
  }
}

@SmartArg.reflectable
@Parser(description: 'put file onto remote server')
class PutCommand extends SmartArg {
  @BooleanArgument(help: 'Should the file be removed locally after downloaded?')
  late bool removeAfterPut = false;

  @override
  Future<void> execute() async {
    if ((parent as Args).verbose) {
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
  printUsageOnExitFailure: true,
)
class Args extends SmartArg {
  @BooleanArgument(short: 'v', help: 'Verbose mode')
  late bool verbose = false;

  @Command(help: 'Get a file from the remote server')
  late GetCommand get;

  @Command(help: 'Put a file on the remote server')
  late PutCommand put;

  // As there is no @DefaultCommand, and we have NOT overridden the
  // `Future<void> execute()` method, an `Implementation not defined` error will
  // be printed, followed by the usage and the process will exit with code 0
}

Future<void> main(List<String> arguments) async {
  initializeReflectable();
  var args = Args();
  await args.parse(arguments);
}
```

### Inheritance and Mixin Example

It is also possible to leverage inheritance and Dart `mixin` declarations to help reduce boilerplate and share argument
definitions between multiple commands. Just remember to annotate each `mixin` with `@SmartArg.reflectable` so that
`reflectables` are able to identify where arguments should be assigned.

> Note: Any mixin or base class that does not include the `@SmartArg.reflectable` annotation is excluded from the
> argument assigning process.

```dart
import 'package:smart_arg_fork/smart_arg_fork.dart';

import 'advanced_command_example.reflectable.dart';

/// A basic mixin for adding a Docker Image argument to each [SmartArg] extension
@SmartArg.reflectable
mixin DockerImageArg {
  @StringArgument(help: 'Docker Image')
  late String image = 'dart:stable';
}

@SmartArg.reflectable
@Parser(description: 'Pulls a Docker Image')
class DockerPullCommand extends SmartArg with DockerImageArg {
  @override
  Future<void> execute() async {
    print('\$ docker pull $image');
  }
}

@SmartArg.reflectable
@Parser(description: 'Runs a Docker Image')
class DockerRunCommand extends SmartArg with DockerImageArg {
  @BooleanArgument(help: 'Pull image before running')
  bool pull = false;

  @override
  Future<void> execute() async {
    print('\$ docker run${pull ? ' --pull' : ''} $image');
  }
}

enum Status { running, stopped, all }

@SmartArg.reflectable
@Parser(description: 'Lists Docker Images')
class DockerListCommand extends SmartArg with DockerImageArg {
  @EnumArgument<Status>(
    help: 'Docker Image Status',
    values: Status.values,
  )
  late Status status = Status.all;

  @override
  Future<void> execute() async {
    print('\$ docker ps --status $status');
  }
}

@SmartArg.reflectable
@Parser(
  description: 'Example of using mixins to reduce argument declarations',
)
class Args extends SmartArg {
  @BooleanArgument(short: 'v', help: 'Verbose mode')
  late bool verbose = false;

  @Command()
  late DockerPullCommand pull;

  @Command()
  late DockerRunCommand run;

  // The @DefaultCommand will be the main Command to run here (if `pull`, `run`, or `lint` are unspecified) as we have
  // not overridden `Future<void> execute()`
  @DefaultCommand()
  late DockerListCommand list;
}

Future<void> main(List<String> arguments) async {
  initializeReflectable();
  var args = Args();
  await args.parse(arguments);
}
```

#### Output and Run Log

```text
$ dart run .\example\advanced_command_example.dart --help

Example of using mixins to reduce argument declarations

  -v, --verbose          Verbose mode
  -h, --help, -?         Show help

COMMANDS
  list                   Lists Docker Images
                         [DEFAULT]
  pull                   Pulls a Docker Image
  run                    Runs a Docker Image

---

$ dart run .\example\advanced_command_example.dart run --help

Runs a Docker Image

  --pull                 Pull image before running
  --image                Docker Image
  -h, --help, -?         Show help

---

$ dart run .\example\advanced_command_example.dart run --pull --image dart:sdk-stable

docker run --pull dart:sdk-stable
```

## Features and bugs

Please send pull requests, feature requests and bug reports to the
[issue tracker][tracker].

[tracker]: https://github.com/axrs/smart_arg_fork
[smart_arg_example.dart]: https://github.com/axrs/smart_arg_fork/blob/master-forked/example/smart_arg_example.dart
[reflectable]: https://pub.dev/packages/reflectable
