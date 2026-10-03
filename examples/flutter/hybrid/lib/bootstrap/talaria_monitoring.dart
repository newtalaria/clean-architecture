import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:talaria_flutter/talaria_flutter.dart';

/// Optional instrumentation. An empty `TALARIA_API_KEY` leaves the SDK off.
///
/// [bootstrap] keeps [WidgetsFlutterBinding.ensureInitialized] and `runApp`
/// in one zone. Flutter reports a zone mismatch when the binding is created
/// outside the zone that later calls `runApp`.
class NotesMonitoring {
  NotesMonitoring._();

  static const dsn = 'https://ingest.newtalaria.com';
  static const apiKey = String.fromEnvironment('TALARIA_API_KEY');
  static const release = String.fromEnvironment(
    'TALARIA_RELEASE',
    defaultValue: 'dev',
  );

  static String? _identifiedUserId;
  static String? _lastScreenPath;
  static String? _lastScreenTitle;

  static bool shouldInit(String key) => key.trim().isNotEmpty;

  static TalariaOptions options({String? key}) {
    return TalariaOptions(
      dsn: dsn,
      apiKey: (key ?? apiKey).trim(),
      release: release,
      minLevel: SeverityLevel.warning,
      tags: const {'service': 'notes'},
    );
  }

  static Future<bool> init({String? key}) async {
    final resolved = (key ?? apiKey).trim();
    if (!shouldInit(resolved)) return false;
    await TalariaFlutter.init(options(key: resolved));
    ErrorWidget.builder = talariaErrorWidgetBuilder();
    return true;
  }

  static Future<void> bootstrap(Future<void> Function() startApp) {
    if (!shouldInit(apiKey)) {
      WidgetsFlutterBinding.ensureInitialized();
      return startApp();
    }

    final started = Completer<void>();
    runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        await init();
        await startApp();
        if (!started.isCompleted) started.complete();
      },
      (Object error, StackTrace stack) {
        final client = Talaria.getClient();
        if (client != null) {
          // ignore: discarded_futures
          client.captureException(
            error,
            stackTrace: stack,
            context: const CaptureContext(
              mechanism: ExceptionMechanism(type: 'zone', handled: false),
            ),
          );
        }
        if (!started.isCompleted) started.completeError(error, stack);
      },
    );
    return started.future;
  }

  static http.Client httpClient() {
    final client = http.Client();
    if (!shouldInit(apiKey)) return client;
    return Talaria.wrapHttpClient(client);
  }

  static void setSignedInUser({required String userId, String? name}) {
    if (Talaria.getClient() == null) return;
    Talaria.setUser(userId);
    Talaria.analytics.optIn();
    if (_identifiedUserId == userId) return;
    _identifiedUserId = userId;
    unawaited(
      Talaria.analytics.identify(
        userId,
        traits: {
          if (name != null && name.trim().isNotEmpty) 'name': name.trim(),
        },
      ),
    );
  }

  static void clearSignedInUser() {
    if (Talaria.getClient() == null) return;
    _identifiedUserId = null;
    _lastScreenPath = null;
    _lastScreenTitle = null;
    Talaria.analytics.optOut();
    Talaria.setUser(null);
    unawaited(Talaria.analytics.reset());
  }

  /// Repeats of the same path and title are dropped.
  static void setScreen(String path, {String? title}) {
    final label = path.trim();
    if (label.isEmpty || Talaria.getClient() == null) return;
    final screenTitle = title?.trim();
    final resolvedTitle = (screenTitle == null || screenTitle.isEmpty)
        ? null
        : screenTitle;
    if (_lastScreenPath == label && _lastScreenTitle == resolvedTitle) return;
    _lastScreenPath = label;
    _lastScreenTitle = resolvedTitle;
    TalariaFlutter.setScreen(label, title: resolvedTitle);
  }
}
