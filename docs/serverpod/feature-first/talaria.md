---
title: Talaria
description: Initialize talaria_serverpod when TALARIA_API_KEY is set, and attach it on the Serverpod constructor.
tags: [clean-architecture, serverpod, feature-first]
---

Instrumentation is an adapter. It is constructed in the bootstrap, next to the composition root, and it stays out of `Note` and `SaveNoteUseCase`.

[`lib/src/bootstrap/talaria_monitoring.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/serverpod/feature_first/lib/src/bootstrap/talaria_monitoring.dart) starts the client only when a key is present. An empty `TALARIA_API_KEY` leaves the process alone.

```dart
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
```

When you generate the Serverpod server, register the adapter on the constructor and attach it before `start`. `interceptDatabase` has to be passed there. Serverpod does not let you swap it later. It no-ops until `init` has run and tracing is on.

```dart
final pod = Serverpod(
  args,
  Protocol(),
  Endpoints(),
  databaseInterceptor: TalariaServerpod.interceptDatabase,
  experimentalFeatures: ExperimentalFeatures(
    diagnosticEventHandlers: [
      AsEventHandler<ExceptionEvent>((event, {required space, required context}) {
        TalariaServerpod.handleExceptionEvent(event);
      }),
    ],
  ),
);

await initTalaria();
TalariaServerpod.attach(pod);
await pod.start();
```

`TalariaServerpod.attach` adds Relic middleware so each endpoint RPC opens a SERVER span. `interceptDatabase` wraps Postgres calls as CLIENT spans. Diagnostic exceptions from the endpoint become Talaria events. On shutdown, `await Talaria.flush()` and `await Talaria.close()`.

The packages are `talaria` and `talaria_serverpod`, already in this example's `pubspec.yaml`. Turn tracing on in Project settings when you want successful transactions sampled. Error transactions are sent either way. The key decides the environment.

That is the end of this track. The [chooser](../README.md) links the other two layouts.
