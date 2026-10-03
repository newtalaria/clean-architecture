import 'package:flutter_test/flutter_test.dart';

import 'package:notes_flutter_hybrid/presentation/router/notes_location.dart';
import 'package:notes_flutter_hybrid/presentation/router/route_paths.dart';
import 'package:notes_flutter_hybrid/bootstrap/talaria_monitoring.dart';

void main() {
  test('an empty key skips init', () {
    expect(NotesMonitoring.shouldInit(''), isFalse);
    expect(NotesMonitoring.shouldInit('   '), isFalse);
    expect(NotesMonitoring.shouldInit('tal_live_x'), isTrue);
  });

  test('screen and user calls are quiet without a client', () {
    NotesMonitoring.setScreen(RoutePaths.notes, title: 'Notes');
    NotesMonitoring.setSignedInUser(userId: 'user-1');
    NotesMonitoring.clearSignedInUser();
  });

  test('the notes location owns the notes path', () {
    expect(RoutePaths.notes, '/notes');
    expect(NotesLocation().pathPatterns, [RoutePaths.notes]);
  });
}
