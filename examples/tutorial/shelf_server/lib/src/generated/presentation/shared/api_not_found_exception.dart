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

abstract class ApiNotFoundException
    implements
        _is.SerializableException,
        _is.SerializableModel,
        _is.ProtocolSerialization {
  ApiNotFoundException._({required this.message});

  factory ApiNotFoundException({required String message}) =
      _ApiNotFoundExceptionImpl;

  factory ApiNotFoundException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ApiNotFoundException(
      message: jsonSerialization['message'] as String,
    );
  }

  String message;

  /// Returns a shallow copy of this [ApiNotFoundException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ApiNotFoundException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ApiNotFoundException',
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ApiNotFoundException',
      'message': message,
    };
  }

  @override
  String toString() {
    return 'ApiNotFoundException(message: $message)';
  }
}

class _ApiNotFoundExceptionImpl extends ApiNotFoundException {
  _ApiNotFoundExceptionImpl({required String message})
    : super._(message: message);

  /// Returns a shallow copy of this [ApiNotFoundException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ApiNotFoundException copyWith({String? message}) {
    return ApiNotFoundException(message: message ?? this.message);
  }
}
