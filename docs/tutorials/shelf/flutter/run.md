---
title: Run the app
description: Point the client at port 8280, save a book, and see it in the list.
tags: [clean-architecture, tutorial, flutter]
---

`main.dart` is the bootstrap. It builds the `Client`, overrides `clientProvider`, and calls `runApp`. It does not construct a repository. The providers do that. `ShelfMonitoring` is the stub from the books screen.

```dart
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:shelf_client/shelf_client.dart';
import 'package:shelf_flutter/app/providers.dart';
import 'package:shelf_flutter/bootstrap/talaria_monitoring.dart';
import 'package:shelf_flutter/shelf_app.dart';

const shelfApiUrl = String.fromEnvironment(
  'SHELF_API_URL',
  defaultValue: 'http://localhost:8280/',
);

Future<void> main() {
  usePathUrlStrategy();
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

`usePathUrlStrategy()` runs before `runApp`, so a web session uses `/shelves` in the address bar. Import it from `package:flutter_web_plugins/url_strategy.dart`. The Flutter project page lists `flutter_web_plugins` so that import is a direct dependency.

`ShelfMonitoring.bootstrap` calls `WidgetsFlutterBinding.ensureInitialized()` and then `startApp`. When `TALARIA_API_KEY` is empty, that happens in the root zone. The instrumentation chapter replaces the stub and puts both calls inside one zone. An empty key must not call `TalariaFlutter.init`.

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
