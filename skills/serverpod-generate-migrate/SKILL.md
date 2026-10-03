---
name: serverpod-generate-migrate
description: Runs serverpod generate and creates a migration after Serverpod protocol or model files change. Use when editing .spy.yaml or .spy.yml, adding an endpoint wire type, or when the user mentions serverpod generate, create-migration, or apply-migrations.
---

# Serverpod generate and migrate

Generated Dart is the wire and persistence shape. Domain entities stay hand-written. Map between them at the boundary.

## When the project has spy files

| File | Role |
| ---- | ---- |
| `infra/models/*.spy.yaml` | Persistence models. `serverOnly: true`. |
| `presentation/**/*.spy.yml` | Wire DTOs, inputs, enums, and API exceptions the client can share. |

After those files change:

1. `serverpod generate`
2. If a database model changed, `serverpod create-migration`, then apply it with the server's migration flag (`dart run bin/main.dart --apply-migrations` on a standard Serverpod entrypoint).

Do not edit `lib/src/generated/**`. The next generate overwrites it.

Generated protocol types are wire types. They stay in presentation (and the generated client). A use case accepts and returns domain types. The endpoint maps wire to the use case and maps a domain failure onto the API exception.

## When the project has no spy files

The notes samples in this repository hand-write the wire types so `dart test` does not need a generator. Leave those types alone. Do not add a generate step to a package that has no `.spy.yaml` or `.spy.yml`.

## After generate

Register the repository implementation only in the composition root. The endpoint calls the use case. Run the package tests and report the command and the result.
