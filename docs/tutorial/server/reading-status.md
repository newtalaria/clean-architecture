---
title: Reading status
description: The unread, reading, and read states as a Dart enum. The wire enum comes later and is a different type.
tags: [clean-architecture, tutorial, serverpod]
---

Reading status is a closed set of three values. It is not a string column and it is not the enum the Flutter client will receive. Those are two other types, written in spy files, mapped at the edges.

Create `lib/src/domain/book/value_objects/reading_status.dart`:

```dart
/// Where the reader is with a book. This is Dart, not a spy enum.
enum ReadingStatus { unread, reading, read }
```

A Dart enum needs no YAML and no `serverpod generate`. If you later add a fourth status, you change this file, the wire enum, and the two mappers. The database column stays a string. The mapper writes `status.name` and reads it back with `ReadingStatus.values.byName`.

Next: [the book entity](book.md).
