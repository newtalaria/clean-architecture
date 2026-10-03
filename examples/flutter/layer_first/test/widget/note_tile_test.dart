import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:notes_flutter_layer_first/presentation/notes/note_tile.dart';

void main() {
  testWidgets('renders without a provider scope', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: NoteTile(title: 'Market', body: 'Oat milk')),
      ),
    );
    expect(find.text('Market'), findsOneWidget);
    expect(find.text('Oat milk'), findsOneWidget);
  });
}
