---
title: Run the app
description: Point the client at port 8280, save a book, and see it in the list.
tags: [clean-architecture, tutorial, flutter]
---

`main.dart` is the bootstrap. It builds the `Client`, overrides `clientProvider`, and calls `runApp`. It does not construct a repository. The providers do that.

```dart
const shelfApiUrl = String.fromEnvironment(
  'SHELF_API_URL',
  defaultValue: 'http://localhost:8280/',
);

Future<void> main() {
  return ShelfMonitoring.bootstrap(() async {
    final client = Client(
      shelfApiUrl,
      httpClientOverride: ShelfMonitoring.shouldInit(ShelfMonitoring.apiKey)
          ? ShelfMonitoring.httpClient()
          : http.Client(),
    )..connectivityMonitor = FlutterConnectivityMonitor();

    runApp(
      ProviderScope(
        overrides: [clientProvider.overrideWithValue(client)],
        child: const ShelfApp(),
      ),
    );
  });
}
```

`ShelfMonitoring.bootstrap` calls `WidgetsFlutterBinding.ensureInitialized()` and then `startApp`. When `TALARIA_API_KEY` is empty, that happens in the root zone. You will put both calls inside one zone in the Talaria chapter. The structure is already the method the chapter fills in. Copy it from the finished `lib/bootstrap/talaria_monitoring.dart` when you get there, or leave the empty-key path in place now. An empty key must not call `TalariaFlutter.init`.

Start the server if it is not running:

```bash
cd shelf_server
docker compose up --build --detach
dart run bin/main.dart --apply-migrations
```

Start the app:

```bash
cd shelf_flutter
flutter run -d chrome
```

Open `/books`. Save a book with a title and an author. The list shows the trimmed title. Save a book with a blank title. The page shows `Title is required` and the list does not grow.

```bash
flutter test
```

That is the demo. Shelves are the same path, shorter, because you have already seen every kind of file.

Next: [shelves on the server](../server/shelves.md).
