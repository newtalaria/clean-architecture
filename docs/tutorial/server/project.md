---
title: Project
description: Create the Serverpod project, move the ports off 8080, and make the empty layer folders before any feature code.
tags: [clean-architecture, tutorial, serverpod]
---

Create the server from the Serverpod CLI so the generator, the client package, and the test tools are real. From a scratch directory:

```bash
serverpod create shelf --template server --no-redis --no-auth --ide none
```

That writes a workspace with `shelf_server` and `shelf_client`. Move both under `examples/tutorial/`, with a workspace `pubspec.yaml` that lists them. The template also writes a greeting endpoint. Delete `lib/src/greetings/` and its test. Shelf does not start from a sample endpoint.

The template listens on port 8080 and Postgres on 8090. Change `config/development.yaml`, `config/staging.yaml`, `config/production.yaml`, `config/test.yaml`, and `docker-compose.yaml` so this project uses 8280, 8281, 8282, Postgres 8290, and the test database 9290.

`config/passwords.yaml` is gitignored. The template's `docker-compose.yaml` already contains the database password. Copy the example into place before you run the server or the integration tests:

```bash
cd shelf_server
cp config/passwords.example.yaml config/passwords.yaml
```

## The dependency rule, before any feature

Dependencies point inward. Outer code may import inner code. Inner code never imports outer code.

| Layer | May import | Must not import |
| --- | --- | --- |
| Domain | nothing from the other layers, and not Serverpod | application, infra, presentation, `lib/src/generated/` |
| Application | domain, and its own ports | infra implementations, presentation, `Session` |
| Infrastructure | domain and Serverpod | application, presentation |
| Presentation | application, domain types, generated wire types | `*RepositoryImpl` |
| App | every layer, for construction only | business rules |

Infrastructure and presentation do not import each other. The composition root is the only file that sees a concrete repository.

Make the folders now, empty:

```text
lib/src/domain/shared/exceptions/
lib/src/domain/book/entities/
lib/src/domain/book/value_objects/
lib/src/application/book/
lib/src/application/ports/
lib/src/infra/models/
lib/src/infra/book/
lib/src/presentation/book/dto/
lib/src/presentation/book/input/
lib/src/presentation/shared/
lib/src/app/
```

You will add `shelf/` the same way after the book slice runs. Do not put a use case under `presentation/book/` later because the endpoint is there.

Add the packages the later chapters import. In `shelf_server/pubspec.yaml`:

```yaml
dependencies:
  serverpod: 4.0.1
  serverpod_cloud_storage: 4.0.1
  talaria: ^0.3.7
  talaria_serverpod: ^0.2.5
  uuid: ^4.5.3
```

`talaria` stays unused until the instrumentation chapter. Adding it now means `serverpod generate` and `dart test` resolve one pubspec for the whole tutorial.

From `shelf_server`:

```bash
dart pub get
```

Next: [the three failures](failures.md).
