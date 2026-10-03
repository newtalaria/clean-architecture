import 'package:serverpod/serverpod.dart' as sp;
import 'package:serverpod_cloud_storage/serverpod_cloud_storage.dart';
import 'package:talaria_serverpod/talaria_serverpod.dart';

import 'src/bootstrap/talaria_monitoring.dart';
import 'src/cache_busting.dart';
import 'src/generated/serverpod.dart';
import 'src/web/routes/root.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod. The generated Serverpod class is already connected
  // with your project's generated code.
  final pod = Serverpod(
    args,
    databaseInterceptor: TalariaServerpod.interceptDatabase,
    experimentalFeatures: sp.ExperimentalFeatures(
      diagnosticEventHandlers: [
        sp.AsEventHandler<sp.ExceptionEvent>((
          event, {
          required space,
          required context,
        }) {
          TalariaServerpod.handleExceptionEvent(event, context: context);
        }),
      ],
    ),
  );

  // Setup a default page at the web root.
  // These are used by the default page.
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');

  // Serve all files in the web/static relative directory under /web.
  // These are used by the default web page.
  pod.webServer.addRoute(
    StaticRoute.withCacheBusting(cacheBustingConfig),
    cacheBustingConfig.mountPrefix,
  );

  // Configure cloud storage.
  // This setup works with Serverpod Cloud without extra configuration.
  // If you want to use a custom provider for cloud storage, replace these
  // with your preferred provider.
  pod.addCloudStorage(
    await ServerpodCloudProvider.private(
      fallback: () => DatabaseCloudStorage('private'),
    ),
  );
  pod.addCloudStorage(
    await ServerpodCloudProvider.public(
      fallback: () => DatabaseCloudStorage('public'),
    ),
  );

  await initTalaria();
  TalariaServerpod.attach(pod);

  // Start the server.
  await pod.start();
}
