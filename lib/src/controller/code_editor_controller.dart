import 'package:flutter/material.dart';
import '../highlight/dart_highlighter.dart';
import '../highlight/syntax_highlighter.dart';

enum CodeLanguage { dart, plainText }

/// TextEditingController personalizado que colorea el texto en tiempo real.
class CodeEditorController extends TextEditingController {
  CodeLanguage _language;
  int? _selectedLine;

  late SyntaxHighlighter _highlighter;

  CodeEditorController({
    String initialCode = '',
    CodeLanguage language = CodeLanguage.dart,
  }) : _language = language,
       super(text: initialCode) {
    _highlighter = _buildHighlighter(language);
  }

  // ── Getters ────────────────────────────────────────────────────────────────

  CodeLanguage get language => _language;
  int? get selectedLine => _selectedLine;
  String get code => text;
  List<String> get lines => text.split('\n');
  SyntaxHighlighter get highlighter => _highlighter;

  // ── Setters ────────────────────────────────────────────────────────────────

  set code(String newCode) {
    value = value.copyWith(
      text: newCode,
      selection: TextSelection.collapsed(offset: newCode.length),
    );
  }

  set language(CodeLanguage lang) {
    _language = lang;
    _highlighter = _buildHighlighter(lang);
    notifyListeners();
  }

  void selectLine(int? lineIndex) {
    if (_selectedLine == lineIndex) return;
    _selectedLine = lineIndex;
    notifyListeners();
  }

  String? get selectedLineContent {
    if (_selectedLine == null) return null;
    final l = lines;
    if (_selectedLine! < 0 || _selectedLine! >= l.length) return null;
    return l[_selectedLine!];
  }

  // ── buildTextSpan: aquí ocurre la magia ───────────────────────────────────

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

  // ── Privado ────────────────────────────────────────────────────────────────

  SyntaxHighlighter _buildHighlighter(CodeLanguage lang) {
    switch (lang) {
      case CodeLanguage.dart:
        return DartHighlighter();
      case CodeLanguage.plainText:
        return _PlainHighlighter();
    }
  }
}

/// Highlighter neutro para texto plano.
class _PlainHighlighter implements SyntaxHighlighter {
  @override
  TextSpan highlight(String code) => TextSpan(
    text: code,
    style: const TextStyle(color: Color(0xFFD4D4D4)),
  );
}
