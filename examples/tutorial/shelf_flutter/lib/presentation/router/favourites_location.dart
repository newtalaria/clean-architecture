import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:shelf_flutter/presentation/features/favourites/favourites_page.dart';
import 'package:shelf_flutter/presentation/router/books_location.dart';
import 'package:shelf_flutter/presentation/router/route_paths.dart';

class FavouritesLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => [RoutePaths.favourites];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('favourites'),
        title: 'Favourites',
        child: ScreenReporter(
          path: RoutePaths.favourites,
          title: 'Favourites',
          child: FavouritesPage(),
        ),
      ),
    ];
  }
}
