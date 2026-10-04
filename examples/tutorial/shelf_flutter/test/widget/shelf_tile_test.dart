import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_flutter/ui/shelf_tile.dart';

void main() {
  testWidgets('renders without a provider scope', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(body: ShelfTile(name: 'Fiction', capacity: 10)),
      ),
    );
    expect(find.text('Fiction'), findsOneWidget);
    expect(find.text('Capacity 10'), findsOneWidget);
  });
}
