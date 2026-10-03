import 'dart:io';

import 'package:talaria_serverpod/talaria_serverpod.dart';

/// Starts Talaria when a key is present. Register
/// `databaseInterceptor: TalariaServerpod.interceptDatabase` on the `Serverpod`
/// constructor, then call [initTalaria] and `TalariaServerpod.attach(pod)`
/// before `pod.start`. An empty key leaves the process uninstrumented.
Future<void> initTalaria() async {
  final apiKey = Platform.environment['TALARIA_API_KEY'] ?? '';
  if (apiKey.isEmpty) return;

  await TalariaServerpod.init(
    TalariaOptions(
      dsn: 'https://ingest.newtalaria.com',
      apiKey: apiKey,
      release: Platform.environment['TALARIA_RELEASE'] ?? 'dev',
      tags: const {'service': 'notes'},
    ),
  );
}
