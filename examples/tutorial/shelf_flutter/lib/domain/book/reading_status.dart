import 'package:dart_mappable/dart_mappable.dart';

part 'reading_status.mapper.dart';

/// Where the reader is with a book. Dart on the client, a spy enum on the wire.
@MappableEnum()
enum ReadingStatus { unread, reading, read }
