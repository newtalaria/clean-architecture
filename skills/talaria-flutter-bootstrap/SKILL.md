---
name: talaria-flutter-bootstrap
description: Instruments a Flutter app with talaria_flutter. Conditional init, one zone around binding and runApp, HTTP client wrap, setScreen, identify and clear user, and TalariaScreenCapture. Use when adding Talaria to Flutter, editing bootstrap, Beamer screen reporting, or TALARIA_API_KEY.
---

# Talaria Flutter bootstrap

Instrumentation is an adapter. It lives in bootstrap, next to the composition root. Domain entities, use cases, and presentational widgets do not import `talaria_flutter`.

The reference is `examples/flutter/hybrid/lib/bootstrap/talaria_monitoring.dart` in [newtalaria/clean-architecture](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/hybrid/lib/bootstrap/talaria_monitoring.dart).

## Init

Read the key with `String.fromEnvironment('TALARIA_API_KEY')`. An empty string leaves the SDK off. `shouldInit` is `key.trim().isNotEmpty`.

`TalariaFlutter.init` takes `TalariaOptions` with `dsn: https://ingest.newtalaria.com`, the trimmed key, a release, and a `service` tag. Then set `ErrorWidget.builder` to `talariaErrorWidgetBuilder()`.

## One zone

`WidgetsFlutterBinding.ensureInitialized` and `runApp` share a zone. Flutter reports a zone mismatch when the binding is created outside the zone that later calls `runApp`.

When the key is empty, call `WidgetsFlutterBinding.ensureInitialized()` and then `startApp()` in the root zone.

When the key is set, `runZonedGuarded` wraps binding init, `init`, and `startApp`. The error handler calls `client.captureException` with mechanism type `zone` and `handled: false` when a client exists.

## HTTP

At the composition root, `Talaria.wrapHttpClient(http.Client())` only when `shouldInit` is true. Otherwise pass a plain `http.Client`. Do not wrap the Talaria ingest client.

## Screen, user, capture

`setScreen` drops a repeat of the same path and title, and returns immediately when `Talaria.getClient()` is null. Call it from the Beamer location when that location is shown, not from a use case.

`setSignedInUser` sets the user, calls `Talaria.analytics.optIn()`, and `identify`. `clearSignedInUser` calls `optOut`, `Talaria.setUser(null)`, and `analytics.reset`, and clears the last screen so the next account is a new visitor. Both return when no client exists.

Wrap the child of `MaterialApp.router`'s `builder` in `TalariaScreenCapture`.

Pass the key at launch with `--dart-define=TALARIA_API_KEY=...`.
