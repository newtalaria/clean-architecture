import 'dart:io';

import 'package:talaria_serverpod/talaria_serverpod.dart';

/// Starts Talaria when a key is present. An empty key leaves the process alone.
Future<void> initTalaria() async {
  final apiKey = Platform.environment['TALARIA_API_KEY'] ?? '';
  if (apiKey.isEmpty) return;

  await TalariaServerpod.init(
    TalariaOptions(
      dsn: 'https://ingest.newtalaria.com',
      apiKey: apiKey,
      release: Platform.environment['TALARIA_RELEASE'] ?? 'dev',
      tags: const {'service': 'shelf'},
    ),
  );
}
