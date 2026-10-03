---
title: Skills
description: Copy the dependency rule and one layout into a project, then add Flutter UI, Serverpod generate, or the Talaria bootstrap.
tags: [clean-architecture, skills]
---

The [book](../README.md) states the dependency rule. The [Serverpod](../serverpod/README.md) and [Flutter](../flutter/README.md) courses build it three times. This page is how those rules move onto a new project.

Copy two rule files into the project's `.cursor/rules/`, then add the extras that match the stack. The files live in this repository under `skills/`.

## Pick one layout

Copy `dependency-rule.mdc` and exactly one layout file. A second layout rule contradicts the first.

| Layout | Rule | When |
| ------ | ---- | ---- |
| Layer-first | [`layer-first.mdc`](https://github.com/newtalaria/clean-architecture/blob/main/skills/rules/layer-first.mdc) | The feature name repeats inside each layer, including the screen or the endpoint |
| Feature-first | [`feature-first.mdc`](https://github.com/newtalaria/clean-architecture/blob/main/skills/rules/feature-first.mdc) | One folder holds every layer of a feature |
| Hybrid | [`hybrid.mdc`](https://github.com/newtalaria/clean-architecture/blob/main/skills/rules/hybrid.mdc) | Domain and application stay shared. Screens or endpoints are sliced by feature |

[`dependency-rule.mdc`](https://github.com/newtalaria/clean-architecture/blob/main/skills/rules/dependency-rule.mdc) is the same in every layout. Inner code never imports outer code. The composition root is the only place that constructs a repository implementation.

From the root of the new project, with the layout you chose in `LAYOUT` (`layer-first`, `feature-first`, or `hybrid`):

```bash
LAYOUT=hybrid
base=https://raw.githubusercontent.com/newtalaria/clean-architecture/main/skills
mkdir -p .cursor/rules
curl -fsSL "$base/rules/dependency-rule.mdc" -o .cursor/rules/dependency-rule.mdc
curl -fsSL "$base/rules/${LAYOUT}.mdc" -o ".cursor/rules/${LAYOUT}.mdc"
```

If this repository is already on disk, `cp` those two files into `.cursor/rules/` instead of using `curl`.

## Flutter UI

Copy [`flutter-ui.mdc`](https://github.com/newtalaria/clean-architecture/blob/main/skills/rules/flutter-ui.mdc) when the app has a `ui/` folder. Widgets there do not import Riverpod. A tile takes the values it draws. A page test uses `ProviderScope`. A tile test does not.

```bash
base=https://raw.githubusercontent.com/newtalaria/clean-architecture/main/skills
curl -fsSL "$base/rules/flutter-ui.mdc" -o .cursor/rules/flutter-ui.mdc
```

Layer-first and feature-first Flutter apps keep the tile beside the page. Copy this rule when you add a shared `ui/` folder, which is the hybrid layout.

## Serverpod generate and migrate

Copy [`serverpod-generate-migrate`](https://github.com/newtalaria/clean-architecture/blob/main/skills/serverpod-generate-migrate/SKILL.md) into `.cursor/skills/` when the project has `.spy.yaml` or `.spy.yml` files. The skill runs `serverpod generate`, and `serverpod create-migration` when a database model changed. Generated Dart is not hand-edited. The notes samples in `examples/serverpod/` hand-write wire types so `dart test` needs no generator. Leave those packages without a generate step.

```bash
base=https://raw.githubusercontent.com/newtalaria/clean-architecture/main/skills
mkdir -p .cursor/skills/serverpod-generate-migrate
curl -fsSL "$base/serverpod-generate-migrate/SKILL.md" \
  -o .cursor/skills/serverpod-generate-migrate/SKILL.md
```

## Talaria on Flutter

Copy [`talaria-flutter-bootstrap`](https://github.com/newtalaria/clean-architecture/blob/main/skills/talaria-flutter-bootstrap/SKILL.md) into `.cursor/skills/` when the Flutter app should report errors, screens, and HTTP. An empty `TALARIA_API_KEY` leaves the SDK off. Binding init and `runApp` share one zone. The Beamer location reports the screen. `TalariaScreenCapture` wraps the routed child.

```bash
base=https://raw.githubusercontent.com/newtalaria/clean-architecture/main/skills
mkdir -p .cursor/skills/talaria-flutter-bootstrap
curl -fsSL "$base/talaria-flutter-bootstrap/SKILL.md" \
  -o .cursor/skills/talaria-flutter-bootstrap/SKILL.md
```

The worked example is [`examples/flutter/hybrid/lib/bootstrap/talaria_monitoring.dart`](https://github.com/newtalaria/clean-architecture/blob/main/examples/flutter/hybrid/lib/bootstrap/talaria_monitoring.dart).
