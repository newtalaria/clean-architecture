/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'presentation/book/dto/book_dto.dart' as _iekaty6a;
import 'presentation/book/dto/book_list_response.dart' as _i8f4vu3k;
import 'presentation/book/input/save_book_input.dart' as _iddub8hi;
import 'presentation/book/reading_status_wire.dart' as _itly07lq;
import 'presentation/shared/api_conflict_exception.dart' as _ixvmdfz9;
import 'presentation/shared/api_not_found_exception.dart' as _idmlder2;
import 'presentation/shared/api_validation_exception.dart' as _iwzngqvy;
import 'presentation/shelf/dto/shelf_dto.dart' as _ifjejtrj;
import 'presentation/shelf/dto/shelf_list_response.dart' as _i4wv964u;
import 'presentation/shelf/input/place_book_input.dart' as _il7puip0;
import 'presentation/shelf/input/save_shelf_input.dart' as _i50l9d0c;
export 'presentation/book/dto/book_dto.dart';
export 'presentation/book/dto/book_list_response.dart';
export 'presentation/book/input/save_book_input.dart';
export 'presentation/book/reading_status_wire.dart';
export 'presentation/shared/api_conflict_exception.dart';
export 'presentation/shared/api_not_found_exception.dart';
export 'presentation/shared/api_validation_exception.dart';
export 'presentation/shelf/dto/shelf_dto.dart';
export 'presentation/shelf/dto/shelf_list_response.dart';
export 'presentation/shelf/input/place_book_input.dart';
export 'presentation/shelf/input/save_shelf_input.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _iekaty6a.BookDto) {
      return _iekaty6a.BookDto.fromJson(data) as T;
    }
    if (t == _i8f4vu3k.BookListResponse) {
      return _i8f4vu3k.BookListResponse.fromJson(data) as T;
    }
    if (t == _iddub8hi.SaveBookInput) {
      return _iddub8hi.SaveBookInput.fromJson(data) as T;
    }
    if (t == _itly07lq.ReadingStatusWire) {
      return _itly07lq.ReadingStatusWire.fromJson(data) as T;
    }
    if (t == _ixvmdfz9.ApiConflictException) {
      return _ixvmdfz9.ApiConflictException.fromJson(data) as T;
    }
    if (t == _idmlder2.ApiNotFoundException) {
      return _idmlder2.ApiNotFoundException.fromJson(data) as T;
    }
    if (t == _iwzngqvy.ApiValidationException) {
      return _iwzngqvy.ApiValidationException.fromJson(data) as T;
    }
    if (t == _ifjejtrj.ShelfDto) {
      return _ifjejtrj.ShelfDto.fromJson(data) as T;
    }
    if (t == _i4wv964u.ShelfListResponse) {
      return _i4wv964u.ShelfListResponse.fromJson(data) as T;
    }
    if (t == _il7puip0.PlaceBookInput) {
      return _il7puip0.PlaceBookInput.fromJson(data) as T;
    }
    if (t == _i50l9d0c.SaveShelfInput) {
      return _i50l9d0c.SaveShelfInput.fromJson(data) as T;
    }
    if (t == _isc.getType<_iekaty6a.BookDto?>()) {
      return (data != null ? _iekaty6a.BookDto.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i8f4vu3k.BookListResponse?>()) {
      return (data != null ? _i8f4vu3k.BookListResponse.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iddub8hi.SaveBookInput?>()) {
      return (data != null ? _iddub8hi.SaveBookInput.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_itly07lq.ReadingStatusWire?>()) {
      return (data != null ? _itly07lq.ReadingStatusWire.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ixvmdfz9.ApiConflictException?>()) {
      return (data != null
              ? _ixvmdfz9.ApiConflictException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_idmlder2.ApiNotFoundException?>()) {
      return (data != null
              ? _idmlder2.ApiNotFoundException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iwzngqvy.ApiValidationException?>()) {
      return (data != null
              ? _iwzngqvy.ApiValidationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ifjejtrj.ShelfDto?>()) {
      return (data != null ? _ifjejtrj.ShelfDto.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i4wv964u.ShelfListResponse?>()) {
      return (data != null ? _i4wv964u.ShelfListResponse.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_il7puip0.PlaceBookInput?>()) {
      return (data != null ? _il7puip0.PlaceBookInput.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i50l9d0c.SaveShelfInput?>()) {
      return (data != null ? _i50l9d0c.SaveShelfInput.fromJson(data) : null)
          as T;
    }
    if (t == List<_iekaty6a.BookDto>) {
      return (data as List)
              .map((e) => deserialize<_iekaty6a.BookDto>(e))
              .toList()
          as T;
    }
    if (t == List<_ifjejtrj.ShelfDto>) {
      return (data as List)
              .map((e) => deserialize<_ifjejtrj.ShelfDto>(e))
              .toList()
          as T;
    }
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _iekaty6a.BookDto => 'BookDto',
      _i8f4vu3k.BookListResponse => 'BookListResponse',
      _iddub8hi.SaveBookInput => 'SaveBookInput',
      _itly07lq.ReadingStatusWire => 'ReadingStatusWire',
      _ixvmdfz9.ApiConflictException => 'ApiConflictException',
      _idmlder2.ApiNotFoundException => 'ApiNotFoundException',
      _iwzngqvy.ApiValidationException => 'ApiValidationException',
      _ifjejtrj.ShelfDto => 'ShelfDto',
      _i4wv964u.ShelfListResponse => 'ShelfListResponse',
      _il7puip0.PlaceBookInput => 'PlaceBookInput',
      _i50l9d0c.SaveShelfInput => 'SaveShelfInput',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('shelf.', '');
    }

    switch (data) {
      case _iekaty6a.BookDto():
        return 'BookDto';
      case _i8f4vu3k.BookListResponse():
        return 'BookListResponse';
      case _iddub8hi.SaveBookInput():
        return 'SaveBookInput';
      case _itly07lq.ReadingStatusWire():
        return 'ReadingStatusWire';
      case _ixvmdfz9.ApiConflictException():
        return 'ApiConflictException';
      case _idmlder2.ApiNotFoundException():
        return 'ApiNotFoundException';
      case _iwzngqvy.ApiValidationException():
        return 'ApiValidationException';
      case _ifjejtrj.ShelfDto():
        return 'ShelfDto';
      case _i4wv964u.ShelfListResponse():
        return 'ShelfListResponse';
      case _il7puip0.PlaceBookInput():
        return 'PlaceBookInput';
      case _i50l9d0c.SaveShelfInput():
        return 'SaveShelfInput';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'BookDto') {
      return deserialize<_iekaty6a.BookDto>(data['data']);
    }
    if (dataClassName == 'BookListResponse') {
      return deserialize<_i8f4vu3k.BookListResponse>(data['data']);
    }
    if (dataClassName == 'SaveBookInput') {
      return deserialize<_iddub8hi.SaveBookInput>(data['data']);
    }
    if (dataClassName == 'ReadingStatusWire') {
      return deserialize<_itly07lq.ReadingStatusWire>(data['data']);
    }
    if (dataClassName == 'ApiConflictException') {
      return deserialize<_ixvmdfz9.ApiConflictException>(data['data']);
    }
    if (dataClassName == 'ApiNotFoundException') {
      return deserialize<_idmlder2.ApiNotFoundException>(data['data']);
    }
    if (dataClassName == 'ApiValidationException') {
      return deserialize<_iwzngqvy.ApiValidationException>(data['data']);
    }
    if (dataClassName == 'ShelfDto') {
      return deserialize<_ifjejtrj.ShelfDto>(data['data']);
    }
    if (dataClassName == 'ShelfListResponse') {
      return deserialize<_i4wv964u.ShelfListResponse>(data['data']);
    }
    if (dataClassName == 'PlaceBookInput') {
      return deserialize<_il7puip0.PlaceBookInput>(data['data']);
    }
    if (dataClassName == 'SaveShelfInput') {
      return deserialize<_i50l9d0c.SaveShelfInput>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  @override
  String getModuleName() => 'shelf';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
