import 'dart:io';

Future<void> runIntegrationTests({
  Function? errorExitAction,
  bool debug = false,
}) async {
  final integrationTestDirectory = Directory('integration_test');
  final testFiles = integrationTestDirectory
      .listSync(recursive: true)
      .where((e) => e.path.endsWith('_test.dart'));
  for (final file in testFiles) {
    final process = await _runTestInFile(
      file,
      debug: debug,
    );
    if (process.exitCode != 0) {
      print('TEST ERROR: ${file.path}');
      print(process.stdout);
      print(process.stderr);
      errorExitAction?.call();
      exit(process.exitCode);
    } else {
      print('SUCCESS: ${file.path}');
    }
  }
  await Future.delayed(
    Duration(
      seconds: 15,
    ),
  );
}

Future<ProcessResult> _runTestInFile(
  FileSystemEntity testFile, {
  bool debug = false,
}) {
  return Process.run(
    'flutter',
    [
      'drive',
      if (!debug) '--profile',
      '--driver=test_driver/integration_test.dart',
      '--target=${testFile.path}',
    ],
  );
}
