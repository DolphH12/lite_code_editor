import 'package:flutter/material.dart';
import '../highlight/dart_highlighter.dart';
import '../highlight/syntax_highlighter.dart';

/// The supported languages for syntax highlighting.
enum CodeLanguage {
  /// Dart and Flutter code.
  dart,

  /// Plain text with no highlighting.
  plainText,
}

/// Controls the content, language, and selection state of a [CodeEditor].
///
/// Extends [TextEditingController] so it integrates natively with
/// Flutter's text system. Overrides [buildTextSpan] to apply
/// syntax highlighting in real time.
///
/// ## Example
/// ```dart
/// final controller = CodeEditorController(
///   initialCode: 'void main() {}',
///   language: CodeLanguage.dart,
/// );
///
/// // Read current code
/// print(controller.code);
///
/// // Replace code programmatically
/// controller.code = 'void main() { print("hi"); }';
///
/// // Always dispose
/// controller.dispose();
/// ```
class CodeEditorController extends TextEditingController {
  CodeLanguage _language;
  int? _selectedLine;
  late SyntaxHighlighter _highlighter;

  /// Creates a [CodeEditorController].
  ///
  /// [initialCode] sets the starting content of the editor.
  /// [language] determines which syntax highlighter is applied.
  CodeEditorController({
    String initialCode = '',
    CodeLanguage language = CodeLanguage.dart,
  }) : _language = language,
       super(text: initialCode) {
    _highlighter = _buildHighlighter(language);
  }

  /// The current code in the editor.
  String get code => text;

  /// Replaces all code in the editor and moves the cursor to the end.
  set code(String newCode) {
    value = value.copyWith(
      text: newCode,
      selection: TextSelection.collapsed(offset: newCode.length),
    );
  }

  /// The active syntax highlighting language.
  CodeLanguage get language => _language;

  /// Changes the active language and re-highlights the code immediately.
  set language(CodeLanguage lang) {
    _language = lang;
    _highlighter = _buildHighlighter(lang);
    notifyListeners();
  }

  /// The 0-based index of the currently selected line, or `null` if
  /// no line is selected.
  int? get selectedLine => _selectedLine;

  /// The content of the currently selected line, or `null` if no line
  /// is selected or the index is out of range.
  String? get selectedLineContent {
    if (_selectedLine == null) return null;
    final l = lines;
    if (_selectedLine! < 0 || _selectedLine! >= l.length) return null;
    return l[_selectedLine!];
  }

  /// All lines of the current code split by newline.
  List<String> get lines => text.split('\n');

  /// The active [SyntaxHighlighter] instance.
  SyntaxHighlighter get highlighter => _highlighter;

  /// Selects a line by its 0-based [lineIndex].
  ///
  /// Pass `null` to deselect the current line.
  void selectLine(int? lineIndex) {
    if (_selectedLine == lineIndex) return;
    _selectedLine = lineIndex;
    notifyListeners();
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final highlighted = _highlighter.highlight(text);
    return TextSpan(
      style: style,
      children: highlighted.children ?? [highlighted],
    );
  }

  SyntaxHighlighter _buildHighlighter(CodeLanguage lang) {
    switch (lang) {
      case CodeLanguage.dart:
        return DartHighlighter();
      case CodeLanguage.plainText:
        return _PlainHighlighter();
    }
  }
}

/// A no-op highlighter for plain text — returns the code unstyled.
class _PlainHighlighter implements SyntaxHighlighter {
  @override
  TextSpan highlight(String code) => TextSpan(
    text: code,
    style: const TextStyle(color: Color(0xFFD4D4D4)),
  );
}
