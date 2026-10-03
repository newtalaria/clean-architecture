import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notes_flutter_layer_first/app/providers.dart';
import 'package:notes_flutter_layer_first/bootstrap/talaria_monitoring.dart';
import 'package:notes_flutter_layer_first/notes_app.dart';

Future<void> main() {
  return NotesMonitoring.bootstrap(() async {
    runApp(
      ProviderScope(
        overrides: [
          notesHttpClientProvider.overrideWithValue(
            NotesMonitoring.httpClient(),
          ),
        ],
        child: const NotesApp(),
      ),
    );
  });
}
