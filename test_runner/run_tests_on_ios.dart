import 'dart:io';
import './integration_tests_common.dart';

Future<void> main(args) async {
  final simulator = args.first;
  await shutdownSimulator(simulator);
  await Process.run(
    'xcrun',
    [
      'simctl',
      'bootstatus',
      simulator,
      '-b',
    ],
  ).then((process) {
    print(process.stdout);
    print(process.stderr);
  });
  await runIntegrationTests(
    errorExitAction: () async => await shutdownSimulator(simulator),
    debug: true,
  );
  await shutdownSimulator(simulator);
}

Future<void> shutdownSimulator(String simulator) async {
  await Process.run(
    'xcrun',
    [
      'simctl',
      'shutdown',
      simulator,
    ],
  ).then((process) {
    print(process.stdout);
    print(process.stderr);
  });
}
