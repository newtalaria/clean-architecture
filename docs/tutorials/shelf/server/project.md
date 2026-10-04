---
title: Project
description: Create the Serverpod project, move the ports off 8080, and make the empty layer folders before any feature code.
tags: [clean-architecture, tutorial, serverpod]
---

Create the server from the Serverpod CLI so the generator, the client package, and the test tools are real. From a scratch directory:

```bash
serverpod create shelf --template server --no-redis --no-auth --ide none
```

That writes a workspace directory named `shelf`, with `shelf_server`, `shelf_client`, and a `pubspec.yaml` whose `workspace` list is `shelf_client` and `shelf_server`. Move that whole directory:

```bash
mkdir -p examples && mv shelf examples/tutorial
```

The template also writes a greeting endpoint. From `examples/tutorial/shelf_server`, delete `lib/src/greetings/` and `test/integration/greeting_endpoint_test.dart`, then regenerate so `endpoints.dart` no longer imports the sample:

```bash
serverpod generate
```

Shelf does not start from a sample endpoint. If `lib/src/generated/greetings/` is still on disk after generate, delete that folder. `endpoints.dart` must not import the sample.

The template listens on port 8080 and Postgres on 8090. Serverpod 4.0.1 already writes `config/passwords.yaml`. There is no `config/passwords.example.yaml` to copy. The generated passwords file is what `dart test` and `docker compose` read.

Set the ports like this:

- `config/development.yaml`: API `port` and `publicPort` 8280, Insights 8281, web 8282, database `port` 8290. In the comment at the top of that file, change `8080` to `8280`. The comment is not a setting. The `port` values are what the process binds.
- `docker-compose.yaml`: publish Postgres as `8290:5432` and the test database as `9290:5432`. The container still listens on 5432.
- `config/test.yaml`: set the database `port` to 9290. Leave the API, Insights, and web ports at `0`. Those zeros let concurrent tests each take a free port. The file does not contain 8080.
- `config/staging.yaml` and `config/production.yaml`: set the API, Insights, and web `port` values to 8280, 8281, and 8282. Leave `publicPort` at 443 and the database `port` at 5432. Those files describe a remote host, not the local Docker port.

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
  talaria: ^0.3.8
  talaria_serverpod: ^0.2.6
  uuid: ^4.5.3
```

`talaria` stays unused until the instrumentation chapter. Adding it now means `serverpod generate` and `dart test` resolve one pubspec for the whole tutorial.

From `shelf_server`:

```bash
dart pub get
```

Next: [the three failures](failures.md).
