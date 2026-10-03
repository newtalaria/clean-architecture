import 'package:shelf_client/shelf_client.dart';
import 'package:shelf_flutter/data/protocol_mappers.dart';
import 'package:shelf_flutter/domain/shelf/shelf.dart';
import 'package:shelf_flutter/domain/shelf/shelf_repository.dart';

class ServerpodShelfRepository implements ShelfRepository {
  ServerpodShelfRepository(this._client, {ProtocolMappers? mappers})
    : _mappers = mappers ?? const ProtocolMappers();

  final Client _client;
  final ProtocolMappers _mappers;

  @override
  Future<Shelf> save(Shelf shelf) async {
    try {
      final dto = await _client.shelf.save(_mappers.toSaveShelfInput(shelf));
      return _mappers.toShelf(dto);
    } catch (error) {
      _mappers.throwDomain(error);
    }
  }

  @override
  Future<List<Shelf>> list() async {
    final response = await _client.shelf.list();
    return response.shelves.map(_mappers.toShelf).toList();
  }
}
