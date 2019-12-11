import 'dart:io';
import 'dart:math';
import 'dart:mirrors';

import 'package:smart_arg/smart_arg.dart';

import 'argument.dart';
import 'mirror_argument_pair.dart';
import 'parser.dart';

/// Base class for the [SmartArg] parser.
///
/// Your application should extend [SmartArg], add public properties,
/// and call the [SmartArg.parse()] method on your class.
class SmartArg {
  //
  // Public API
  //

  /// List of extras supplied on the command line.
  ///
  /// Extras are anything supplied on the command line that was not an option.
  List<String> get extras => _extras;

  SmartArg() {
    final instanceMirror = reflect(this);

    // Find our app meta data (if any)
    _app = instanceMirror.type.metadata
        .firstWhere((m) => m.reflectee is Parser)
        ?.reflectee;

    // Build an easy to use lookup for arguments on the command line
    // to their cooresponding Parameter configurations.
    _values = {};
    _mirrorParameterPairs = [];

    for (var mirror in instanceMirror.type.declarations.values
        .where((p) => p is VariableMirror && p.isPrivate == false)) {
      var parameter =
          mirror.metadata.firstWhere((m) => m.reflectee is Argument)?.reflectee;
      var mpp = MirrorParameterPair(mirror, parameter);

      for (var key in mpp.keys(_app)) {
        if (_values.containsKey(key)) {
          throw StateError('$key was configured multiple times');
        }

        _values[key] = mpp;
      }

      _mirrorParameterPairs.add(mpp);
    }
  }

  /// Parse the [arguments] list populating properties on the [SmartArg] class.
  ///
  /// If [Parser.exitOnFailure] is set to true, this function will call
  /// `exit(1)` if there is a command line parsing error. It will do so only
  /// after telling the user what the error was and displaying the result of
  /// [usage()].
  void parse(List<String> arguments) {
    _resetParser();

    try {
      if (_parse(arguments)) {
        _validate();
      }
    } on ArgumentError catch (e) {
      if (_app?.exitOnFailure == true) {
        print(e.toString());
        print('');
        print(usage());
        exit(1);
      }

      rethrow;
    }
  }

  /// Return a string telling the user how to use your application from the command line.
  String usage() {
    List<String> lines = [];

    if (_app?.description != null) {
      lines.add(_app.description);
      lines.add('');
    }

    List<String> helpKeys = [];
    List<List<String>> helpDescriptions = [];

    for (var mpp in _mirrorParameterPairs) {
      List<String> keys = [];

      keys.addAll(mpp.keys(_app).map((v) => v.startsWith('-') ? v : '--$v'));
      helpKeys.add(keys.join(', '));

      List<String> helpLines = [mpp.argument.help ?? 'no help available'];

      if (mpp.argument.isRequired ?? false) {
        helpLines.add('[REQUIRED]');
      }

      helpLines.addAll(mpp.argument.additionalHelpLines);

      helpDescriptions.add(helpLines);
    }

    final maxKeyLenAllowed = 30;
    final maxKeyLen = helpKeys.fold<int>(0,
        (a, b) => b.length > a && b.length < maxKeyLenAllowed ? b.length : a);
    final keyPadWidth = min(maxKeyLenAllowed, maxKeyLen + 1);
    final continuedLineHelpTextPadding = ' '.padRight(keyPadWidth);

    for (var i = 0; i < helpKeys.length; i++) {
      var keyDisplay = helpKeys[i].padRight(keyPadWidth);

      if (keyDisplay.length == keyPadWidth) {
        final thisHelpDescriptions = helpDescriptions[i];
        final firstHelpDisplay = thisHelpDescriptions.first;

        lines.add('$keyDisplay$firstHelpDisplay');

        for (var j = 1; j < thisHelpDescriptions.length; j++) {
          lines.add('$continuedLineHelpTextPadding${thisHelpDescriptions[j]}');
        }
      } else {
        final thisHelpDescriptions = helpDescriptions[i];

        lines.add(keyDisplay);
        for (var j = 0; j < thisHelpDescriptions.length; j++) {
          lines.add('$continuedLineHelpTextPadding${thisHelpDescriptions[j]}');
        }
      }
    }

    if (_app?.extendedHelp != null) {
      lines.add(' ');
      lines.addAll(_app.extendedHelp
          .trim()
          .split(_eolRegex)
          .map((v) => v.trim())
          .toList());
    }

    return lines.join('\n');
  }

  //
  // Private API
  //

  Parser _app;
  Map<String, MirrorParameterPair> _values;
  List<String> _extras;
  Set<String> _wasSet;

