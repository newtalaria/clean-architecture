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

abstract class PlaceBookInput
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  PlaceBookInput._({
    required this.bookId,
    required this.shelfId,
  });

  factory PlaceBookInput({
    required _isc.UuidValue bookId,
    required _isc.UuidValue shelfId,
  }) = _PlaceBookInputImpl;

  factory PlaceBookInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlaceBookInput(
      bookId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['bookId']),
      shelfId: _isc.UuidValueJsonExtension.fromJson(
        jsonSerialization['shelfId'],
      ),
    );
  }

  _isc.UuidValue bookId;

  _isc.UuidValue shelfId;

  /// Returns a shallow copy of this [PlaceBookInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  PlaceBookInput copyWith({
    _isc.UuidValue? bookId,
    _isc.UuidValue? shelfId,
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
    return _isc.SerializationManager.encode(this);
  }
}

class _PlaceBookInputImpl extends PlaceBookInput {
  _PlaceBookInputImpl({
    required _isc.UuidValue bookId,
    required _isc.UuidValue shelfId,
  }) : super._(
         bookId: bookId,
         shelfId: shelfId,
       );

  /// Returns a shallow copy of this [PlaceBookInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  PlaceBookInput copyWith({
    _isc.UuidValue? bookId,
    _isc.UuidValue? shelfId,
  }) {
    return PlaceBookInput(
      bookId: bookId ?? this.bookId,
      shelfId: shelfId ?? this.shelfId,
    );
  }
}
