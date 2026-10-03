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

abstract class PlaceBookInput
    implements _is.SerializableModel, _is.ProtocolSerialization {
  PlaceBookInput._({
    required this.bookId,
    required this.shelfId,
  });

  factory PlaceBookInput({
    required _is.UuidValue bookId,
    required _is.UuidValue shelfId,
  }) = _PlaceBookInputImpl;

  factory PlaceBookInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlaceBookInput(
      bookId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['bookId']),
      shelfId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['shelfId'],
      ),
    );
  }

  _is.UuidValue bookId;

  _is.UuidValue shelfId;

  /// Returns a shallow copy of this [PlaceBookInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PlaceBookInput copyWith({
    _is.UuidValue? bookId,
    _is.UuidValue? shelfId,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlaceBookInput',
      'bookId': bookId.toJson(),
      'shelfId': shelfId.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PlaceBookInput',
      'bookId': bookId.toJson(),
      'shelfId': shelfId.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _PlaceBookInputImpl extends PlaceBookInput {
  _PlaceBookInputImpl({
    required _is.UuidValue bookId,
    required _is.UuidValue shelfId,
  }) : super._(
         bookId: bookId,
         shelfId: shelfId,
       );

  /// Returns a shallow copy of this [PlaceBookInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PlaceBookInput copyWith({
    _is.UuidValue? bookId,
    _is.UuidValue? shelfId,
  }) {
    return PlaceBookInput(
      bookId: bookId ?? this.bookId,
      shelfId: shelfId ?? this.shelfId,
    );
  }
}
