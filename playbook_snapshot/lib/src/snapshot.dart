import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:playbook/playbook.dart';

class Snapshot extends TestTool {
  Snapshot({required this.directoryPath, required this.devices});

  final String directoryPath;
  final List<SnapshotDevice> devices;

  @override
  Future<void> run(Playbook playbook, PlaybookBuilder builder) async {
    setUpAll(() async {
      await FontBuilder.loadFonts();
    });

    await Directory(directoryPath).create();

    for (final device in devices) {
      final ensuredDirectoryPath = '$directoryPath/${device.name}';
      await Directory(ensuredDirectoryPath).create();

      for (final story in playbook.stories) {
        for (final scenario in story.scenarios) {
          final scenarioWidget = builder(scenario.child);

          testWidgets('Snapshot for ${story.title} ${scenario.title}', (tester) async {
            await SnapshotSupport.startDevice(scenarioWidget, tester, device);
            await SnapshotSupport.resize(scenarioWidget, scenario, tester, device);

            await expectLater(
              find.byWidget(scenario.child),
              matchesGoldenFile('$ensuredDirectoryPath/${story.title}_${scenario.title}.png'),
            );
          });
        }
      }
    }
  }
}