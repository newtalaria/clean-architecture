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
import '../../../presentation/book/reading_status_wire.dart' as _ifap2468;

abstract class SaveBookInput
    implements _is.SerializableModel, _is.ProtocolSerialization {
  SaveBookInput._({
    required this.title,
    required this.authorName,
    required this.status,
  });

  factory SaveBookInput({
    required String title,
    required String authorName,
    required _ifap2468.ReadingStatusWire status,
  }) = _SaveBookInputImpl;

  factory SaveBookInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return SaveBookInput(
      title: jsonSerialization['title'] as String,
      authorName: jsonSerialization['authorName'] as String,
      status: _ifap2468.ReadingStatusWire.fromJson(
        (jsonSerialization['status'] as String),
      ),
    );
  }

  String title;

  String authorName;

  _ifap2468.ReadingStatusWire status;

  /// Returns a shallow copy of this [SaveBookInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SaveBookInput copyWith({
    String? title,
    String? authorName,
    _ifap2468.ReadingStatusWire? status,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SaveBookInput',
      'title': title,
      'authorName': authorName,
      'status': status.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SaveBookInput',
      'title': title,
      'authorName': authorName,
      'status': status.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _SaveBookInputImpl extends SaveBookInput {
  _SaveBookInputImpl({
    required String title,
    required String authorName,
    required _ifap2468.ReadingStatusWire status,
  }) : super._(
         title: title,
         authorName: authorName,
         status: status,
       );

  /// Returns a shallow copy of this [SaveBookInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SaveBookInput copyWith({
    String? title,
    String? authorName,
    _ifap2468.ReadingStatusWire? status,
  }) {
    return SaveBookInput(
      title: title ?? this.title,
      authorName: authorName ?? this.authorName,
      status: status ?? this.status,
    );
  }
}
