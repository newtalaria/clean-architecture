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
import 'dart:async' as _ida;
import 'package:http/http.dart' as _i85jenna;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:shelf_client/src/protocol/presentation/book/dto/book_dto.dart'
    as _ia8p4gki;
import 'package:shelf_client/src/protocol/presentation/book/dto/book_list_response.dart'
    as _itmrzk02;
import 'package:shelf_client/src/protocol/presentation/book/input/save_book_input.dart'
    as _ive2x8b9;
import 'package:shelf_client/src/protocol/presentation/book/input/set_book_favorite_input.dart'
    as _i4gr0na4;
import 'package:shelf_client/src/protocol/presentation/shelf/dto/shelf_dto.dart'
    as _ic3t7k1z;
import 'package:shelf_client/src/protocol/presentation/shelf/dto/shelf_list_response.dart'
    as _ihzdrv3c;
import 'package:shelf_client/src/protocol/presentation/shelf/input/place_book_input.dart'
    as _ilm81zam;
import 'package:shelf_client/src/protocol/presentation/shelf/input/save_shelf_input.dart'
    as _irwzruv4;
import 'protocol.dart' as _il2as5qe;

/// Thin edge. Auth, mapping, one use case, mapping back.
/// {@category Endpoint}
class EndpointBook extends _isc.EndpointRef {
  EndpointBook(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'book';

  _ida.Future<_ia8p4gki.BookDto> save(_ive2x8b9.SaveBookInput input) =>
      caller.callServerEndpoint<_ia8p4gki.BookDto>(
        'book',
        'save',
        {'input': input},
      );

  _ida.Future<_ia8p4gki.BookDto> setFavorite(
    _i4gr0na4.SetBookFavoriteInput input,
  ) => caller.callServerEndpoint<_ia8p4gki.BookDto>(
    'book',
    'setFavorite',
    {'input': input},
  );

  _ida.Future<_itmrzk02.BookListResponse> list() =>
      caller.callServerEndpoint<_itmrzk02.BookListResponse>(
        'book',
        'list',
        {},
      );
}

/// {@category Endpoint}
class EndpointShelf extends _isc.EndpointRef {
  EndpointShelf(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'shelf';

  _ida.Future<_ic3t7k1z.ShelfDto> save(_irwzruv4.SaveShelfInput input) =>
      caller.callServerEndpoint<_ic3t7k1z.ShelfDto>(
        'shelf',
        'save',
        {'input': input},
      );

  _ida.Future<_ihzdrv3c.ShelfListResponse> list() =>
      caller.callServerEndpoint<_ihzdrv3c.ShelfListResponse>(
        'shelf',
        'list',
        {},
      );

  /// Returns the book wire type. The shelf feature borrows the book mapper.
  _ida.Future<_ia8p4gki.BookDto> place(_ilm81zam.PlaceBookInput input) =>
      caller.callServerEndpoint<_ia8p4gki.BookDto>(
        'shelf',
        'place',
        {'input': input},
      );
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    book = EndpointBook(this);
    shelf = EndpointShelf(this);
  }

  late final EndpointBook book;

  late final EndpointShelf shelf;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'book': book,
    'shelf': shelf,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {};
}
