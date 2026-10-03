import 'package:shelf_server/src/domain/shared/exceptions/conflict.dart';
import 'package:shelf_server/src/domain/shared/exceptions/not_found.dart';
import 'package:shelf_server/src/domain/shared/exceptions/validation_failure.dart';
import 'package:shelf_server/src/generated/protocol.dart';

/// Maps domain failures to the spy exceptions the client can catch.
Future<T> runUseCase<T>(Future<T> Function() action) async {
  try {
    return await action();
  } on ValidationFailure catch (error) {
    throw ApiValidationException(message: error.message);
  } on NotFound catch (error) {
    throw ApiNotFoundException(message: error.message);
  } on Conflict catch (error) {
    throw ApiConflictException(message: error.message);
  }
}
