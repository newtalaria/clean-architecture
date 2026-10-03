import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:notes_flutter_layer_first/presentation/notes/notes_page.dart';

void main() {
  testWidgets('saves a note and shows the tile', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: NotesPage())),
    );
    await tester.pumpAndSettle();
    expect(find.text('No notes yet'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('note-title')), 'Market');
    await tester.enterText(find.byKey(const Key('note-body')), 'Oat milk');
    await tester.tap(find.byKey(const Key('save-note')));
    await tester.pumpAndSettle();

    expect(find.text('Market'), findsWidgets);
    expect(find.text('Oat milk'), findsOneWidget);
    expect(find.text('No notes yet'), findsNothing);
  });

  testWidgets('a blank title stays on the form', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: NotesPage())),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('note-body')), 'Oat milk');
    await tester.tap(find.byKey(const Key('save-note')));
    await tester.pumpAndSettle();

    expect(find.text('Title is required'), findsOneWidget);
    expect(find.text('No notes yet'), findsOneWidget);
  });
}
