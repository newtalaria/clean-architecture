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
import 'package:shelf_client/src/protocol/protocol.dart' as _il5jmerh;
import '../../../presentation/shelf/dto/shelf_dto.dart' as _i7a67gqz;

abstract class ShelfListResponse
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ShelfListResponse._({required this.shelves});

  factory ShelfListResponse({required List<_i7a67gqz.ShelfDto> shelves}) =
      _ShelfListResponseImpl;

  factory ShelfListResponse.fromJson(Map<String, dynamic> jsonSerialization) {
    return ShelfListResponse(
      shelves: _il5jmerh.Protocol().deserialize<List<_i7a67gqz.ShelfDto>>(
        jsonSerialization['shelves'],
      ),
    );
  }

  List<_i7a67gqz.ShelfDto> shelves;

  /// Returns a shallow copy of this [ShelfListResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ShelfListResponse copyWith({List<_i7a67gqz.ShelfDto>? shelves});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShelfListResponse',
      'shelves': shelves.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShelfListResponse',
      'shelves': shelves.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ShelfListResponseImpl extends ShelfListResponse {
  _ShelfListResponseImpl({required List<_i7a67gqz.ShelfDto> shelves})
    : super._(shelves: shelves);

  /// Returns a shallow copy of this [ShelfListResponse]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ShelfListResponse copyWith({List<_i7a67gqz.ShelfDto>? shelves}) {
    return ShelfListResponse(
      shelves: shelves ?? this.shelves.map((e0) => e0.copyWith()).toList(),
    );
  }
}
