// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'reading_status.dart';

class ReadingStatusMapper extends EnumMapper<ReadingStatus> {
  ReadingStatusMapper._();

  static ReadingStatusMapper? _instance;
  static ReadingStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = ReadingStatusMapper._());
    }
    return _instance!;
  }

  static ReadingStatus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  ReadingStatus decode(dynamic value) {
    switch (value) {
      case r'unread':
        return ReadingStatus.unread;
      case r'reading':
        return ReadingStatus.reading;
      case r'read':
        return ReadingStatus.read;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(ReadingStatus self) {
    switch (self) {
      case ReadingStatus.unread:
        return r'unread';
      case ReadingStatus.reading:
        return r'reading';
      case ReadingStatus.read:
        return r'read';
    }
  }
}

extension ReadingStatusMapperExtension on ReadingStatus {
  String toValue() {
    ReadingStatusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<ReadingStatus>(this) as String;
  }
}

