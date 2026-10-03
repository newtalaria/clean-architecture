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

abstract class SaveShelfInput
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SaveShelfInput._({
    required this.name,
    required this.capacity,
  });

  factory SaveShelfInput({
    required String name,
    required int capacity,
  }) = _SaveShelfInputImpl;

  factory SaveShelfInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return SaveShelfInput(
      name: jsonSerialization['name'] as String,
      capacity: jsonSerialization['capacity'] as int,
    );
  }

  String name;

  int capacity;

  /// Returns a shallow copy of this [SaveShelfInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SaveShelfInput copyWith({
    String? name,
    int? capacity,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SaveShelfInput',
      'name': name,
      'capacity': capacity,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SaveShelfInput',
      'name': name,
      'capacity': capacity,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SaveShelfInputImpl extends SaveShelfInput {
  _SaveShelfInputImpl({
    required String name,
    required int capacity,
  }) : super._(
         name: name,
         capacity: capacity,
       );

  /// Returns a shallow copy of this [SaveShelfInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SaveShelfInput copyWith({
    String? name,
    int? capacity,
  }) {
    return SaveShelfInput(
      name: name ?? this.name,
      capacity: capacity ?? this.capacity,
    );
  }
}
