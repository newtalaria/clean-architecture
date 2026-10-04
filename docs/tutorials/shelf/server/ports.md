---
title: Ports
description: A clock and an id generator. The use case does not call DateTime.now or Uuid itself.
tags: [clean-architecture, tutorial, serverpod]
---

A use case that calls `DateTime.now()` cannot be told that today is 3 October 2026. A use case that calls `Uuid().v4()` cannot be told that the next id is a fixed string. Both are side effects, so both are ports. They live under `application/ports/` because every feature may use them, and they are not domain entities.

Create `lib/src/application/ports/clock.dart`:

```dart
/// Time source for use cases. Tests pass a fixed clock.
abstract interface class Clock {
  DateTime now();
}

class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now().toUtc();
}
```

`SystemClock` is the production adapter. It is still application code: it has no `Session` and no HTTP. The composition root will pass it in. A test passes a different class that returns one instant.

Create `lib/src/application/ports/id_generator.dart`:

```dart
import 'package:uuid/uuid.dart';

/// Identity source for new entities. Tests pass a sequence.
abstract interface class IdGenerator {
  String newId();
}

class UuidIdGenerator implements IdGenerator {
  const UuidIdGenerator();

  static const _uuid = Uuid();

  @override
  String newId() => _uuid.v4();
}
```

The domain id stays a `String`. This port is where a UUID is chosen. The database column is a `UuidValue` only after the mapper parses that string. Do not generate the id in the spy model and also in this port. Shelf generates it here, and the row stores the value it was given. `defaultPersist=random_v7` on the column is a fallback for a row inserted without an id. The use case always sets one.

Next: [save a book](save-book.md).
