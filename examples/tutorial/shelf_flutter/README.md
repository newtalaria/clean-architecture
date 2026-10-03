# shelf_flutter

Hybrid Flutter client for the Shelf tutorial. `domain/`, `application/`, and `data/` are horizontal. Screens live in `presentation/features/`. `ui/` does not import Riverpod.

The walkthrough is [the Shelf tutorial](../../docs/tutorial/README.md).

```bash
flutter test
flutter run -d chrome
```

The app calls `http://localhost:8280/` unless you pass `--dart-define=SHELF_API_URL=...`.
