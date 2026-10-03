import 'package:flutter_test/flutter_test.dart';
import 'package:shelf_flutter/bootstrap/talaria_monitoring.dart';
import 'package:shelf_flutter/presentation/router/books_location.dart';
import 'package:shelf_flutter/presentation/router/route_paths.dart';

void main() {
  test('an empty key skips init', () {
    expect(ShelfMonitoring.shouldInit(''), isFalse);
    expect(ShelfMonitoring.shouldInit('   '), isFalse);
    expect(ShelfMonitoring.shouldInit('tal_live_x'), isTrue);
  });

  test('screen and user calls are quiet without a client', () {
    ShelfMonitoring.setScreen(RoutePaths.books, title: 'Books');
    ShelfMonitoring.setSignedInUser(userId: 'user-1', name: 'Ada');
    ShelfMonitoring.clearSignedInUser();
  });

  test('the books location owns the books path', () {
    expect(RoutePaths.books, '/books');
    expect(BooksLocation().pathPatterns, [RoutePaths.books]);
  });
}
