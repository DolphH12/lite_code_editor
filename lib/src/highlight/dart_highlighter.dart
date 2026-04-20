import 'package:flutter/material.dart';
import 'highlight_colors.dart';
import 'syntax_highlighter.dart';

/// Syntax highlighter for Dart and Flutter code.
///
/// Tokenizes the source using a single [RegExp] pass and maps each
/// token to a color defined in [HighlightColors].
class DartHighlighter implements SyntaxHighlighter {
  /// All reserved Dart keywords recognized by this highlighter.
  static const keywords = {
    'abstract',
    'as',
    'assert',
    'async',
    'await',
    'break',
    'case',
    'catch',
    'class',
    'const',
    'continue',
    'covariant',
    'default',
    'deferred',
    'do',
    'dynamic',
    'else',
    'enum',
    'export',
    'extends',
    'extension',
    'external',
    'factory',
    'false',
    'final',
    'finally',
    'for',
    'Function',
    'get',
    'hide',
    'if',
    'implements',
    'import',
    'in',
    'interface',
    'is',
    'late',
    'library',
    'mixin',
    'new',
    'null',
    'on',
    'operator',
    'part',
    'required',
    'rethrow',
    'return',
    'sealed',
    'set',
    'show',
    'static',
    'super',
    'switch',
    'sync',
    'this',
    'throw',
    'true',
    'try',
    'typedef',
    'var',
    'void',
    'when',
    'while',
    'with',
    'yield',
  };

  /// Built-in Dart types recognized by this highlighter.
  static const builtinTypes = {
    'bool',
    'double',
    'Duration',
    'Enum',
    'Future',
    'int',
    'Iterable',
    'Iterator',
    'List',
    'Map',
    'Never',
    'Null',
    'num',
    'Object',
    'Record',
    'Set',
    'Stream',
    'String',
    'Symbol',
    'Type',
    'Widget',
  };

  // ── Regex principal: orden importa (más específico primero) ────────────────
  static final _tokenPattern = RegExp(
    r'(?<dartdoc>///.*?$)' // 1. dartdoc ///
    r'|(?<comment>//.*?$)' // 2. comentario //
    r'|(?<blockComment>/\*[\s\S]*?\*/)' // 3. comentario bloque /* */
    r'|(?<strTripleDouble>"""[\s\S]*?""")' // 4. string triple doble
    r"|(?<strTripleSingle>'''[\s\S]*?''')" // 5. string triple simple
    r'|(?<strDouble>"(?:[^"\\]|\\.)*")' // 6. string doble
    r"|(?<strSingle>'(?:[^'\\]|\\.)*')" // 7. string simple
    r'|(?<annotation>@\w+)' // 8. @anotación
    r'|(?<number>\b\d+\.?\d*\b)' // 9. número
    r'|(?<word>\b[a-zA-Z_]\w*\b)' // 10. palabra
    r'|(?<punct>[{}()\[\];:.,<>!=+\-*/&|^~?%])' // 11. puntuación
    r'|(?<whitespace>\s+)', // 12. espacios/saltos
    multiLine: true,
  ); // mismo contenido, quita el _

  /// Highlights [code] and returns a [TextSpan] tree.
  @override
  TextSpan highlight(String code) {
    if (code.isEmpty) return const TextSpan(text: '');

    final spans = <TextSpan>[];
    int lastEnd = 0;

    for (final match in _tokenPattern.allMatches(code)) {
      // Texto no capturado entre tokens → plainText
      if (match.start > lastEnd) {
        spans.add(
          TextSpan(
            text: code.substring(lastEnd, match.start),
            style: const TextStyle(color: HighlightColors.plainText),
          ),
        );
      }

      spans.add(_colorize(match, code));
      lastEnd = match.end;
    }

    // Resto al final
    if (lastEnd < code.length) {
      spans.add(
        TextSpan(
          text: code.substring(lastEnd),
          style: const TextStyle(color: HighlightColors.plainText),
        ),
      );
    }

    return TextSpan(children: spans);
  }

  TextSpan _colorize(RegExpMatch match, String code) {
    final text = match[0]!;

    if (match.namedGroup('dartdoc') != null) {
      return TextSpan(
        text: text,
        style: const TextStyle(color: HighlightColors.dartDoc),
      );
    }

    if (match.namedGroup('comment') != null ||
        match.namedGroup('blockComment') != null) {
      return TextSpan(
        text: text,
        style: const TextStyle(color: HighlightColors.comment),
      );
    }

    if (match.namedGroup('strTripleDouble') != null ||
        match.namedGroup('strTripleSingle') != null ||
        match.namedGroup('strDouble') != null ||
        match.namedGroup('strSingle') != null) {
      return _colorizeString(text);
    }

    if (match.namedGroup('annotation') != null) {
      return TextSpan(
        text: text,
        style: const TextStyle(color: HighlightColors.annotation),
      );
    }

    if (match.namedGroup('number') != null) {
      return TextSpan(
        text: text,
        style: const TextStyle(color: HighlightColors.number),
      );
    }

    if (match.namedGroup('word') != null) {
      return _colorizeWord(text, match, code);
    }

    if (match.namedGroup('punct') != null) {
      return TextSpan(
        text: text,
        style: const TextStyle(color: HighlightColors.punctuation),
      );
    }

    // whitespace / no clasificado
    return TextSpan(
      text: text,
      style: const TextStyle(color: HighlightColors.plainText),
    );
  }

  /// Coloriza palabras según contexto.
  TextSpan _colorizeWord(String text, RegExpMatch match, String code) {
    // Keyword
    if (keywords.contains(text)) {
      return TextSpan(
        text: text,
        style: const TextStyle(color: HighlightColors.keyword),
      );
    }

    // Tipo built-in
    if (builtinTypes.contains(text)) {
      return TextSpan(
        text: text,
        style: const TextStyle(color: HighlightColors.builtinType),
      );
    }

    // UpperCamelCase → nombre de clase
    if (RegExp(r'^[A-Z][a-zA-Z0-9]*$').hasMatch(text)) {
      return TextSpan(
        text: text,
        style: const TextStyle(color: HighlightColors.className),
      );
    }

    // Seguido de '(' → nombre de función/método
    final after = code.substring(match.end).trimLeft();
    if (after.startsWith('(')) {
      return TextSpan(
        text: text,
        style: const TextStyle(color: HighlightColors.functionName),
      );
    }

    return TextSpan(
      text: text,
      style: const TextStyle(color: HighlightColors.plainText),
    );
  }

  /// Coloriza strings con interpolación $var / ${expr}.
  TextSpan _colorizeString(String text) {
    final interpPattern = RegExp(r'\$\{[^}]*\}|\$[a-zA-Z_]\w*');
    final parts = <TextSpan>[];
    int last = 0;

    for (final m in interpPattern.allMatches(text)) {
      if (m.start > last) {
        parts.add(
          TextSpan(
            text: text.substring(last, m.start),
            style: const TextStyle(color: HighlightColors.string),
          ),
        );
      }
      parts.add(
        TextSpan(
          text: m[0],
          style: const TextStyle(color: HighlightColors.stringInterp),
        ),
      );
      last = m.end;
    }

    if (last < text.length) {
      parts.add(
        TextSpan(
          text: text.substring(last),
          style: const TextStyle(color: HighlightColors.string),
        ),
      );
    }

    return parts.isEmpty
        ? TextSpan(
            text: text,
            style: const TextStyle(color: HighlightColors.string),
          )
        : TextSpan(children: parts);
  }
}
