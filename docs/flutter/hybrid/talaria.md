---
title: Talaria
description: Initialize talaria_flutter when TALARIA_API_KEY is set, in one zone with runApp.
tags: [clean-architecture, flutter]
---

Instrumentation is an adapter. It is constructed in the bootstrap, next to the composition root, and it stays out of `Note`, `SaveNoteUseCase`, and the note tile.

[`lib/bootstrap/talaria_monitoring.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/hybrid/lib/bootstrap/talaria_monitoring.dart) starts the client only when a key is present. The sample reads `TALARIA_API_KEY` from `--dart-define`. An empty or blank value leaves the SDK off. `shouldInit` trims the key first.

`bootstrap` is the entrypoint. `WidgetsFlutterBinding.ensureInitialized` and `runApp` share one zone. Flutter reports a zone mismatch when the binding is created outside the zone that later calls `runApp`.

```dart
static Future<void> bootstrap(Future<void> Function() startApp) {
  if (!shouldInit(apiKey)) {
    WidgetsFlutterBinding.ensureInitialized();
    return startApp();
  }

  final started = Completer<void>();
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await init();
    await startApp();
    if (!started.isCompleted) started.complete();
  }, (Object error, StackTrace stack) {
    final client = Talaria.getClient();
    if (client != null) {
      client.captureException(
        error,
        stackTrace: stack,
        context: const CaptureContext(
          mechanism: ExceptionMechanism(type: 'zone', handled: false),
        ),
      );
    }
    if (!started.isCompleted) started.completeError(error, stack);
  });
  return started.future;
}
```

`init` calls `TalariaFlutter.init` and installs `talariaErrorWidgetBuilder`. Zone errors use mechanism type `zone`.

[`lib/main.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/hybrid/lib/main.dart) passes `NotesMonitoring.httpClient()` into the provider scope. With a key, that is `Talaria.wrapHttpClient`, so later HTTP calls carry the trace header. Without a key, it is a plain `http.Client`.

`setSignedInUser` sets the user, opts in, and identifies. `clearSignedInUser` opts out, clears the user, and resets analytics so the next account is a new visitor. Both return immediately when no client exists.

Beamer reports the screen. The notes location builds a `ScreenReporter`, which calls `setScreen` with the path and title. The same path and title twice in a row is one screen.

[`lib/notes_app.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/hybrid/lib/notes_app.dart) wraps the routed child:

```dart
builder: (context, child) {
  return TalariaScreenCapture(child: child ?? const SizedBox.shrink());
},
```

`TalariaScreenCapture` records taps, scroll depth, and an on-request snapshot. It belongs at the top of the tree, around the child `MaterialApp.router` builds.

`test/unit/monitoring_test.dart` checks the empty key and the no-client returns. The [tests](tests.md) page lists it with the others.

The package is `talaria_flutter`, already in this example's `pubspec.yaml`. Pass the key when you want the SDK on:

```bash
flutter run --dart-define=TALARIA_API_KEY=your_key
```

That is the end of this track. The [chooser](../README.md) links the other two layouts.
