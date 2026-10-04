/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../../presentation/book/reading_status_wire.dart' as _ifap2468;

abstract class BookDto
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  BookDto._({
    required this.id,
    required this.title,
    required this.authorName,
    required this.status,
    this.shelfId,
    required this.createdAt,
    required this.favorite,
  });

  factory BookDto({
    required _isc.UuidValue id,
    required String title,
    required String authorName,
    required _ifap2468.ReadingStatusWire status,
    _isc.UuidValue? shelfId,
    required DateTime createdAt,
    required bool favorite,
  }) = _BookDtoImpl;

  factory BookDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return BookDto(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      title: jsonSerialization['title'] as String,
      authorName: jsonSerialization['authorName'] as String,
      status: _ifap2468.ReadingStatusWire.fromJson(
        (jsonSerialization['status'] as String),
      ),
      shelfId: jsonSerialization['shelfId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['shelfId']),
      createdAt: _isc.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      favorite: _isc.BoolJsonExtension.fromJson(jsonSerialization['favorite']),
    );
  }

  _isc.UuidValue id;

  String title;

  String authorName;

  _ifap2468.ReadingStatusWire status;

  _isc.UuidValue? shelfId;

  DateTime createdAt;

  bool favorite;

  /// Returns a shallow copy of this [BookDto]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  BookDto copyWith({
    _isc.UuidValue? id,
    String? title,
    String? authorName,
    _ifap2468.ReadingStatusWire? status,
    _isc.UuidValue? shelfId,
    DateTime? createdAt,
    bool? favorite,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BookDto',
      'id': id.toJson(),
      'title': title,
      'authorName': authorName,
      'status': status.toJson(),
      if (shelfId != null) 'shelfId': shelfId?.toJson(),
      'createdAt': createdAt.toJson(),
      'favorite': favorite,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BookDto',
      'id': id.toJson(),
      'title': title,
      'authorName': authorName,
      'status': status.toJson(),
      if (shelfId != null) 'shelfId': shelfId?.toJson(),
      'createdAt': createdAt.toJson(),
      'favorite': favorite,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BookDtoImpl extends BookDto {
  _BookDtoImpl({
    required _isc.UuidValue id,
    required String title,
    required String authorName,
    required _ifap2468.ReadingStatusWire status,
    _isc.UuidValue? shelfId,
    required DateTime createdAt,
    required bool favorite,
  }) : super._(
         id: id,
         title: title,
         authorName: authorName,
         status: status,
         shelfId: shelfId,
         createdAt: createdAt,
         favorite: favorite,
       );

  /// Returns a shallow copy of this [BookDto]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  BookDto copyWith({
    _isc.UuidValue? id,
    String? title,
    String? authorName,
    _ifap2468.ReadingStatusWire? status,
    Object? shelfId = _Undefined,
    DateTime? createdAt,
    bool? favorite,
  }) {
    return BookDto(
      id: id ?? this.id,
      title: title ?? this.title,
      authorName: authorName ?? this.authorName,
      status: status ?? this.status,
      shelfId: shelfId is _isc.UuidValue? ? shelfId : this.shelfId,
      createdAt: createdAt ?? this.createdAt,
      favorite: favorite ?? this.favorite,
    );
  }
}
