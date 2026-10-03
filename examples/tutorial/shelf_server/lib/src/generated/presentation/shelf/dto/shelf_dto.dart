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
import 'package:serverpod/serverpod.dart' as _is;

abstract class ShelfDto
    implements _is.SerializableModel, _is.ProtocolSerialization {
  ShelfDto._({
    required this.id,
    required this.name,
    required this.capacity,
    required this.createdAt,
  });

  factory ShelfDto({
    required _is.UuidValue id,
    required String name,
    required int capacity,
    required DateTime createdAt,
  }) = _ShelfDtoImpl;

  factory ShelfDto.fromJson(Map<String, dynamic> jsonSerialization) {
    return ShelfDto(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      capacity: jsonSerialization['capacity'] as int,
      createdAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  _is.UuidValue id;

  String name;

  int capacity;

  DateTime createdAt;

  /// Returns a shallow copy of this [ShelfDto]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ShelfDto copyWith({
    _is.UuidValue? id,
    String? name,
    int? capacity,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShelfDto',
      'id': id.toJson(),
      'name': name,
      'capacity': capacity,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShelfDto',
      'id': id.toJson(),
      'name': name,
      'capacity': capacity,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ShelfDtoImpl extends ShelfDto {
  _ShelfDtoImpl({
    required _is.UuidValue id,
    required String name,
    required int capacity,
    required DateTime createdAt,
  }) : super._(
         id: id,
         name: name,
         capacity: capacity,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ShelfDto]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ShelfDto copyWith({
    _is.UuidValue? id,
    String? name,
    int? capacity,
    DateTime? createdAt,
  }) {
    return ShelfDto(
      id: id ?? this.id,
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
