import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';
import 'package:shelf_flutter/bootstrap/talaria_monitoring.dart';
import 'package:shelf_flutter/presentation/features/books/books_page.dart';
import 'package:shelf_flutter/presentation/router/route_paths.dart';

class BooksLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => [RoutePaths.books];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('books'),
        title: 'Books',
        child: ScreenReporter(
          path: RoutePaths.books,
          title: 'Books',
          child: BooksPage(),
        ),
      ),
    ];
  }
}

class ScreenReporter extends StatefulWidget {
  const ScreenReporter({
    super.key,
    required this.path,
    required this.child,
    this.title,
  });

  final String path;
  final String? title;
  final Widget child;

  @override
  State<ScreenReporter> createState() => _ScreenReporterState();
}

class _ScreenReporterState extends State<ScreenReporter> {
  @override
  void initState() {
    super.initState();
    ShelfMonitoring.setScreen(widget.path, title: widget.title);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
