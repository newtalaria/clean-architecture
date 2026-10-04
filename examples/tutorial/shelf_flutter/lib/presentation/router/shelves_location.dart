import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:shelf_flutter/presentation/features/shelves/shelf_page.dart';
import 'package:shelf_flutter/presentation/features/shelves/shelves_page.dart';
import 'package:shelf_flutter/presentation/router/books_location.dart';
import 'package:shelf_flutter/presentation/router/route_paths.dart';

class ShelvesLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => [
    RoutePaths.shelfPattern,
    RoutePaths.shelves,
  ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final pages = <BeamPage>[
      const BeamPage(
        key: ValueKey('shelves'),
        title: 'Shelves',
        child: ScreenReporter(
          path: RoutePaths.shelves,
          title: 'Shelves',
          child: ShelvesPage(),
        ),
      ),
    ];
    final id = state.pathParameters['shelfId'];
    if (id != null) {
      pages.add(
        BeamPage(
          key: ValueKey('shelf-$id'),
          title: 'Shelf',
          child: ScreenReporter(
            path: RoutePaths.shelf(id),
            title: 'Shelf',
            child: ShelfPage(shelfId: id),
          ),
        ),
      );
    }
    return pages;
  }
}
