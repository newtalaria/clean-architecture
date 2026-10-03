import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:talaria_flutter/talaria_flutter.dart';

import 'package:notes_flutter_hybrid/presentation/router/notes_location.dart';
import 'package:notes_flutter_hybrid/presentation/router/route_paths.dart';

class NotesApp extends StatefulWidget {
  const NotesApp({super.key});

  @override
  State<NotesApp> createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  late final BeamerDelegate _router = BeamerDelegate(
    initialPath: RoutePaths.notes,
    locationBuilder: BeamerLocationBuilder(
      beamLocations: [NotesLocation()],
    ).call,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Notes',
      routerDelegate: _router,
      routeInformationParser: BeamerParser(),
      backButtonDispatcher: BeamerBackButtonDispatcher(delegate: _router),
      builder: (context, child) {
        return TalariaScreenCapture(child: child ?? const SizedBox.shrink());
      },
    );
  }
}
