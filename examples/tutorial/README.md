# Shelf

The long clean-architecture tutorial. Both apps are hybrid.

- [Read it](../../docs/tutorial/README.md)
- `shelf_server` and `shelf_client` are the Serverpod project. The API listens on port 8280 so it does not take Talaria's 8080.
- `shelf_flutter` is the client. It depends on `shelf_client`.

```bash
cd shelf_server
cp config/passwords.example.yaml config/passwords.yaml
docker compose up --build --detach
dart run bin/main.dart --apply-migrations
```

In another terminal:

```bash
cd shelf_flutter
flutter run -d chrome
```
