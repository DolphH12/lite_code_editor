# Changelog

All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](https://semver.org/).

---

## [0.1.1] - 2025-01-01

### Improved
- Added dartdoc comments to all public API elements
- Fixed pubspec description length to meet pub.dev requirements

## [0.1.0] - 2025-01-01

### Added
- `CodeEditor` widget — main editor widget with full editing support
- `CodeEditorController` — extends `TextEditingController` with language
  and line selection state
- Dart/Flutter syntax highlighting with token-level coloring:
  - Keywords, built-in types, modifiers
  - Strings with interpolation (`$var`, `${expr}`)
  - Line comments `//`, block comments `/* */`, DartDoc `///`
  - Annotations `@override`, numbers, class names, function names
- Auto-indent on Enter — preserves current indentation level
- Autocomplete suggestion bar — horizontal scrollable chip bar at the
  bottom of the editor, filtered in real time as the user types
- `customKeywords` parameter — inject domain-specific keywords into
  the autocomplete engine
- Line selection mode — tap any line to highlight it and receive its
  index and content via `onLineSelected`
- Synchronized scroll — gutter line numbers scroll in perfect sync
  with the code area
- Horizontal scroll — long lines scroll horizontally without wrapping
- Dark theme (`EditorTheme.dark()`) — VS Code Dark+ inspired palette
- Light theme (`EditorTheme.light()`) — clean light palette
- `EditorTheme` — fully customizable color and typography tokens
- Zero external dependencies — pure Flutter implementation