import 'dart:async';
import 'dart:io';

import 'ci_runner_common.dart';

Future<void> main() async {
  final stopWatch = Stopwatch();
  stopWatch.start();
  final pubResult = await runPub(['get']);
  if (pubResult.exitCode != 0) {
    printError('pub get');
    exit(pubResult.exitCode);
  } else {
    printDone('pub get');
  }

  var result = 0;
  await runPubGlobalActivate(['dart_enum_to_string_check']);
  final dartEnumToStringCheckResult =
      await runPubGlobalRun(['dart_enum_to_string_check']);
  if (dartEnumToStringCheckResult.exitCode != 0) {
    result = -1;
    printError('dart_enum_to_string_check');
  } else {
    printDone('dart_enum_to_string_check');
  }

  await runPubGlobalActivate(['analyzer_formatter']);
  final analyzerResult = await runFlutter(['analyze']).then((processResult) {
    final analyzerReport = File('analyzer_report.txt');
    if (analyzerReport.existsSync()) {
      analyzerReport.deleteSync();
    }
    analyzerReport.writeAsStringSync(processResult.stdout);
    if (processResult.exitCode != 0) {
      result = -1;
      printError('Dart Analyzer');
    } else {
      printDone('Dart Analyzer');
    }
    return processResult;
  });
  if (analyzerResult.exitCode != 0) {
    result = -1;
    printError('analyzer_formatter');
  } else {
    printDone('analyzer_formatter');
  }
  await runPubGlobalRun(['analyzer_formatter']);

  final testsResult =
      await runFlutter('test --machine'.split(' ')).then((processResult) {
    final testReport = File('report.json');
    if (testReport.existsSync()) {
      testReport.deleteSync();
    }
    testReport.writeAsStringSync(processResult.stdout);
    if (processResult.exitCode != 0) {
      result = -1;
    }
    return processResult;
  });
  if (testsResult.exitCode != 0) {
    result = -1;
    printError('flutter test');
  } else {
    printDone('flutter test');
  }
  await runPubGlobalActivate(['junitreport']);
  final junitReportResult = await runPubGlobalRun(
      'junitreport:tojunit --input report.json --output junit-report.xml'
          .split(' '));
  if (junitReportResult.exitCode != 0) {
    result = -1;
    printError('junitreport');
  } else {
    printDone('junitreport');
  }

  stopWatch.stop();
  print(
      'BUILD DONE IN ${Duration(seconds: stopWatch.elapsedMilliseconds).inMinutes} ms');
  exit(result);
}
