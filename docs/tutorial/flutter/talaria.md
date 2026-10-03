---
title: Flutter instrumentation
description: Optional init, one zone around the binding and runApp, HTTP wrap, setScreen, and identify.
tags: [clean-architecture, tutorial, flutter]
---

`lib/bootstrap/talaria_monitoring.dart` is `ShelfMonitoring`. An empty `TALARIA_API_KEY` keeps the SDK off. The key is a `String.fromEnvironment`, so a normal `flutter run` does not turn it on.

```dart
import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:talaria_flutter/talaria_flutter.dart';

/// Optional instrumentation. An empty `TALARIA_API_KEY` leaves the SDK off.
///
/// [bootstrap] keeps [WidgetsFlutterBinding.ensureInitialized] and `runApp`
/// in one zone.
class ShelfMonitoring {
  ShelfMonitoring._();

  static const dsn = 'https://ingest.newtalaria.com';
  static const apiKey = String.fromEnvironment('TALARIA_API_KEY');
  static const release = String.fromEnvironment(
    'TALARIA_RELEASE',
    defaultValue: 'dev',
  );

  static String? _identifiedUserId;
  static String? _lastScreenPath;
  static String? _lastScreenTitle;

  static bool shouldInit(String key) => key.trim().isNotEmpty;

  static TalariaOptions options({String? key}) {
    return TalariaOptions(
      dsn: dsn,
      apiKey: (key ?? apiKey).trim(),
      release: release,
      minLevel: SeverityLevel.warning,
      tags: const {'service': 'shelf'},
    );
  }

  static Future<bool> init({String? key}) async {
    final resolved = (key ?? apiKey).trim();
    if (!shouldInit(resolved)) return false;
    await TalariaFlutter.init(options(key: resolved));
    ErrorWidget.builder = talariaErrorWidgetBuilder();
    return true;
  }

  static Future<void> bootstrap(Future<void> Function() startApp) {
    if (!shouldInit(apiKey)) {
      WidgetsFlutterBinding.ensureInitialized();
      return startApp();
    }

    final started = Completer<void>();
    runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        await init();
        await startApp();
        if (!started.isCompleted) started.complete();
      },
      (Object error, StackTrace stack) {
        final client = Talaria.getClient();
        if (client != null) {
          // ignore: discarded_futures
          client.captureException(
            error,
            stackTrace: stack,
            context: const CaptureContext(
              mechanism: ExceptionMechanism(type: 'zone', handled: false),
            ),
          );
        }
        if (!started.isCompleted) started.completeError(error, stack);
      },
    );
    return started.future;
  }

  static http.Client httpClient() {
    final client = http.Client();
    if (!shouldInit(apiKey)) return client;
    return Talaria.wrapHttpClient(client);
  }

  static void setSignedInUser({required String userId, String? name}) {
    if (Talaria.getClient() == null) return;
    Talaria.setUser(userId);
    Talaria.analytics.optIn();
    if (_identifiedUserId == userId) return;
    _identifiedUserId = userId;
    unawaited(
      Talaria.analytics.identify(
        userId,
        traits: {
          if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
        },
      ),
    );
  }

  static void clearSignedInUser() {
    if (Talaria.getClient() == null) return;
    _identifiedUserId = null;
    _lastScreenPath = null;
    _lastScreenTitle = null;
    Talaria.analytics.optOut();
    Talaria.setUser(null);
    unawaited(Talaria.analytics.reset());
  }

  static void setScreen(String path, {String? title}) {
    final label = path.trim();
    if (label.isEmpty || Talaria.getClient() == null) return;
    final screenTitle = title?.trim();
    final resolvedTitle = (screenTitle == null || screenTitle.isEmpty)
        ? null
        : screenTitle;
    if (_lastScreenPath == label && _lastScreenTitle == resolvedTitle) return;
    _lastScreenPath = label;
    _lastScreenTitle = resolvedTitle;
    TalariaFlutter.setScreen(label, title: resolvedTitle);
  }
}
```

`shouldInit` trims the key and returns false when it is empty. `options` builds `TalariaOptions` with the DSN `https://ingest.newtalaria.com`, `minLevel: SeverityLevel.warning`, and the tag `service: shelf`.

`bootstrap` is the method `main` already calls. When the key is empty it runs `WidgetsFlutterBinding.ensureInitialized()` and then `startApp` in the root zone. When the key is set, both of those run inside `runZonedGuarded`. Flutter reports a zone mismatch if the binding is created outside the zone that later calls `runApp`. The zone's error handler calls `client.captureException` when a client exists.

`httpClient` returns `Talaria.wrapHttpClient` only when the key is set. `main` passes that client as `httpClientOverride` on the Serverpod `Client`. The book repository does not wrap HTTP itself.

`setScreen` drops an empty path and drops a repeat of the same path and title. `BooksLocation` and `ShelvesLocation` call it from `ScreenReporter.initState`. `TalariaFlutter.setScreen` runs only when `Talaria.getClient()` is non-null.

`setSignedInUser` calls `Talaria.setUser`, opts analytics in, and `identify`s once per user id. `clearSignedInUser` opts out, clears the user, and resets analytics. Shelf has no accounts, so the running app does not call these. They are on the monitoring type so the session code has one place to call when you add a signed-in user. The test calls them with no client and expects them to return.

`ShelfApp` wraps the router child in `TalariaScreenCapture`. That widget stays idle until a client exists and screen capture is enabled.

`test/unit/monitoring_test.dart`:

- `shouldInit('')` and `shouldInit('   ')` are false. `shouldInit('tal_live_x')` is true.
- `setScreen`, `setSignedInUser`, and `clearSignedInUser` do not throw when no client exists.
- `BooksLocation().pathPatterns` is `[RoutePaths.books]`.

```bash
flutter test
```

To send events, run with a key:

```bash
flutter run -d chrome \
  --dart-define=TALARIA_API_KEY=tal_live_your_key \
  --dart-define=TALARIA_RELEASE=dev
```

Open `/books`, then `/shelves`. Each location reports its screen once.

Next: [where to go next](../close.md).
