/// Input to [SaveShelfUseCase]. Plain Dart. Not a spy type.
class SaveShelfCommand {
  const SaveShelfCommand({required this.name, required this.capacity});

  final String name;
  final int capacity;
}
