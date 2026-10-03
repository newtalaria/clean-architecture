---
title: Flutter project
description: Add shelf_flutter to the workspace, depend on shelf_client, and keep protocol types out of the domain.
tags: [clean-architecture, tutorial, flutter]
---

The client is a second package. It does not import `shelf_server`. It imports `shelf_client`, which `serverpod generate` already filled with `BookDto`, `SaveBookInput`, and `ReadingStatusWire`.

From `examples/tutorial`:

```bash
flutter create --platforms web --project-name shelf_flutter shelf_flutter
```

Add `shelf_flutter` to the workspace `pubspec.yaml` list. In the Flutter `pubspec.yaml`, set `resolution: workspace` and depend on:

```yaml
dependencies:
  beamer: ^1.7.0
  dart_mappable: ^4.8.0
  flutter:
    sdk: flutter
  flutter_riverpod: ^3.3.2
  http: ^1.4.0
  serverpod_flutter: 4.0.1
  shelf_client:
  talaria_flutter: ^0.2.5
  uuid: ^4.5.3

dev_dependencies:
  build_runner: ^2.4.15
  dart_mappable_builder: ^4.8.0
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

`shelf_client:` has no version because it is another member of the workspace.

Make the folders:

```text
lib/domain/book/
lib/domain/shelf/
lib/domain/shared/
lib/application/book/
lib/application/shelf/
lib/application/ports/
lib/data/
lib/presentation/features/books/
lib/presentation/features/shelves/
lib/presentation/router/
lib/ui/
lib/app/
lib/bootstrap/
```

The dependency rule on the client:

| Layer | May import | Must not import |
| --- | --- | --- |
| Domain | Dart and `dart_mappable` | Flutter, Riverpod, `shelf_client` |
| Application | domain | Flutter, Riverpod, `shelf_client`, `data/` |
| Data | domain and `shelf_client` | application, presentation, `ui/` |
| Presentation | domain, `app/providers.dart`, `ui/` | `data/`, `ServerpodBookRepository` |
| UI | Flutter, and strings or domain values passed as arguments | Riverpod, repositories, use cases |
| App | domain, application, data | feature pages |

Protocol types stay in `data/` and in `main.dart`, where the `Client` is constructed.

From the workspace root:

```bash
dart pub get
```

Next: [the client domain](domain.md).
