/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:shelf_server/src/generated/presentation/book/input/save_book_input.dart'
    as _i7mvohtk;
import 'package:shelf_server/src/generated/presentation/shelf/input/place_book_input.dart'
    as _iops9rtl;
import 'package:shelf_server/src/generated/presentation/shelf/input/save_shelf_input.dart'
    as _il5dg3rm;
import '../presentation/book/book_endpoint.dart' as _izuwvhsa;
import '../presentation/shelf/shelf_endpoint.dart' as _ig4fksf3;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'book': _izuwvhsa.BookEndpoint()
        ..initialize(
          server,
          'book',
          null,
        ),
      'shelf': _ig4fksf3.ShelfEndpoint()
        ..initialize(
          server,
          'shelf',
          null,
        ),
    };
    connectors['book'] = _is.EndpointConnector(
      name: 'book',
      endpoint: endpoints['book']!,
      methodConnectors: {
        'save': _is.MethodConnector(
          name: 'save',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_i7mvohtk.SaveBookInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['book'] as _izuwvhsa.BookEndpoint).save(
                session,
                params['input'],
              ),
        ),
        'list': _is.MethodConnector(
          name: 'list',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['book'] as _izuwvhsa.BookEndpoint).list(session),
        ),
      },
    );
    connectors['shelf'] = _is.EndpointConnector(
      name: 'shelf',
      endpoint: endpoints['shelf']!,
      methodConnectors: {
        'save': _is.MethodConnector(
          name: 'save',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_il5dg3rm.SaveShelfInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shelf'] as _ig4fksf3.ShelfEndpoint).save(
                session,
                params['input'],
              ),
        ),
        'list': _is.MethodConnector(
          name: 'list',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['shelf'] as _ig4fksf3.ShelfEndpoint).list(session),
        ),
        'place': _is.MethodConnector(
          name: 'place',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_iops9rtl.PlaceBookInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['shelf'] as _ig4fksf3.ShelfEndpoint).place(
                session,
                params['input'],
              ),
        ),
      },
    );
  }
}
