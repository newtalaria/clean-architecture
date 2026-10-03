---
title: Server instrumentation
description: Start talaria_serverpod when TALARIA_API_KEY is set, and attach it on the Serverpod constructor.
tags: [clean-architecture, tutorial, serverpod]
---

Instrumentation is an adapter. It is constructed in the bootstrap, next to the composition root. `Book` and `PlaceBookOnShelfUseCase` do not import it.

Create `lib/src/bootstrap/talaria_monitoring.dart`:

```dart
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
```

`lib/server.dart` uses the generated `Serverpod` constructor. That class already binds `Protocol()` and `Endpoints()`. You pass the database interceptor on the constructor. Serverpod does not let you swap it later. The interceptor no-ops until `init` has run and tracing is on.

Import `package:serverpod/serverpod.dart` as `sp` so the name `Serverpod` is the generated class, not the framework class.

```dart
final pod = Serverpod(
  args,
  databaseInterceptor: TalariaServerpod.interceptDatabase,
  experimentalFeatures: sp.ExperimentalFeatures(
    diagnosticEventHandlers: [
      sp.AsEventHandler<sp.ExceptionEvent>((
        event, {
        required space,
        required context,
      }) {
        TalariaServerpod.handleExceptionEvent(event, context: context);
      }),
    ],
  ),
);

await initTalaria();
TalariaServerpod.attach(pod);
await pod.start();
```

`TalariaServerpod.attach` adds Relic middleware so each endpoint RPC opens a SERVER span. `interceptDatabase` wraps Postgres calls as CLIENT spans. Diagnostic exceptions from the endpoint become Talaria events. An empty `TALARIA_API_KEY` leaves the process uninstrumented: `initTalaria` returns, and `attach` returns because there is no client.

The packages are already in `pubspec.yaml` from the first chapter. Turn tracing on in the Talaria project settings when you want successful transactions sampled. Error transactions are sent either way. The key decides the environment.

```bash
dart test
```

The unit tests still do not start Talaria. They never call `initTalaria`.

Next: [Flutter instrumentation](../flutter/talaria.md).
