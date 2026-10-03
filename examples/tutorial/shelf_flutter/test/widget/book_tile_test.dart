import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_flutter/ui/book_tile.dart';

void main() {
  testWidgets('renders without a provider scope', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: BookTile(
            title: 'The Dispossessed',
            authorName: 'Le Guin',
            status: 'unread',
          ),
        ),
      ),
    );
    expect(find.text('The Dispossessed'), findsOneWidget);
    expect(find.text('Le Guin · unread'), findsOneWidget);
  });
}
