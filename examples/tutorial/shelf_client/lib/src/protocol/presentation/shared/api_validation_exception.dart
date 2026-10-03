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

abstract class ApiValidationException
    implements
        _isc.SerializableException,
        _isc.SerializableModel,
        _isc.ProtocolSerialization {
  ApiValidationException._({required this.message});

  factory ApiValidationException({required String message}) =
      _ApiValidationExceptionImpl;

  factory ApiValidationException.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return ApiValidationException(
      message: jsonSerialization['message'] as String,
    );
  }

  String message;

  /// Returns a shallow copy of this [ApiValidationException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ApiValidationException copyWith({String? message});
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ApiValidationException',
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ApiValidationException',
      'message': message,
    };
  }

  @override
  String toString() {
    return 'ApiValidationException(message: $message)';
  }
}

class _ApiValidationExceptionImpl extends ApiValidationException {
  _ApiValidationExceptionImpl({required String message})
    : super._(message: message);

  /// Returns a shallow copy of this [ApiValidationException]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ApiValidationException copyWith({String? message}) {
    return ApiValidationException(message: message ?? this.message);
  }
}
