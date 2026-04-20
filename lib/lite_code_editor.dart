/// A lightweight, customizable code editor widget for Flutter.
///
/// Provides syntax highlighting, auto-indent, autocomplete, and
/// line selection mode with zero external dependencies.
///
/// ## Basic usage
/// ```dart
/// final controller = CodeEditorController(
///   language: CodeLanguage.dart,
///   initialCode: 'void main() {}',
/// );
///
/// CodeEditor(
///   controller: controller,
///   theme: EditorTheme.dark(),
///   onChanged: (code) => print(code),
/// );
/// ```
library;

export 'src/controller/code_editor_controller.dart';
export 'src/highlight/highlight_colors.dart';
export 'src/highlight/syntax_highlighter.dart';
export 'src/highlight/dart_highlighter.dart';
export 'src/theme/editor_theme.dart';
export 'src/widgets/code_editor.dart';
