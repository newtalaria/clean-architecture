import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:talaria_flutter/talaria_flutter.dart';
import 'package:shelf_flutter/presentation/router/books_location.dart';
import 'package:shelf_flutter/presentation/router/favourites_location.dart';
import 'package:shelf_flutter/presentation/router/route_paths.dart';
import 'package:shelf_flutter/presentation/router/shelves_location.dart';
import 'package:shelf_flutter/ui/shelf_theme.dart';

class ShelfApp extends StatefulWidget {
  const ShelfApp({super.key});

  @override
  State<ShelfApp> createState() => _ShelfAppState();
}

class _ShelfAppState extends State<ShelfApp> {
  late final BeamerDelegate _router = BeamerDelegate(
    initialPath: RoutePaths.books,
    locationBuilder: BeamerLocationBuilder(
      beamLocations: [BooksLocation(), ShelvesLocation(), FavouritesLocation()],
    ).call,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Shelf',
      theme: shelfTheme(),
      routerDelegate: _router,
      routeInformationParser: BeamerParser(),
      backButtonDispatcher: BeamerBackButtonDispatcher(delegate: _router),
      builder: (context, child) {
        return TalariaScreenCapture(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
