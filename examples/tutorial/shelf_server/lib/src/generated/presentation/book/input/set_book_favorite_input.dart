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

abstract class SetBookFavoriteInput
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SetBookFavoriteInput._({
    required this.bookId,
    required this.favorite,
  });

  factory SetBookFavoriteInput({
    required _is.UuidValue bookId,
    required bool favorite,
  }) = _SetBookFavoriteInputImpl;

  factory SetBookFavoriteInput.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SetBookFavoriteInput(
      bookId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['bookId']),
      favorite: _is.BoolJsonExtension.fromJson(jsonSerialization['favorite']),
    );
  }

  _is.UuidValue bookId;

  bool favorite;

  /// Returns a shallow copy of this [SetBookFavoriteInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SetBookFavoriteInput copyWith({
    _is.UuidValue? bookId,
    bool? favorite,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SetBookFavoriteInput',
      'bookId': bookId.toJson(),
      'favorite': favorite,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SetBookFavoriteInput',
      'bookId': bookId.toJson(),
      'favorite': favorite,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SetBookFavoriteInputImpl extends SetBookFavoriteInput {
  _SetBookFavoriteInputImpl({
    required _is.UuidValue bookId,
    required bool favorite,
  }) : super._(
         bookId: bookId,
         favorite: favorite,
       );

  /// Returns a shallow copy of this [SetBookFavoriteInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SetBookFavoriteInput copyWith({
    _is.UuidValue? bookId,
    bool? favorite,
  }) {
    return SetBookFavoriteInput(
      bookId: bookId ?? this.bookId,
      favorite: favorite ?? this.favorite,
    );
  }
}
