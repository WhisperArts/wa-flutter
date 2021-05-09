import 'dart:io';

Future<ProcessResult> runPubGlobalRun(List<String> args) =>
    runPub([...'global run'.split(' '), ...args]);

Future<ProcessResult> runPubGlobalActivate(List<String> args) =>
    runPub([...'global activate'.split(' '), ...args]);

Future<ProcessResult> runPub(List<String> args) => runFlutter(['pub', ...args]);

Future<ProcessResult> runFlutter(List<String> args) => run('flutter', args);

Future<ProcessResult> run(String command, List<String> args) async {
  final processResult = await Process.run(command, args);
  if (processResult.exitCode != 0) {
    print(processResult.stdout);
    print(processResult.stderr);
  }
  return processResult;
}

void printDone(String message) => print('DONE: $message');

void printError(String message) => print('ERROR: $message');
