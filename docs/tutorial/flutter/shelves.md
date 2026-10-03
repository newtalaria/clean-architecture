---
title: Shelves on Flutter
description: The shelf form and list. The place control is the next chapter.
tags: [clean-architecture, tutorial, flutter]
---

The shelf screen follows the book screen. Read [books](presentation.md) for the notifier and the page shape. This page adds a capacity field and a tile.

`ShelfTile` takes `name` and `capacity`. It imports Flutter only. The widget test can pump it without `ProviderScope`.

`ShelvesNotifier.save` parses nothing itself. The page parses the capacity field with `int.tryParse` and passes `0` when the text is not a number. `Shelf.create` rejects `0`, the use case throws `ValidationFailure`, and the notifier returns `Capacity must be from 1 to 500`. Parsing in the page is presentation. The legal range is the entity.

`saveShelfUseCaseProvider` and `listShelvesUseCaseProvider` watch `shelfRepositoryProvider`. The page watches `shelvesProvider`.

`ShelvesLocation` uses `RoutePaths.shelves` and wraps `ShelvesPage` in `ScreenReporter`. `ShelfNav` can now beam to both paths.

Leave the place row out until the server use case exists. A button that calls `client.shelf.place` from the page would skip the use case provider.

```bash
flutter test
```

Next: [place a book on a shelf](../server/place-book.md).
