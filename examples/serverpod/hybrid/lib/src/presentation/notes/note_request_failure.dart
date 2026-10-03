class NoteRequestFailure implements Exception {
  const NoteRequestFailure(this.status, this.message);

  final int status;
  final String message;

  @override
  String toString() => '$status $message';
}
