// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'book.dart';

class BookMapper extends ClassMapperBase<Book> {
  BookMapper._();

  static BookMapper? _instance;
  static BookMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = BookMapper._());
      ReadingStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'Book';

  static String _$id(Book v) => v.id;
  static const Field<Book, String> _f$id = Field('id', _$id);
  static String _$title(Book v) => v.title;
  static const Field<Book, String> _f$title = Field('title', _$title);
  static String _$authorName(Book v) => v.authorName;
  static const Field<Book, String> _f$authorName = Field(
    'authorName',
    _$authorName,
  );
  static ReadingStatus _$status(Book v) => v.status;
  static const Field<Book, ReadingStatus> _f$status = Field('status', _$status);
  static DateTime _$createdAt(Book v) => v.createdAt;
  static const Field<Book, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static String? _$shelfId(Book v) => v.shelfId;
  static const Field<Book, String> _f$shelfId = Field(
    'shelfId',
    _$shelfId,
    opt: true,
  );

  @override
  final MappableFields<Book> fields = const {
    #id: _f$id,
    #title: _f$title,
    #authorName: _f$authorName,
    #status: _f$status,
    #createdAt: _f$createdAt,
    #shelfId: _f$shelfId,
  };

  static Book _instantiate(DecodingData data) {
    return Book(
      id: data.dec(_f$id),
      title: data.dec(_f$title),
      authorName: data.dec(_f$authorName),
      status: data.dec(_f$status),
      createdAt: data.dec(_f$createdAt),
      shelfId: data.dec(_f$shelfId),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Book fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Book>(map);
  }

  static Book fromJson(String json) {
    return ensureInitialized().decodeJson<Book>(json);
  }
}

mixin BookMappable {
  String toJson() {
    return BookMapper.ensureInitialized().encodeJson<Book>(this as Book);
  }

  Map<String, dynamic> toMap() {
    return BookMapper.ensureInitialized().encodeMap<Book>(this as Book);
  }

  BookCopyWith<Book, Book, Book> get copyWith =>
      _BookCopyWithImpl<Book, Book>(this as Book, $identity, $identity);
  @override
  String toString() {
    return BookMapper.ensureInitialized().stringifyValue(this as Book);
  }

  @override
  bool operator ==(Object other) {
    return BookMapper.ensureInitialized().equalsValue(this as Book, other);
  }

  @override
  int get hashCode {
    return BookMapper.ensureInitialized().hashValue(this as Book);
  }
}

extension BookValueCopy<$R, $Out> on ObjectCopyWith<$R, Book, $Out> {
  BookCopyWith<$R, Book, $Out> get $asBook =>
      $base.as((v, t, t2) => _BookCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class BookCopyWith<$R, $In extends Book, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? title,
    String? authorName,
    ReadingStatus? status,
    DateTime? createdAt,
    String? shelfId,
  });
  BookCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _BookCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Book, $Out>
    implements BookCopyWith<$R, Book, $Out> {
  _BookCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Book> $mapper = BookMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? title,
    String? authorName,
    ReadingStatus? status,
    DateTime? createdAt,
    Object? shelfId = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (title != null) #title: title,
      if (authorName != null) #authorName: authorName,
      if (status != null) #status: status,
      if (createdAt != null) #createdAt: createdAt,
      if (shelfId != $none) #shelfId: shelfId,
    }),
  );
  @override
  Book $make(CopyWithData data) => Book(
    id: data.get(#id, or: $value.id),
    title: data.get(#title, or: $value.title),
    authorName: data.get(#authorName, or: $value.authorName),
    status: data.get(#status, or: $value.status),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    shelfId: data.get(#shelfId, or: $value.shelfId),
  );

  @override
  BookCopyWith<$R2, Book, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _BookCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

