---
title: Where to go next
description: The dependency picture for placing a book, and the short courses if you want to compare layouts.
tags: [clean-architecture, tutorial]
---

Placing a book crosses one boundary you should be able to draw from memory.

```text
ShelfEndpoint.place
  -> ShelfWireMappers stays out of this method
  -> BookWireMappers.toDto
  -> PlaceBookOnShelfUseCase.execute
       -> ShelfRepository.findById
       -> BookRepository.findById
       -> BookRepository.countOnShelf
       -> Shelf.ensureRoomForAnother
       -> Book.placeOnShelf
       -> BookRepository.save
            -> BookMapper
            -> StoredBook.db
```

The Flutter button stops at `PlaceBookOnShelfUseCase`, which stops at `BookRepository.placeOnShelf`, which stops at `client.shelf.place`. The capacity rule is not in the button.

A favourite is the same shape on one repository.

```text
BookEndpoint.setFavorite
  -> SetBookFavoriteUseCase.execute
       -> BookRepository.findById
       -> Book.setFavorite
       -> BookRepository.save
```

The heart stops at `SetBookFavoriteUseCase`. The tile does not import Riverpod. It receives `favorite` and `onFavorite`.

The three short courses build a notes API in each layout if you want to diff a smaller tree:

- [Serverpod](../../serverpod/README.md), including the [hybrid](../../serverpod/hybrid/README.md) track this tutorial follows and the [layer-first](../../serverpod/layer-first/README.md) track a large existing server may already use
- [Flutter](../../flutter/README.md), including the [hybrid](../../flutter/hybrid/README.md) track
- [Skills](../../skills/README.md), to copy the dependency rule onto the next project

The book, before any of those folders, is [Principles](../../principles/README.md) and [Layers](../../layers/README.md).
