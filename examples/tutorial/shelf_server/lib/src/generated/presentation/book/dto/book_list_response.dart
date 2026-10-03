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
import 'package:shelf_server/src/generated/protocol.dart' as _i20gy4kc;
import '../../../presentation/book/dto/book_dto.dart' as _ikwdrz8e;

abstract class BookListResponse
    implements _is.SerializableModel, _is.ProtocolSerialization {
  BookListResponse._({required this.books});

  factory BookListResponse({required List<_ikwdrz8e.BookDto> books}) =
      _BookListResponseImpl;

  factory BookListResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return BookListResponse(
      books: _i20gy4kc.Protocol().deserialize<List<_ikwdrz8e.BookDto>>(
        jsonSerialization['books'],
      ),
    );
  }

  List<_ikwdrz8e.BookDto> books;

  /// Returns a shallow copy of this [BookListResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  BookListResponse copyWith({List<_ikwdrz8e.BookDto>? books});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'BookListResponse',
      'books': books.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'BookListResponse',
      'books': books.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _BookListResponseImpl extends BookListResponse {
  _BookListResponseImpl({required List<_ikwdrz8e.BookDto> books})
    : super._(books: books);

  /// Returns a shallow copy of this [BookListResponse]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  BookListResponse copyWith({List<_ikwdrz8e.BookDto>? books}) {
    return BookListResponse(
      books: books ?? this.books.map((e0) => e0.copyWith()).toList(),
    );
  }
}
