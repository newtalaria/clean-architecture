---
title: Flutter instrumentation
description: Optional init, one zone around the binding and runApp, HTTP wrap, setScreen, and identify.
tags: [clean-architecture, tutorial, flutter]
---

`lib/bootstrap/talaria_monitoring.dart` is `ShelfMonitoring`. An empty `TALARIA_API_KEY` keeps the SDK off. The key is a `String.fromEnvironment`, so a normal `flutter run` does not turn it on.

`shouldInit` trims the key and returns false when it is empty. `options` builds `TalariaOptions` with the DSN `https://ingest.newtalaria.com`, `minLevel: SeverityLevel.warning`, and the tag `service: shelf`.

`bootstrap` is the method `main` already calls. When the key is empty it runs `WidgetsFlutterBinding.ensureInitialized()` and then `startApp` in the root zone. When the key is set, both of those run inside `runZonedGuarded`. Flutter reports a zone mismatch if the binding is created outside the zone that later calls `runApp`. The zone's error handler calls `client.captureException` when a client exists.

`init` calls `TalariaFlutter.init` and sets `ErrorWidget.builder` to `talariaErrorWidgetBuilder()`.

`httpClient` returns `Talaria.wrapHttpClient` only when the key is set. `main` passes that client as `httpClientOverride` on the Serverpod `Client`. The book repository does not wrap HTTP itself.

`setScreen` drops an empty path and drops a repeat of the same path and title. `BooksLocation` and `ShelvesLocation` call it from `ScreenReporter.initState`. `TalariaFlutter.setScreen` runs only when `Talaria.getClient()` is non-null.

`setSignedInUser` calls `Talaria.setUser`, opts analytics in, and `identify`s once per user id. `clearSignedInUser` opts out, clears the user, and resets analytics. Shelf has no accounts, so the running app does not call these. They are on the monitoring type so the session code has one place to call when you add a signed-in user. The test calls them with no client and expects them to return.

`ShelfApp` wraps the router child in `TalariaScreenCapture`.

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
