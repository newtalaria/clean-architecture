# shelf_server

Hybrid Serverpod API for the Shelf tutorial. Domain, application, and infrastructure are horizontal. Each endpoint, its spy wire types, and its wire mapper sit together under `presentation/`.

The walkthrough is [the Shelf tutorial](../../docs/tutorial/README.md).

```bash
cp config/passwords.example.yaml config/passwords.yaml
docker compose up --build --detach
dart run bin/main.dart --apply-migrations
dart test
```

The API port in `config/development.yaml` is 8280.