  // tracked so we can have a proper order for help output
  List<MirrorParameterPair> _mirrorParameterPairs;

  final _eolRegex = RegExp(r'\r\n|[\r\n]');

  bool _parse(List<String> arguments) {
    final instanceMirror = reflect(this);

    int argumentIndex = 0;
    while (argumentIndex < arguments.length) {
      var argument = arguments[argumentIndex];
      var originalArgument = argument;

      argumentIndex++;

      if (argument.toLowerCase() == _app.argumentTerminator?.toLowerCase()) {
        _extras.addAll(arguments.skip(argumentIndex));
        return true;
      } else if (argument.startsWith('-') == false) {
        // Was not an argument, must be an extra
        _extras.add(argument);

        if (_app.allowTrailingArguments == false) {
          _extras.addAll(arguments.skip(argumentIndex));
          return true;
        }

        continue;
      }

      var argumentParts = argument.split('=');
      var argumentName = argumentParts.first;
      var hasValueViaEqual = argumentParts.length > 1;
      dynamic value = argumentParts.skip(1).join('=');

      if (argumentName.startsWith('--')) {
        argumentName = argumentName.substring(2);
      }

      // Find our argument configuration
      var argumentConfiguration = _values[argumentName];
      if (argumentConfiguration == null) {
        throw ArgumentError('$originalArgument is invalid');
      }

      if (argumentConfiguration.argument.needsValue && !hasValueViaEqual) {
        if (argumentIndex >= arguments.length) {
          throw ArgumentError(
              '${argumentConfiguration.displayKey} expects a value but none was supplied.');
        }

        value = arguments[argumentIndex];
        argumentIndex++;
      }

      value = argumentConfiguration.argument.handleValue(argumentName, value);

      // Try setting it as a list first
      var instanceValue = instanceMirror
          .getField(argumentConfiguration.mirror.simpleName)
          .reflectee;

      // There is no way of determining if a class variable is a list or not through
      // introspection, therefore we try to add the value as a list, or append to the
      // list first. If that fails, we assume it is not a list :-/

      if (instanceValue == null) {
        try {
          instanceValue = (argumentConfiguration.argument as dynamic).emptyList;
          instanceValue.add(value);

          instanceMirror.setField(
              argumentConfiguration.mirror.simpleName, instanceValue);
          _wasSet.add(argumentConfiguration.displayKey);
        } catch (_) {
          // Adding as a list failed, so it must not be a list. Let's set it
          // as a normal value.
          instanceMirror.setField(
              argumentConfiguration.mirror.simpleName, value);
          _wasSet.add(argumentConfiguration.displayKey);
        }
      } else {
        try {
          // Since we can not determine if the instanceValue is a list or not...
          //
          // Just try the .first method to see if it exists. We don't really care
          // about the value, we just want to execute at least two methods on
          // the instance value to do as good of a job as we can to determine if
          // the type is a List or not.
          //
          // .first is the first method, .add will be the second
          var _ = instanceValue.first;
          instanceValue.add(value);
          _wasSet.add(argumentConfiguration.displayKey);
        } catch (_) {
          if (_wasSet.contains(argumentConfiguration.displayKey)) {
            throw ArgumentError(
                '${argumentConfiguration.displayKey} was supplied more than once');
          }

          // Adding as a list failed, so it must not be a list. Let's set it
          // as a normal value.
          instanceMirror.setField(
              argumentConfiguration.mirror.simpleName, value);
          _wasSet.add(argumentConfiguration.displayKey);
        }
      }

      if (argumentConfiguration.argument is HelpArgument) {
        _extras.addAll(arguments.skip(argumentIndex));

        return false;
      }
    }

    return true;
  }

  void _validate() {
    // Check to see if we have any required arguments missing
    final List<String> isMissing = [];
    for (var mpp in _mirrorParameterPairs) {
      if (mpp.argument.isRequired == true &&
          _wasSet.contains(mpp.displayKey) == false) {
        isMissing.add(mpp.displayKey);
      }
    }

    if (isMissing.isNotEmpty) {
      throw ArgumentError(
          'missing required arguments: ${isMissing.join(', ')}');
    }

    if (_app.minimumExtras != null && extras.length < _app.minimumExtras) {
      throw ArgumentError(
          'expecting at least ${_app.minimumExtras} free form arguments but ${extras.length} was supplied');
    } else if (_app.maximumExtras != null &&
        extras.length > _app.maximumExtras) {
      throw ArgumentError(
          'expecting at most ${_app.maximumExtras} free form arguments but ${extras.length} was supplied');
    }
  }

  void _resetParser() {
    _wasSet = {};
    _extras = [];
  }
}