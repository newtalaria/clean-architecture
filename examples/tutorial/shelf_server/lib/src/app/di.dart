import 'repositories.dart';
import 'use_cases.dart';

/// Process-wide wiring. Repositories are still built per session inside [UseCases].
class AppDi {
  AppDi._() : useCases = const UseCases(Repositories());

  static final instance = AppDi._();

  final UseCases useCases;
}
