import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:shelf_client/shelf_client.dart';
import 'package:shelf_flutter/app/providers.dart';
import 'package:shelf_flutter/bootstrap/talaria_monitoring.dart';
import 'package:shelf_flutter/shelf_app.dart';

const shelfApiUrl = String.fromEnvironment(
  'SHELF_API_URL',
  defaultValue: 'http://localhost:8280/',
);

Future<void> main() {
  return ShelfMonitoring.bootstrap(() async {
    final client = Client(
      shelfApiUrl,
      httpClientOverride: ShelfMonitoring.shouldInit(ShelfMonitoring.apiKey)
          ? ShelfMonitoring.httpClient()
          : http.Client(),
    )..connectivityMonitor = FlutterConnectivityMonitor();

    runApp(
      ProviderScope(
        overrides: [clientProvider.overrideWithValue(client)],
        child: const ShelfApp(),
      ),
    );
  });
}
