import 'package:beamer/beamer.dart';
import 'package:flutter/widgets.dart';

import 'package:notes_flutter_hybrid/presentation/features/notes/notes_page.dart';
import 'package:notes_flutter_hybrid/presentation/router/route_paths.dart';
import 'package:notes_flutter_hybrid/bootstrap/talaria_monitoring.dart';

class NotesLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathPatterns => [RoutePaths.notes];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      const BeamPage(
        key: ValueKey('notes'),
        title: 'Notes',
        child: ScreenReporter(
          path: RoutePaths.notes,
          title: 'Notes',
          child: NotesPage(),
        ),
      ),
    ];
  }
}

/// Beamer is the router adapter. Building the notes location reports the screen.
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
    NotesMonitoring.setScreen(widget.path, title: widget.title);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
