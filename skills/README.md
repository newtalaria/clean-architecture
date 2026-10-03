# Skills

Rules and skills to copy onto a project. The copy steps are published at [docs/skills](../docs/skills/README.md).

Copy `rules/dependency-rule.mdc` and exactly one layout rule into `.cursor/rules/`. Add `rules/flutter-ui.mdc` for a Flutter `ui/` folder. Copy `serverpod-generate-migrate/` or `talaria-flutter-bootstrap/` into `.cursor/skills/` when the project needs that workflow.

| File | Copy when |
| ---- | --------- |
| `rules/dependency-rule.mdc` | Always |
| `rules/layer-first.mdc` | The feature name repeats inside each layer |
| `rules/feature-first.mdc` | One folder holds every layer of a feature |
| `rules/hybrid.mdc` | Domain and application stay shared. Screens or endpoints are sliced by feature |
| `rules/flutter-ui.mdc` | The app has a `ui/` folder |
| `serverpod-generate-migrate/` | The app has Serverpod spy files |
| `talaria-flutter-bootstrap/` | The Flutter app should report to Talaria |
